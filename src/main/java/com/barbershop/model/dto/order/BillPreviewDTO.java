package com.barbershop.model.dto.order;

import lombok.*;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BillPreviewDTO {
    private Long orderId;
    private String customerName;
    private String customerPhone;
    private List<BillItemDTO> items;
    private BigDecimal subtotal;
    private BigDecimal discountAmount;
    private BigDecimal taxPercentage;
    private BigDecimal taxAmount;
    private BigDecimal total;
    private String notes;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class BillItemDTO {
        private Long itemId;
        private String productName;
        private Integer quantity;
        private BigDecimal unitPrice;
        private BigDecimal totalPrice;
        private BigDecimal taxPercentage;
        private BigDecimal taxAmount;
    }
}

