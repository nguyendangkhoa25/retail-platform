package com.barbershop.model.dto.order;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssignOrderItemRequest {
    private Long itemId;
    private Long employeeId;
}

