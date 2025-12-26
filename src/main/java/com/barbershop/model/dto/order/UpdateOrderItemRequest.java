package com.barbershop.model.dto.order;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateOrderItemRequest {
    private Integer quantity;
    private BigDecimal unitPrice;
    private String status;
    private Long assignedEmployeeId;
}

