package com.barbershop.service;

import com.barbershop.exception.BadRequestException;
import com.barbershop.exception.ResourceNotFoundException;
import com.barbershop.model.dto.promotion.CreatePromotionRequest;
import com.barbershop.model.dto.promotion.PromotionDTO;
import com.barbershop.model.entity.Product;
import com.barbershop.model.entity.Promotion;
import com.barbershop.model.entity.PromotionProduct;
import com.barbershop.repository.ProductRepository;
import com.barbershop.repository.PromotionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class PromotionService {

    private final PromotionRepository promotionRepository;
    private final ProductRepository productRepository;
    private final MessageService messageService;

    // ...existing code...

    @Transactional(readOnly = true)
    public Page<PromotionDTO> getAllPromotions(Pageable pageable) {
        Page<Promotion> promotions = promotionRepository.findAllActive(pageable);
        return promotions.map(this::mapToDTO);
    }

    @Transactional(readOnly = true)
    public PromotionDTO getPromotionById(Long id) {
        Promotion promotion = promotionRepository.findByIdActive(id)
                .orElseThrow(() -> new ResourceNotFoundException("Promotion not found with id: " + id));
        return mapToDTO(promotion);
    }

    @Transactional(readOnly = true)
    public List<PromotionDTO> getActiveComboPromotions() {
        List<Promotion> promotions = promotionRepository.findActiveComboPromotions();
        return promotions.stream()
                .filter(Promotion::isValidNow)
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PromotionDTO> getActiveTimeBasedPromotions() {
        List<Promotion> promotions = promotionRepository.findActiveTimeBasedPromotions(LocalDateTime.now());
        return promotions.stream()
                .map(this::mapToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public PromotionDTO createPromotion(CreatePromotionRequest request) {
        log.info("Creating promotion: {}", request.getName());

        Promotion promotion = Promotion.builder()
                .name(request.getName())
                .description(request.getDescription())
                .promotionType(Promotion.PromotionType.valueOf(request.getPromotionType()))
                .discountType(Promotion.DiscountType.valueOf(request.getDiscountType()))
                .discountValue(request.getDiscountValue())
                .discountPercentage(request.getDiscountPercentage())
                .startDate(request.getStartDate())
                .endDate(request.getEndDate())
                .isActive(request.getIsActive() != null ? request.getIsActive() : true)
                .minPurchaseAmount(request.getMinPurchaseAmount())
                .maxDiscountAmount(request.getMaxDiscountAmount())
                .promotionProducts(new ArrayList<>()) // Initialize the list
                .build();

        // Add products for combo promotions
        if (request.getProducts() != null && !request.getProducts().isEmpty()) {
            for (CreatePromotionRequest.PromotionProductRequest productRequest : request.getProducts()) {
                Product product = productRepository.findById(productRequest.getProductId())
                        .orElseThrow(() -> {
                            String errorMessage = messageService.getMessage("error.product.not.found", productRequest.getProductId());
                            return new ResourceNotFoundException(errorMessage);
                        });

                if (!product.getActive()) {
                    String errorMessage = messageService.getMessage("error.product.inactive", productRequest.getProductId());
                    throw new BadRequestException(errorMessage);
                }

                PromotionProduct promotionProduct = PromotionProduct.builder()
                        .promotion(promotion)
                        .product(product)
                        .quantity(productRequest.getQuantity())
                        .build();

                promotion.getPromotionProducts().add(promotionProduct);
            }
        }

        Promotion saved = promotionRepository.save(promotion);
        log.info("Promotion created with id: {}", saved.getId());
        return mapToDTO(saved);
    }

    @Transactional
    public PromotionDTO updatePromotion(Long id, CreatePromotionRequest request) {
        log.info("Updating promotion: {}", id);

        Promotion promotion = promotionRepository.findByIdActive(id)
                .orElseThrow(() -> {
                    String errorMessage = messageService.getMessage("error.promotion.not.found", id);
                    return new ResourceNotFoundException(errorMessage);
                });

        promotion.setName(request.getName());
        promotion.setDescription(request.getDescription());
        promotion.setPromotionType(Promotion.PromotionType.valueOf(request.getPromotionType()));
        promotion.setDiscountType(Promotion.DiscountType.valueOf(request.getDiscountType()));
        promotion.setDiscountValue(request.getDiscountValue());
        promotion.setDiscountPercentage(request.getDiscountPercentage());
        promotion.setStartDate(request.getStartDate());
        promotion.setEndDate(request.getEndDate());
        promotion.setIsActive(request.getIsActive());
        promotion.setMinPurchaseAmount(request.getMinPurchaseAmount());
        promotion.setMaxDiscountAmount(request.getMaxDiscountAmount());

        // Update products
        promotion.getPromotionProducts().clear();
        if (request.getProducts() != null && !request.getProducts().isEmpty()) {
            for (CreatePromotionRequest.PromotionProductRequest productRequest : request.getProducts()) {
                Product product = productRepository.findById(productRequest.getProductId())
                        .orElseThrow(() -> {
                            String errorMessage = messageService.getMessage("error.product.not.found", productRequest.getProductId());
                            return new ResourceNotFoundException(errorMessage);
                        });

                if (!product.getActive()) {
                    String errorMessage = messageService.getMessage("error.product.inactive", productRequest.getProductId());
                    throw new BadRequestException(errorMessage);
                }

                PromotionProduct promotionProduct = PromotionProduct.builder()
                        .promotion(promotion)
                        .product(product)
                        .quantity(productRequest.getQuantity())
                        .build();

                promotion.getPromotionProducts().add(promotionProduct);
            }
        }

        Promotion updated = promotionRepository.save(promotion);
        log.info("Promotion updated: {}", id);
        return mapToDTO(updated);
    }

    @Transactional
    public void deletePromotion(Long id) {
        log.info("Deleting promotion: {}", id);
        Promotion promotion = promotionRepository.findByIdActive(id)
                .orElseThrow(() -> new ResourceNotFoundException("Promotion not found with id: " + id));

        promotion.setDeletedAt(LocalDateTime.now());
        promotionRepository.save(promotion);
        log.info("Promotion deleted: {}", id);
    }

    public BigDecimal calculateDiscount(Promotion promotion, BigDecimal totalAmount) {
        BigDecimal discount = BigDecimal.ZERO;

        if (promotion.getDiscountType() == Promotion.DiscountType.PERCENTAGE) {
            discount = totalAmount.multiply(promotion.getDiscountPercentage())
                    .divide(new BigDecimal(100), 2, RoundingMode.HALF_UP);
        } else if (promotion.getDiscountType() == Promotion.DiscountType.FIXED_AMOUNT) {
            discount = promotion.getDiscountValue();
        }

        // Apply max discount limit
        if (promotion.getMaxDiscountAmount() != null && discount.compareTo(promotion.getMaxDiscountAmount()) > 0) {
            discount = promotion.getMaxDiscountAmount();
        }

        return discount;
    }

    private PromotionDTO mapToDTO(Promotion promotion) {
        List<PromotionDTO.PromotionProductDTO> productDTOs = null;
        if (promotion.getPromotionProducts() != null) {
            productDTOs = promotion.getPromotionProducts().stream()
                    .map(pp -> PromotionDTO.PromotionProductDTO.builder()
                            .id(pp.getId())
                            .productId(pp.getProduct().getId())
                            .productName(pp.getProduct().getName())
                            .productPrice(pp.getProduct().getPrice())
                            .quantity(pp.getQuantity())
                            .build())
                    .collect(Collectors.toList());
        }

        return PromotionDTO.builder()
                .id(promotion.getId())
                .name(promotion.getName())
                .description(promotion.getDescription())
                .promotionType(promotion.getPromotionType().name())
                .discountType(promotion.getDiscountType().name())
                .discountValue(promotion.getDiscountValue())
                .discountPercentage(promotion.getDiscountPercentage())
                .startDate(promotion.getStartDate())
                .endDate(promotion.getEndDate())
                .isActive(promotion.getIsActive())
                .minPurchaseAmount(promotion.getMinPurchaseAmount())
                .maxDiscountAmount(promotion.getMaxDiscountAmount())
                .products(productDTOs)
                .createdAt(promotion.getCreatedAt())
                .updatedAt(promotion.getUpdatedAt())
                .isValidNow(promotion.isValidNow())
                .build();
    }
}

