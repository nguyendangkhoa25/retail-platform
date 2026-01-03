package com.barbershop.repository;

import com.barbershop.model.entity.Promotion;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Long> {

    @Query("SELECT p FROM Promotion p WHERE p.deletedAt IS NULL")
    Page<Promotion> findAllActive(Pageable pageable);

    @Query("SELECT p FROM Promotion p WHERE p.id = :id AND p.deletedAt IS NULL")
    Optional<Promotion> findByIdActive(@Param("id") Long id);

    @Query("SELECT p FROM Promotion p WHERE p.deletedAt IS NULL AND p.isActive = true AND p.promotionType = :type")
    List<Promotion> findActiveByType(@Param("type") Promotion.PromotionType type);

    @Query("SELECT p FROM Promotion p WHERE p.deletedAt IS NULL AND p.isActive = true " +
            "AND p.promotionType = 'TIME_BASED' " +
            "AND (p.startDate IS NULL OR p.startDate <= :now) " +
            "AND (p.endDate IS NULL OR p.endDate >= :now)")
    List<Promotion> findActiveTimeBasedPromotions(@Param("now") LocalDateTime now);

    @Query("SELECT p FROM Promotion p WHERE p.deletedAt IS NULL AND p.isActive = true AND p.promotionType = 'COMBO_PACKAGE'")
    List<Promotion> findActiveComboPromotions();
}

