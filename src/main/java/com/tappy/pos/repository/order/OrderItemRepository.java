package com.tappy.pos.repository.order;

import com.tappy.pos.model.entity.order.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {

    @Query("SELECT COALESCE(SUM(oi.costAmount), 0) FROM OrderItem oi JOIN oi.order o WHERE o.deleted = false AND o.status = 'COMPLETED'")
    BigDecimal sumTotalCost();

    @Query(value = "SELECT COALESCE(SUM(oi.cost_amount), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND EXTRACT(YEAR FROM o.completed_at) = :year AND EXTRACT(MONTH FROM o.completed_at) = :month",
           nativeQuery = true)
    BigDecimal sumCostByMonth(@Param("year") int year, @Param("month") int month);

    @Query(value = "SELECT COALESCE(SUM(oi.cost_amount), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND EXTRACT(YEAR FROM o.completed_at) = :year",
           nativeQuery = true)
    BigDecimal sumCostByYear(@Param("year") int year);

    // Monthly cost breakdown: [month, cost]
    @Query(value = "SELECT EXTRACT(MONTH FROM o.completed_at), COALESCE(SUM(oi.cost_amount), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND EXTRACT(YEAR FROM o.completed_at) = :year GROUP BY EXTRACT(MONTH FROM o.completed_at) ORDER BY EXTRACT(MONTH FROM o.completed_at)",
           nativeQuery = true)
    List<Object[]> sumCostGroupedByMonth(@Param("year") int year);

    // Daily cost breakdown: [day, cost]
    @Query(value = "SELECT EXTRACT(DAY FROM o.completed_at), COALESCE(SUM(oi.cost_amount), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND EXTRACT(YEAR FROM o.completed_at) = :year AND EXTRACT(MONTH FROM o.completed_at) = :month GROUP BY EXTRACT(DAY FROM o.completed_at) ORDER BY EXTRACT(DAY FROM o.completed_at)",
           nativeQuery = true)
    List<Object[]> sumCostGroupedByDay(@Param("year") int year, @Param("month") int month);

    // ── Salary / Commission queries ───────────────────────────────────────────

    @Query(value = """
            SELECT COALESCE(SUM(oi.commission_amount), 0)
            FROM order_items oi
            JOIN orders o ON o.id = oi.order_id
            WHERE oi.assigned_employee_id = :employeeId
              AND oi.is_salary_calculated = false
              AND oi.included_in_salary_id IS NULL
              AND o.deleted = false
              AND o.status = 'COMPLETED'
              AND EXTRACT(YEAR  FROM o.completed_at) = :year
              AND EXTRACT(MONTH FROM o.completed_at) = :month
            """, nativeQuery = true)
    BigDecimal sumPendingCommissionByEmployeeAndMonth(
            @Param("employeeId") Long employeeId,
            @Param("month") int month,
            @Param("year") int year);

    @Modifying
    @Query(value = """
            UPDATE order_items oi
            SET included_in_salary_id = :salaryId
            FROM orders o
            WHERE oi.order_id = o.id
              AND oi.assigned_employee_id = :employeeId
              AND oi.is_salary_calculated = false
              AND oi.included_in_salary_id IS NULL
              AND o.deleted = false
              AND o.status = 'COMPLETED'
              AND EXTRACT(YEAR  FROM o.completed_at) = :year
              AND EXTRACT(MONTH FROM o.completed_at) = :month
            """, nativeQuery = true)
    int linkItemsToSalary(
            @Param("salaryId") Long salaryId,
            @Param("employeeId") Long employeeId,
            @Param("month") int month,
            @Param("year") int year);

    @Modifying
    @Query(value = "UPDATE order_items SET is_salary_calculated = true WHERE included_in_salary_id = :salaryId",
           nativeQuery = true)
    int markSalaryCalculated(@Param("salaryId") Long salaryId);

    @Modifying
    @Query(value = "UPDATE order_items SET included_in_salary_id = NULL WHERE included_in_salary_id = :salaryId",
           nativeQuery = true)
    int unlinkFromSalary(@Param("salaryId") Long salaryId);

    @Query(value = """
            SELECT oi.id, o.order_number, oi.product_name, oi.quantity,
                   oi.amount, oi.commission_rate, oi.commission_amount, o.completed_at
            FROM order_items oi
            JOIN orders o ON o.id = oi.order_id
            WHERE oi.included_in_salary_id = :salaryId
            ORDER BY o.completed_at
            """, nativeQuery = true)
    List<Object[]> findCommissionItemsBySalaryId(@Param("salaryId") Long salaryId);

    @Query("SELECT COALESCE(SUM(oi.quantity), 0) FROM OrderItem oi JOIN oi.order o WHERE o.deleted = false AND o.status = 'COMPLETED'")
    Long sumTotalItemsSold();

    @Query(value = "SELECT COALESCE(SUM(oi.quantity), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND EXTRACT(YEAR FROM o.completed_at) = :year AND EXTRACT(MONTH FROM o.completed_at) = :month",
           nativeQuery = true)
    Long sumItemsSoldByMonth(@Param("year") int year, @Param("month") int month);

    @Query(value = "SELECT COALESCE(SUM(oi.quantity), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND EXTRACT(YEAR FROM o.completed_at) = :year",
           nativeQuery = true)
    Long sumItemsSoldByYear(@Param("year") int year);

    @Query("SELECT COALESCE(SUM(oi.quantity), 0) FROM OrderItem oi JOIN oi.order o WHERE o.deleted = false AND o.status = 'COMPLETED' AND o.completedAt >= :from AND o.completedAt <= :to")
    Long sumItemsSoldByDateRange(@Param("from") java.time.LocalDateTime from, @Param("to") java.time.LocalDateTime to);

    // Top products: [productId, productName, quantity, revenue, cost]
    @Query(value = "SELECT oi.product_id, oi.product_name, SUM(oi.quantity), COALESCE(SUM(oi.amount), 0), COALESCE(SUM(oi.cost_amount), 0) FROM order_items oi JOIN orders o ON o.id = oi.order_id WHERE o.deleted = false AND o.status = 'COMPLETED' AND (CAST(:year AS integer) IS NULL OR EXTRACT(YEAR FROM o.completed_at) = CAST(:year AS integer)) AND (CAST(:month AS integer) IS NULL OR EXTRACT(MONTH FROM o.completed_at) = CAST(:month AS integer)) GROUP BY oi.product_id, oi.product_name ORDER BY SUM(oi.amount) DESC",
           nativeQuery = true)
    List<Object[]> findTopProducts(@Param("year") Integer year, @Param("month") Integer month);
}
