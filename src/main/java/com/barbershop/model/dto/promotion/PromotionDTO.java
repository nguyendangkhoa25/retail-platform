package com.barbershop.model.dto.promotion;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PromotionDTO {
    private Long id;
    private String name;
    private String description;
    private String promotionType;
    private String discountType;
    private BigDecimal discountValue;
    private BigDecimal discountPercentage;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private Boolean isActive;
    private BigDecimal minPurchaseAmount;
    private BigDecimal maxDiscountAmount;
    private List<PromotionProductDTO> products;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Boolean isValidNow;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class PromotionProductDTO {
        private Long id;
        private Long productId;
        private String productName;
        private BigDecimal productPrice;
        private Integer quantity;
    }
}

