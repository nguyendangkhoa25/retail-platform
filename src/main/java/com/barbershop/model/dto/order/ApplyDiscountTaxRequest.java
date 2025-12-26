package com.barbershop.model.dto.order;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApplyDiscountTaxRequest {
    private BigDecimal discountAmount;
    private BigDecimal taxPercentage;
}

