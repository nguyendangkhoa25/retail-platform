package com.barbershop.model.enums;

import lombok.Getter;

/**
 * SubscriptionType - Enum for tenant subscription types
 */
@Getter
public enum SubscriptionType {
    TRIAL("Gói Dùng thử"),
    BASIC("Gói Cơ bản"),
    STANDARD("Gói Tiêu chuẩn"),
    PREMIUM("Gói Cao cấp"),
    ENTERPRISE("Gói Doanh nghiệp lớn"),
    LIFETIME("Gói Trọn đời");

    private final String description;

    SubscriptionType(String description) {
        this.description = description;
    }

    public String getTypeName() {
        return this.name();
    }
}

