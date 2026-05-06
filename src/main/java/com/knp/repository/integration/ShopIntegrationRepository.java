package com.knp.repository.integration;

import com.knp.model.entity.integration.ShopIntegration;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ShopIntegrationRepository extends JpaRepository<ShopIntegration, Long> {

    Optional<ShopIntegration> findByTenantIdAndIntegrationTypeAndDeletedFalse(
            String tenantId, String integrationType);
}
