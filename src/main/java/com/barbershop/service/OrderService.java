package com.barbershop.service;

import com.barbershop.model.dto.customer.CreateCustomerRequest;
import com.barbershop.model.dto.customer.CustomerDTO;
import com.barbershop.model.dto.order.*;
import com.barbershop.model.entity.Customer;
import com.barbershop.model.entity.Employee;
import com.barbershop.model.entity.Order;
import com.barbershop.model.entity.OrderItem;
import com.barbershop.repository.CustomerRepository;
import com.barbershop.repository.EmployeeRepository;
import com.barbershop.repository.OrderRepository;
import com.barbershop.repository.specification.OrderSpecification;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderService {

    private final OrderRepository orderRepository;
    private final EmployeeRepository employeeRepository;
    private final CustomerRepository customerRepository;
    private final CustomerService customerService;

    @Transactional
    public OrderDTO createOrder(CreateOrderRequest request) {
        log.info("Creating order with request: {}", request);
        // Get or create customer
        Customer customer;
        if (request.getCustomerId() != null) {
            customer = customerRepository.findByIdActive(request.getCustomerId())
                    .orElseThrow(() -> new RuntimeException("Customer not found"));
        } else {
            CreateCustomerRequest custRequest = CreateCustomerRequest.builder()
                    .name(request.getCustomerName())
                    .phone(request.getCustomerPhone())
                    .email(request.getCustomerEmail())
                    .build();
            CustomerDTO custDTO = customerService.getOrCreateCustomer(custRequest);
            customer = new Customer();
            customer.setId(custDTO.getId());
            customer.setName(custDTO.getName());
            customer.setPhone(custDTO.getPhone());
            customer.setEmail(custDTO.getEmail());
            log.info("New customer created with ID: {}", customer.getId());
        }

        // Calculate subtotal
        BigDecimal subtotal = BigDecimal.ZERO;
        if (request.getOrderItems() != null && !request.getOrderItems().isEmpty()) {
            subtotal = request.getOrderItems().stream()
                    .map(item -> item.getUnitPrice().multiply(new BigDecimal(item.getQuantity())))
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
        }

        // Apply discount
        BigDecimal discountAmount = request.getDiscountAmount() != null ? request.getDiscountAmount() : BigDecimal.ZERO;
        BigDecimal afterDiscount = subtotal.subtract(discountAmount);

        // Calculate tax
        BigDecimal taxPercentage = request.getTaxPercentage() != null ? request.getTaxPercentage() : BigDecimal.ZERO;
        BigDecimal taxAmount = afterDiscount.multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);

        // Calculate total
        BigDecimal totalAmount = afterDiscount.add(taxAmount);

        Order order = Order.builder()
                .customer(customer)
                .status(Order.OrderStatus.PENDING)
                .totalAmount(totalAmount)
                .discountAmount(discountAmount)
                .taxPercentage(taxPercentage)
                .taxAmount(taxAmount)
                .notes(request.getNotes())
                .build();

        Order savedOrder = orderRepository.save(order);
        log.info("Order saved with ID: {}", savedOrder.getId());
        // Add order items with tax calculation
        if (request.getOrderItems() != null && !request.getOrderItems().isEmpty()) {
            List<OrderItem> orderItems = request.getOrderItems().stream()
                    .map(item -> {
                        // Use provided totalPrice if available, otherwise calculate
                        BigDecimal itemTotal = item.getTotalPrice() != null
                            ? item.getTotalPrice()
                            : item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));

                        // Use provided taxAmount if available, otherwise calculate
                        BigDecimal itemTax = item.getTaxAmount() != null
                            ? item.getTaxAmount()
                            : itemTotal.multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);

                        OrderItem.OrderItemBuilder orderItemBuilder = OrderItem.builder()
                                .order(savedOrder)
                                .productId(item.getProductId())
                                .productName(item.getProductName())
                                .quantity(item.getQuantity())
                                .unitPrice(item.getUnitPrice())
                                .totalPrice(itemTotal)
                                .taxPercentage(taxPercentage)
                                .taxAmount(itemTax)
                                .status(OrderItem.ItemStatus.READY);

                        // Assign employee if provided
                        if (item.getAssignedEmployeeId() != null) {
                            Employee employee = employeeRepository.findByIdActive(item.getAssignedEmployeeId())
                                    .orElseThrow(() -> new RuntimeException("Employee not found with id: " + item.getAssignedEmployeeId()));
                            orderItemBuilder.assignedEmployee(employee);
                        }

                        return orderItemBuilder.build();
                    })
                    .collect(Collectors.toList());
            savedOrder.setOrderItems(orderItems);
        }

        Order finalOrder = orderRepository.save(savedOrder);
        return mapToDTO(finalOrder);
    }

    public Page<OrderDTO> getAllOrders(OrderFilterRequest filter, Pageable pageable) {
        Page<Order> orders = orderRepository.findAll(OrderSpecification.withFilters(filter), pageable);
        return orders.map(this::mapToDTO);
    }

    public OrderDTO getOrderById(Long id) {
        Order order = orderRepository.findByIdActive(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
        return mapToDTO(order);
    }

    public OrderDTO assignOrderToEmployee(Long orderId, AssignOrderRequest request) {
        log.info("Assigning order ID {} to employee ID {}", orderId, request.getEmployeeId());
        Order order = orderRepository.findByIdActive(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        Employee employee = employeeRepository.findByIdActive(request.getEmployeeId())
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        order.setAssignedEmployee(employee);
        order.setStatus(Order.OrderStatus.IN_PROGRESS);
        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    public OrderDTO updateOrder(Long id, UpdateOrderRequest request) {
        log.info("Updating order ID {} with request: {}", id, request);
        Order order = orderRepository.findByIdActive(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));

        // Check if order can be modified (not completed or cancelled)
        if (order.getStatus() == Order.OrderStatus.COMPLETED || order.getStatus() == Order.OrderStatus.CANCELLED) {
            throw new RuntimeException("Cannot modify a completed or cancelled order");
        }

        if (request.getAssignedEmployeeId() != null) {
            Employee employee = employeeRepository.findByIdActive(request.getAssignedEmployeeId())
                    .orElseThrow(() -> new RuntimeException("Employee not found"));
            order.setAssignedEmployee(employee);
        }

        if (request.getStatus() != null) {
            order.setStatus(Order.OrderStatus.valueOf(request.getStatus()));
        }

        if (request.getNotes() != null) {
            order.setNotes(request.getNotes());
        }

        // Update discount and tax if provided
        if (request.getDiscountAmount() != null) {
            order.setDiscountAmount(request.getDiscountAmount());
        }
        if (request.getTaxPercentage() != null) {
            order.setTaxPercentage(request.getTaxPercentage());
        }

        // Update order items if provided
        if (request.getOrderItems() != null && !request.getOrderItems().isEmpty()) {
            order.getOrderItems().clear();
            BigDecimal subtotal = BigDecimal.ZERO;

            for (CreateOrderItemRequest itemRequest : request.getOrderItems()) {
                BigDecimal itemTotal = itemRequest.getUnitPrice().multiply(new BigDecimal(itemRequest.getQuantity()));
                BigDecimal taxPercentage = request.getTaxPercentage() != null ? request.getTaxPercentage() : order.getTaxPercentage();
                BigDecimal itemTax = itemTotal.multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);

                OrderItem orderItem = OrderItem.builder()
                        .order(order)
                        .productName(itemRequest.getProductName())
                        .quantity(itemRequest.getQuantity())
                        .unitPrice(itemRequest.getUnitPrice())
                        .totalPrice(itemTotal)
                        .taxPercentage(taxPercentage)
                        .taxAmount(itemTax)
                        .status(OrderItem.ItemStatus.READY)
                        .build();
                order.getOrderItems().add(orderItem);
                subtotal = subtotal.add(itemTotal);
            }

            // Recalculate total with discount and tax
            BigDecimal discountAmount = request.getDiscountAmount() != null ? request.getDiscountAmount() : order.getDiscountAmount();
            BigDecimal afterDiscount = subtotal.subtract(discountAmount);
            BigDecimal taxPercentage = request.getTaxPercentage() != null ? request.getTaxPercentage() : order.getTaxPercentage();
            BigDecimal taxAmount = afterDiscount.multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
            BigDecimal totalAmount = afterDiscount.add(taxAmount);

            order.setTotalAmount(totalAmount);
            order.setTaxAmount(taxAmount);
        } else if (request.getDiscountAmount() != null || request.getTaxPercentage() != null) {
            // Recalculate totals if only discount or tax changed
            BigDecimal subtotal = order.getOrderItems().stream()
                    .map(OrderItem::getTotalPrice)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            BigDecimal discountAmount = request.getDiscountAmount() != null ? request.getDiscountAmount() : order.getDiscountAmount();
            BigDecimal afterDiscount = subtotal.subtract(discountAmount);
            BigDecimal taxPercentage = request.getTaxPercentage() != null ? request.getTaxPercentage() : order.getTaxPercentage();
            BigDecimal taxAmount = afterDiscount.multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);
            BigDecimal totalAmount = afterDiscount.add(taxAmount);

            order.setTotalAmount(totalAmount);
            order.setTaxAmount(taxAmount);

            // Update item tax amounts
            if (request.getTaxPercentage() != null) {
                for (OrderItem item : order.getOrderItems()) {
                    item.setTaxPercentage(request.getTaxPercentage());
                    item.setTaxAmount(item.getTotalPrice().multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
                }
            }
        }

        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    public OrderDTO assignItemToEmployee(Long orderId, Long itemId, Long employeeId) {
        log.info("Assigning item ID {} of order ID {} to employee ID {}", itemId, orderId, employeeId);
        Order order = orderRepository.findByIdActive(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        Employee employee = employeeRepository.findByIdActive(employeeId)
                .orElseThrow(() -> new RuntimeException("Employee not found"));

        OrderItem item = order.getOrderItems().stream()
                .filter(oi -> oi.getId().equals(itemId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Order item not found"));

        // Check if item can be reassigned (not completed)
        if (item.getStatus() == OrderItem.ItemStatus.COMPLETED) {
            throw new RuntimeException("Cannot reassign a completed item");
        }

        item.setAssignedEmployee(employee);
        item.setStatus(OrderItem.ItemStatus.IN_PROGRESS);
        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    public OrderDTO updateItemStatus(Long orderId, Long itemId, String status) {
        log.info("Updating status of item ID {} in order ID {} to {}", itemId, orderId, status);
        Order order = orderRepository.findByIdActive(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        OrderItem item = order.getOrderItems().stream()
                .filter(oi -> oi.getId().equals(itemId))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Order item not found"));

        OrderItem.ItemStatus newStatus = OrderItem.ItemStatus.valueOf(status);
        item.setStatus(newStatus);

        if (newStatus == OrderItem.ItemStatus.COMPLETED) {
            item.setCompletedAt(java.time.LocalDateTime.now());
        }

        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    public BillPreviewDTO getBillPreview(Long orderId) {
        log.info("Generating bill preview for order ID {}", orderId);
        Order order = orderRepository.findByIdActive(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        BigDecimal subtotal = BigDecimal.ZERO;
        List<BillPreviewDTO.BillItemDTO> billItems = new java.util.ArrayList<>();

        for (OrderItem item : order.getOrderItems()) {
            billItems.add(BillPreviewDTO.BillItemDTO.builder()
                    .itemId(item.getId())
                    .productName(item.getProductName())
                    .quantity(item.getQuantity())
                    .unitPrice(item.getUnitPrice())
                    .totalPrice(item.getTotalPrice())
                    .taxPercentage(item.getTaxPercentage())
                    .taxAmount(item.getTaxAmount())
                    .build());
            subtotal = subtotal.add(item.getTotalPrice());
        }

        return BillPreviewDTO.builder()
                .orderId(order.getId())
                .customerName(order.getCustomer().getName())
                .customerPhone(order.getCustomer().getPhone())
                .items(billItems)
                .subtotal(subtotal)
                .discountAmount(order.getDiscountAmount())
                .taxPercentage(order.getTaxPercentage())
                .taxAmount(order.getTaxAmount())
                .total(order.getTotalAmount())
                .notes(order.getNotes())
                .build();
    }

    public OrderDTO completeOrderWithModifications(Long orderId, CompleteOrderRequest request) {
        log.info("Completing order ID {} with modifications: {}", orderId, request);
        Order order = orderRepository.findByIdActive(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        // Check if order can be completed
        if (order.getStatus() == Order.OrderStatus.COMPLETED || order.getStatus() == Order.OrderStatus.CANCELLED) {
            throw new RuntimeException("This order is already completed or cancelled");
        }

        // Update items with modifications if provided
        if (request.getItemUpdates() != null && !request.getItemUpdates().isEmpty()) {
            BigDecimal totalAmount = BigDecimal.ZERO;

            for (CompleteOrderRequest.OrderItemUpdate itemUpdate : request.getItemUpdates()) {
                OrderItem item = order.getOrderItems().stream()
                        .filter(oi -> oi.getId().equals(itemUpdate.getItemId()))
                        .findFirst()
                        .orElseThrow(() -> new RuntimeException("Item not found: " + itemUpdate.getItemId()));

                if (itemUpdate.getQuantity() != null) {
                    item.setQuantity(itemUpdate.getQuantity());
                }
                if (itemUpdate.getUnitPrice() != null) {
                    item.setUnitPrice(itemUpdate.getUnitPrice());
                }

                // Recalculate total price
                item.setTotalPrice(item.getUnitPrice().multiply(new BigDecimal(item.getQuantity())));
                item.setStatus(OrderItem.ItemStatus.COMPLETED);
                item.setCompletedAt(java.time.LocalDateTime.now());

                totalAmount = totalAmount.add(item.getTotalPrice());
            }

            order.setTotalAmount(totalAmount);
        }

        // Update order notes if provided
        if (request.getNotes() != null) {
            order.setNotes(request.getNotes());
        }

        // Mark order as completed
        order.complete();

        // Update employee earnings
        for (OrderItem item : order.getOrderItems()) {
            if (item.getAssignedEmployee() != null) {
                Employee employee = item.getAssignedEmployee();
                if (employee.getTotalEarned() == null) {
                    employee.setTotalEarned(BigDecimal.ZERO);
                }
                employee.setTotalEarned(employee.getTotalEarned().add(item.getTotalPrice()));
                employeeRepository.save(employee);
            }
        }

        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    public OrderDTO completeOrder(Long orderId) {
        log.info("Completing order ID {}", orderId);
        Order order = orderRepository.findByIdActive(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + orderId));

        order.complete();

        // Update employee earnings for items with assigned employees
        for (OrderItem item : order.getOrderItems()) {
            if (item.getAssignedEmployee() != null) {
                Employee employee = item.getAssignedEmployee();
                if (employee.getTotalEarned() == null) {
                    employee.setTotalEarned(BigDecimal.ZERO);
                }
                employee.setTotalEarned(employee.getTotalEarned().add(item.getTotalPrice()));
                employeeRepository.save(employee);
            }
            item.setStatus(OrderItem.ItemStatus.COMPLETED);
            item.setCompletedAt(java.time.LocalDateTime.now());
        }

        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    public void deleteOrder(Long id) {
        Order order = orderRepository.findByIdActive(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
        order.softDelete();
        orderRepository.save(order);
    }

    public OrderDTO cancelOrder(Long id, String reason) {
        log.info("Cancelling order ID {} for reason: {}", id, reason);
        Order order = orderRepository.findByIdActive(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));

        if (order.getStatus() == Order.OrderStatus.COMPLETED) {
            throw new RuntimeException("Cannot cancel a completed order");
        }

        order.setStatus(Order.OrderStatus.CANCELLED);
        order.setNotes("Cancelled: " + (reason != null ? reason : "No reason provided"));
        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }


    public Page<OrderDTO> getOrdersByStatus(String status, Pageable pageable) {
        Page<Order> orders = orderRepository.findByStatus(status, pageable);
        return orders.map(this::mapToDTO);
    }

    public OrderDTO applyDiscountAndTax(Long id, ApplyDiscountTaxRequest request) {
        log.info("Applying discount and tax to order ID {}: {}", id, request);
        Order order = orderRepository.findByIdActive(id)
                .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));

        // Check if order can be modified (not completed or cancelled)
        if (order.getStatus() == Order.OrderStatus.COMPLETED || order.getStatus() == Order.OrderStatus.CANCELLED) {
            throw new RuntimeException("Cannot modify a completed or cancelled order");
        }

        // Calculate subtotal from items
        BigDecimal subtotal = order.getOrderItems().stream()
                .map(OrderItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Apply discount and tax
        BigDecimal discountAmount = request.getDiscountAmount() != null ? request.getDiscountAmount() : BigDecimal.ZERO;
        BigDecimal afterDiscount = subtotal.subtract(discountAmount);

        BigDecimal taxPercentage = request.getTaxPercentage() != null ? request.getTaxPercentage() : BigDecimal.ZERO;
        BigDecimal taxAmount = afterDiscount.multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP);

        // Update order with discount and tax
        order.setDiscountAmount(discountAmount);
        order.setTaxPercentage(taxPercentage);
        order.setTaxAmount(taxAmount);
        order.setTotalAmount(afterDiscount.add(taxAmount));

        // Update each item with tax information
        for (OrderItem item : order.getOrderItems()) {
            item.setTaxPercentage(taxPercentage);
            item.setTaxAmount(item.getTotalPrice().multiply(taxPercentage).divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
        }

        Order updated = orderRepository.save(order);
        return mapToDTO(updated);
    }

    private OrderDTO mapToDTO(Order order) {
        return OrderDTO.builder()
                .id(order.getId())
                .customerId(order.getCustomer().getId())
                .customerName(order.getCustomer().getName())
                .assignedEmployeeId(order.getAssignedEmployee() != null ? order.getAssignedEmployee().getId() : null)
                .assignedEmployeeName(order.getAssignedEmployee() != null ? order.getAssignedEmployee().getName() : null)
                .status(order.getStatus().name())
                .totalAmount(order.getTotalAmount())
                .discountAmount(order.getDiscountAmount())
                .taxPercentage(order.getTaxPercentage())
                .taxAmount(order.getTaxAmount())
                .notes(order.getNotes())
                .createdAt(order.getCreatedAt())
                .completedAt(order.getCompletedAt())
                .orderItems(order.getOrderItems().stream()
                        .map(item -> OrderItemDTO.builder()
                                .id(item.getId())
                                .productName(item.getProductName())
                                .quantity(item.getQuantity())
                                .unitPrice(item.getUnitPrice())
                                .totalPrice(item.getTotalPrice())
                                .taxPercentage(item.getTaxPercentage())
                                .taxAmount(item.getTaxAmount())
                                .status(item.getStatus().name())
                                .assignedEmployeeId(item.getAssignedEmployee() != null ? item.getAssignedEmployee().getId() : null)
                                .assignedEmployeeName(item.getAssignedEmployee() != null ? item.getAssignedEmployee().getName() : null)
                                .completedAt(item.getCompletedAt())
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }
}

