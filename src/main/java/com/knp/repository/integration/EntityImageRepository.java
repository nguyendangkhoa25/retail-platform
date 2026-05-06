package com.knp.repository.integration;

import com.knp.model.entity.integration.EntityImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface EntityImageRepository extends JpaRepository<EntityImage, Long> {

    List<EntityImage> findByEntityTypeAndEntityIdAndDeletedFalseOrderByUploadedAtAsc(
            String entityType, Long entityId);

    Optional<EntityImage> findByIdAndDeletedFalse(Long id);
}
