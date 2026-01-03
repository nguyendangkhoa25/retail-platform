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
public class CreatePromotionRequest {
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
    private List<PromotionProductRequest> products;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class PromotionProductRequest {
        private Long productId;
        private Integer quantity;
    }
}

