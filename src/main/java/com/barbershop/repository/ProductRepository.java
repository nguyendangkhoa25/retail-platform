package com.barbershop.repository;

import com.barbershop.model.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {

    List<Product> findByActiveTrue();

    List<Product> findAll();

    /**
     * Find all products with pagination and filtering
     */
    Page<Product> findAll(Pageable pageable);

    /**
     * Find products by active status with pagination
     */
    Page<Product> findByActive(Boolean active, Pageable pageable);

    /**
     * Search products by name or description with pagination
     */
    @Query("SELECT p FROM Product p WHERE " +
            "(LOWER(p.name) LIKE LOWER(CONCAT('%', :searchTerm, '%')) OR " +
            "LOWER(p.description) LIKE LOWER(CONCAT('%', :searchTerm, '%'))) " +
            "AND (:active IS NULL OR p.active = :active)")
    Page<Product> searchProducts(@Param("searchTerm") String searchTerm,
                                 @Param("active") Boolean active,
                                 Pageable pageable);

    /**
     * Find products by active status only, with pagination
     */
    @Query("SELECT p FROM Product p WHERE p.active = :active")
    Page<Product> findAllByStatus(@Param("active") Boolean active, Pageable pageable);
}
