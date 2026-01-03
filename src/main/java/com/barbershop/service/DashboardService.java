package com.barbershop.service;

import com.barbershop.model.dto.dashboard.DashboardSummaryDTO;
import com.barbershop.model.entity.Employee;
import com.barbershop.model.entity.Order;
import com.barbershop.repository.CustomerRepository;
import com.barbershop.repository.EmployeeRepository;
import com.barbershop.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Service for dashboard statistics and summaries
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DashboardService {

    private final OrderRepository orderRepository;
    private final EmployeeRepository employeeRepository;
    private final CustomerRepository customerRepository;

    /**
     * Get comprehensive dashboard summary
     */
    public DashboardSummaryDTO getDashboardSummary() {
        log.info("Generating dashboard summary");

        // Use count queries for better performance - no need to load all records
        long totalOrders = orderRepository.countAllActive();
        long totalEmployees = employeeRepository.countAllActive();
        long activeEmployees = employeeRepository.countByStatus(Employee.EmployeeStatus.ACTIVE);
        long inactiveEmployees = totalEmployees - activeEmployees;
        long totalCustomers = customerRepository.countAllActive();

        // Count orders by status efficiently
        long completedOrdersCount = orderRepository.countByStatus(Order.OrderStatus.COMPLETED);
        long pendingOrders = orderRepository.countByStatus(Order.OrderStatus.PENDING)
                           + orderRepository.countByStatus(Order.OrderStatus.IN_PROGRESS);

        // Calculate total revenue from completed orders only
        BigDecimal totalRevenue = orderRepository.sumTotalAmountByStatus(Order.OrderStatus.COMPLETED);
        if (totalRevenue == null) {
            totalRevenue = BigDecimal.ZERO;
        }

        // Calculate monthly revenue (current month)
        YearMonth currentMonth = YearMonth.now();
        LocalDateTime startOfMonth = currentMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = currentMonth.atEndOfMonth().atTime(23, 59, 59);
        BigDecimal monthlyRevenue = orderRepository.sumTotalAmountByStatusAndDateRange(
                Order.OrderStatus.COMPLETED, startOfMonth, endOfMonth);
        if (monthlyRevenue == null) {
            monthlyRevenue = BigDecimal.ZERO;
        }

        // Calculate yearly revenue (current year)
        int currentYear = LocalDateTime.now().getYear();
        LocalDateTime startOfYear = LocalDateTime.of(currentYear, 1, 1, 0, 0, 0);
        LocalDateTime endOfYear = LocalDateTime.of(currentYear, 12, 31, 23, 59, 59);
        BigDecimal yearlyRevenue = orderRepository.sumTotalAmountByStatusAndDateRange(
                Order.OrderStatus.COMPLETED, startOfYear, endOfYear);
        if (yearlyRevenue == null) {
            yearlyRevenue = BigDecimal.ZERO;
        }

        // Get recent 50 orders - fetch only what we need
        PageRequest recentOrdersPage = PageRequest.of(0, 50,
                org.springframework.data.domain.Sort.by(org.springframework.data.domain.Sort.Direction.DESC, "createdAt"));
        List<Order> recentOrdersList = orderRepository.findAllActive(recentOrdersPage).getContent();

        List<DashboardSummaryDTO.RecentOrderDTO> recentOrders = recentOrdersList.stream()
                .map(order -> {
                    // Get assigned employee from first order item
                    String employeeName = order.getOrderItems().stream()
                            .filter(item -> item.getAssignedEmployee() != null)
                            .findFirst()
                            .map(item -> item.getAssignedEmployee().getName())
                            .orElse("Chưa gán");

                    return DashboardSummaryDTO.RecentOrderDTO.builder()
                            .id(order.getId())
                            .customerName(order.getCustomer() != null ? order.getCustomer().getName() : "N/A")
                            .assignedEmployeeName(employeeName)
                            .totalAmount(order.getTotalAmount())
                            .completedAt(order.getCompletedAt() != null ? order.getCompletedAt().toString() : order.getCreatedAt().toString())
                            .status(order.getStatus().name())
                            .build();
                })
                .collect(Collectors.toList());

        // Calculate top employees based on completed order items
        // Fetch only completed orders for this calculation
        PageRequest completedOrdersPage = PageRequest.of(0, 1000);
        List<Order> completedOrders = orderRepository.findByStatusActive(
                Order.OrderStatus.COMPLETED, completedOrdersPage).getContent();

        Map<Long, DashboardSummaryDTO.TopEmployeeDTO> employeeStats = new HashMap<>();
        log.debug("Completed orders count for top employees: {}", completedOrders.size());

        // Iterate through completed orders and their items
        completedOrders.forEach(order -> {
            order.getOrderItems().stream()
                    .filter(item -> item.getAssignedEmployee() != null)
                    .filter(item -> item.getStatus() == com.barbershop.model.entity.OrderItem.ItemStatus.COMPLETED)
                    .forEach(item -> {
                        Employee emp = item.getAssignedEmployee();
                        Long empId = emp.getId();
                        DashboardSummaryDTO.TopEmployeeDTO stats = employeeStats.getOrDefault(empId,
                                DashboardSummaryDTO.TopEmployeeDTO.builder()
                                        .id(empId)
                                        .name(emp.getName())
                                        .orderCount(0L)
                                        .revenue(BigDecimal.ZERO)
                                        .build());

                        stats.setOrderCount(stats.getOrderCount() + 1);
                        stats.setRevenue(stats.getRevenue().add(item.getCommissionAmount() != null ? item.getCommissionAmount() : BigDecimal.ZERO));
                        employeeStats.put(empId, stats);
                    });
        });

        List<DashboardSummaryDTO.TopEmployeeDTO> topEmployees = employeeStats.values().stream()
                .sorted((a, b) -> b.getOrderCount().compareTo(a.getOrderCount()))
                .limit(5)
                .collect(Collectors.toList());

        log.info("Top employees count: {}", topEmployees.size());

        // Calculate top customers based on completed orders
        Map<Long, DashboardSummaryDTO.TopCustomerDTO> customerStats = new HashMap<>();
        log.debug("Calculating top customers from completed orders");

        completedOrders.forEach(order -> {
            if (order.getCustomer() != null) {
                Long customerId = order.getCustomer().getId();
                DashboardSummaryDTO.TopCustomerDTO stats = customerStats.getOrDefault(customerId,
                        DashboardSummaryDTO.TopCustomerDTO.builder()
                                .id(customerId)
                                .name(order.getCustomer().getName())
                                .phone(order.getCustomer().getPhone())
                                .orderCount(0L)
                                .totalSpent(BigDecimal.ZERO)
                                .build());

                stats.setOrderCount(stats.getOrderCount() + 1);
                stats.setTotalSpent(stats.getTotalSpent().add(order.getTotalAmount()));
                customerStats.put(customerId, stats);
            }
        });

        List<DashboardSummaryDTO.TopCustomerDTO> topCustomers = customerStats.values().stream()
                .sorted((a, b) -> b.getTotalSpent().compareTo(a.getTotalSpent()))
                .limit(5)
                .collect(Collectors.toList());

        log.info("Top customers count: {}", topCustomers.size());

        return DashboardSummaryDTO.builder()
                .totalOrders(totalOrders)
                .completedOrders(completedOrdersCount)
                .pendingOrders(pendingOrders)
                .totalEmployees(totalEmployees)
                .activeEmployees(activeEmployees)
                .inactiveEmployees(inactiveEmployees)
                .totalCustomers(totalCustomers)
                .totalRevenue(totalRevenue)
                .monthlyRevenue(monthlyRevenue)
                .yearlyRevenue(yearlyRevenue)
                .recentOrders(recentOrders)
                .topEmployees(topEmployees)
                .topCustomers(topCustomers)
                .build();
    }
}

