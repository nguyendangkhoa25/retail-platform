package com.tappy.pos.controller.mobile;

import com.tappy.pos.config.JwtTokenProvider;
import com.tappy.pos.model.dto.ApiResponse;
import com.tappy.pos.model.dto.finance.ShopExpenseRequest;
import com.tappy.pos.model.dto.tenant.CreateTenantRequest;
import com.tappy.pos.model.entity.auth.User;
import com.tappy.pos.model.entity.tenant.Tenant;
import com.tappy.pos.model.enums.ExpenseCategory;
import com.tappy.pos.model.enums.ShopType;
import com.tappy.pos.multitenant.TenantContext;
import com.tappy.pos.repository.auth.RoleRepository;
import com.tappy.pos.repository.auth.UserRepository;
import com.tappy.pos.service.finance.ShopExpenseService;
import com.tappy.pos.service.tenant.TenantFeatureService;
import com.tappy.pos.service.tenant.TenantProvisioningService;
import com.tappy.pos.service.tenant.TenantSeedService;
import com.tappy.pos.service.tenant.TenantService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@RestController
@RequiredArgsConstructor
@Slf4j
public class OnboardingController {

    private final TenantService tenantService;
    private final TenantContext tenantContext;
    private final TenantProvisioningService tenantProvisioningService;
    private final TenantSeedService tenantSeedService;
    private final TenantFeatureService tenantFeatureService;
    private final ShopExpenseService shopExpenseService;
    private final JwtTokenProvider jwtTokenProvider;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final NamedParameterJdbcTemplate namedJdbc;

    private static final List<String> DEFAULT_TENANT_FEATURES = List.of(
            "POS", "ORDER", "ORDER_VIEW_ALL", "PRODUCT", "CUSTOMER", "INVENTORY",
            "EXPENSE", "DASHBOARD", "NOTIFICATION", "FEEDBACK", "SHOP_INFO",
            "PRINT_TEMPLATE", "BANK_ACCOUNT", "ACTIVITY_LOG", "REVENUE", "USER"
    );

    private static final Map<String, ShopType> SHOP_TYPE_MAP = Map.ofEntries(
            Map.entry("CONVENIENCE_STORE", ShopType.CONVENIENCE_STORE),
            Map.entry("FOOD_BEVERAGE", ShopType.FOOD_BEVERAGE),
            Map.entry("RESTAURANT", ShopType.RESTAURANT),
            Map.entry("FASHION", ShopType.FASHION),
            Map.entry("ELECTRONICS", ShopType.ELECTRONICS),
            Map.entry("BARBER_SHOP", ShopType.BARBER_SHOP),
            Map.entry("COFFEE_SHOP", ShopType.COFFEE_SHOP),
            Map.entry("PHARMACY", ShopType.PHARMACY),
            Map.entry("JEWELRY", ShopType.JEWELRY),
            Map.entry("PAWN_SHOP", ShopType.PAWN_SHOP),
            Map.entry("OTHER", ShopType.OTHER)
    );

    private static final Map<ShopType, String> PREFIX_MAP;
    static {
        Map<ShopType, String> m = new EnumMap<>(ShopType.class);
        m.put(ShopType.CONVENIENCE_STORE, "gen");
        m.put(ShopType.FOOD_BEVERAGE, "food");
        m.put(ShopType.RESTAURANT, "res");
        m.put(ShopType.FASHION, "fsh");
        m.put(ShopType.ELECTRONICS, "elec");
        m.put(ShopType.BARBER_SHOP, "bar");
        m.put(ShopType.COFFEE_SHOP, "cafe");
        m.put(ShopType.PHARMACY, "phar");
        m.put(ShopType.JEWELRY, "jwl");
        m.put(ShopType.PAWN_SHOP, "pawn");
        m.put(ShopType.OTHER, "shop");
        PREFIX_MAP = Collections.unmodifiableMap(m);
    }

    @GetMapping("/shop-types")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getShopTypes() {
        List<Map<String, Object>> types = Arrays.asList(
                shopEntry("CONVENIENCE_STORE", "Cửa hàng tổng hợp", "🏪"),
                shopEntry("FOOD_BEVERAGE", "Thực phẩm / Đồ uống", "🍱"),
                shopEntry("RESTAURANT", "Quán ăn / Nhà hàng", "🍜"),
                shopEntry("COFFEE_SHOP", "Quán cà phê", "☕"),
                shopEntry("FASHION", "Thời trang", "👗"),
                shopEntry("ELECTRONICS", "Điện tử / Điện máy", "📱"),
                shopEntry("BARBER_SHOP", "Salon / Cắt tóc", "✂️"),
                shopEntry("PHARMACY", "Nhà thuốc / Dược phẩm", "💊"),
                shopEntry("JEWELRY", "Trang sức / Vàng bạc", "💍"),
                shopEntry("PAWN_SHOP", "Tiệm cầm đồ", "🏦"),
                shopEntry("OTHER", "Khác", "🏢")
        );
        return ResponseEntity.ok(ApiResponse.success(types, "OK"));
    }

    private Map<String, Object> shopEntry(String code, String name, String emoji) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("code", code);
        m.put("name", name);
        m.put("emoji", emoji);
        return m;
    }

    @GetMapping("/product-templates")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getProductTemplates(
            @RequestParam(required = false, defaultValue = "OTHER") String shopTypeCode) {
        String sql = """
                SELECT id, name, emoji, default_price, unit, dynamic_price
                FROM product_suggestions
                WHERE :shopType = ANY(shop_types)
                ORDER BY display_order, name
                LIMIT 25
                """;
        List<Map<String, Object>> rows = namedJdbc.queryForList(sql, Map.of("shopType", shopTypeCode));
        List<Map<String, Object>> result = rows.stream().map(row -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", row.get("id").toString());
            m.put("name", row.get("name"));
            m.put("emoji", row.getOrDefault("emoji", "📦"));
            m.put("price", row.get("default_price"));
            m.put("unit", row.get("unit"));
            m.put("dynamicPrice", Boolean.TRUE.equals(row.get("dynamic_price")));
            return m;
        }).toList();
        return ResponseEntity.ok(ApiResponse.success(result, "OK"));
    }

    @GetMapping("/expense-suggestions")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getExpenseSuggestions(
            @RequestParam(required = false, defaultValue = "OTHER") String shopTypeCode) {
        String sql = """
                SELECT name, emoji, category_code
                FROM expense_suggestions
                WHERE 'ALL' = ANY(shop_types) OR :shopType = ANY(shop_types)
                ORDER BY
                    CASE WHEN 'ALL' = ANY(shop_types) THEN 1 ELSE 0 END,
                    display_order, name
                LIMIT 40
                """;
        List<Map<String, Object>> rows = namedJdbc.queryForList(sql, Map.of("shopType", shopTypeCode));
        List<Map<String, Object>> result = rows.stream().map(row -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("name", row.get("name"));
            m.put("emoji", row.getOrDefault("emoji", "💰"));
            m.put("category", row.getOrDefault("category_code", "OTHER"));
            return m;
        }).toList();
        return ResponseEntity.ok(ApiResponse.success(result, "OK"));
    }

    @PostMapping("/tenants/self-provision")
    public ResponseEntity<ApiResponse<Map<String, Object>>> selfProvision(
            @RequestBody Map<String, Object> body) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth instanceof AnonymousAuthenticationToken || !auth.isAuthenticated()) {
            return ResponseEntity.status(401)
                    .body(ApiResponse.<Map<String, Object>>error("UNAUTHORIZED", "Yêu cầu xác thực"));
        }
        String username = auth.getName();

        String shopTypeCode = (String) body.getOrDefault("shopTypeCode", "OTHER");
        String shopName = (String) body.getOrDefault("shopName", "Cửa hàng của tôi");
        String address = (String) body.getOrDefault("address", "");
        String fullName = (String) body.getOrDefault("fullName", "");
        String nickname = (String) body.getOrDefault("nickname", "");

        ShopType shopType = SHOP_TYPE_MAP.getOrDefault(shopTypeCode, ShopType.OTHER);
        String prefix = PREFIX_MAP.getOrDefault(shopType, "shop");

        // Look up the registration user's password hash before setting tenant context.
        // Without tenant context, RLS is scoped to tenant_id IS NULL — finds the
        // master-scope user created during /auth/register.
        String encodedPassword = userRepository.findByUsernameActive(username)
                .map(User::getPassword)
                .orElseThrow(() -> new RuntimeException("User not found: " + username));

        String tenantId = generateUniqueTenantId(prefix);
        String contactName = !fullName.isBlank() ? fullName : (!nickname.isBlank() ? nickname : username);

        CreateTenantRequest createReq = CreateTenantRequest.builder()
                .tenantId(tenantId)
                .name(shopName)
                .dbName(tenantId)
                .shopType(shopType)
                .shopAddress(address.isBlank() ? null : address)
                .contactPersonName(contactName)
                .contactPersonPhone(username)
                .features(DEFAULT_TENANT_FEATURES)
                .adminUsername(username)
                .adminPassword("placeholder")
                .build();

        tenantService.createTenant(createReq);
        log.info("Created self-provisioned tenant: {} for user: {}", tenantId, username);

        Tenant tenantEntity = tenantService.getTenantEntity(tenantId);
        tenantContext.setCurrentTenant(tenantEntity);
        try {
            tenantProvisioningService.provisionWithEncodedPassword(
                    tenantEntity, username, encodedPassword, address);
            try {
                tenantSeedService.seed(shopType);
            } catch (Exception e) {
                log.warn("DML seed non-fatal failure for {}: {}", tenantId, e.getMessage());
            }

            seedOnboardingProducts(body, tenantId);
            seedOnboardingExpenses(body);

            List<String> roleNames = roleRepository.findByNameAndTenantId("SHOP_OWNER", tenantId)
                    .map(r -> List.of(r.getName()))
                    .orElse(List.of("SHOP_OWNER"));
            List<String> featureNames = tenantFeatureService.getAccessibleFeaturesByRoleAndTenant(roleNames);

            String accessToken = jwtTokenProvider.generateTokenWithRolesAndFeatures(
                    username, roleNames, featureNames, false, shopType.name(), tenantId);

            log.info("Self-provisioned tenant {} for user {} with {} features",
                    tenantId, username, featureNames.size());

            Map<String, Object> result = new LinkedHashMap<>();
            result.put("accessToken", accessToken);
            result.put("tenantId", tenantId);
            result.put("setupComplete", true);
            return ResponseEntity.ok(ApiResponse.success(result, "Cửa hàng đã được tạo thành công"));

        } catch (Exception e) {
            log.error("Self-provision failed for user {}: {}", username, e.getMessage(), e);
            throw new RuntimeException("Không thể tạo cửa hàng: " + e.getMessage(), e);
        } finally {
            tenantContext.clear();
        }
    }

    private void seedOnboardingProducts(Map<String, Object> body, String tenantId) {
        Object raw = body.get("products");
        if (!(raw instanceof List<?> list) || list.isEmpty()) return;

        // Insert each selected product into the tenant's product table.
        // Looks up the product_type by the suggestion's templateId to get the correct
        // product_type_id. Falls back to the first available type if not found.
        String sql = """
                INSERT INTO product (tenant_id, product_type_id, sku, name, price, unit, status)
                SELECT
                    :tenantId,
                    COALESCE(
                        (SELECT pt.id FROM product_type pt
                         JOIN product_suggestions ps ON ps.product_type_code = pt.code
                         WHERE pt.tenant_id = :tenantId AND ps.id = :templateId
                         LIMIT 1),
                        (SELECT pt.id FROM product_type pt
                         WHERE pt.tenant_id = :tenantId
                         ORDER BY pt.id LIMIT 1)
                    ),
                    :sku,
                    :name,
                    :price,
                    :unit,
                    'ACTIVE'
                WHERE NOT EXISTS (
                    SELECT 1 FROM product p
                    WHERE p.tenant_id = :tenantId AND p.name = :name AND p.deleted = FALSE
                )
                """;

        for (Object item : list) {
            if (!(item instanceof Map)) continue;
            @SuppressWarnings("unchecked")
            Map<String, Object> map = (Map<String, Object>) item;
            try {
                String name = (String) map.get("name");
                if (name == null || name.isBlank()) continue;

                Number priceNum = (Number) map.getOrDefault("price", 0);
                Number templateIdNum = null;
                Object tid = map.get("templateId");
                if (tid instanceof Number n) templateIdNum = n;
                else if (tid instanceof String s && !s.isBlank()) {
                    try { templateIdNum = Long.parseLong(s); } catch (NumberFormatException ignored) {}
                }

                String unit = (String) map.getOrDefault("unit", "Cái");
                int suffix = ThreadLocalRandom.current().nextInt(10000, 99999);
                String sku = "SUG-" + suffix;

                Map<String, Object> params = new HashMap<>();
                params.put("tenantId", tenantId);
                params.put("templateId", templateIdNum != null ? templateIdNum.longValue() : -1L);
                params.put("sku", sku);
                params.put("name", name);
                params.put("price", BigDecimal.valueOf(priceNum.longValue()));
                params.put("unit", unit);

                namedJdbc.update(sql, params);
            } catch (Exception ex) {
                log.warn("Skipped onboarding product '{}': {}", map.get("name"), ex.getMessage());
            }
        }
    }

    private void seedOnboardingExpenses(Map<String, Object> body) {
        Object raw = body.get("expenses");
        if (!(raw instanceof List<?> list) || list.isEmpty()) return;

        LocalDate today = LocalDate.now();
        for (Object item : list) {
            if (!(item instanceof Map)) continue;
            @SuppressWarnings("unchecked")
            Map<String, Object> map = (Map<String, Object>) item;
            try {
                Number amount = (Number) map.get("monthlyAmount");
                if (amount == null || amount.longValue() <= 0) continue;

                String categoryCode = (String) map.getOrDefault("category", "OTHER");
                ExpenseCategory category;
                try {
                    category = ExpenseCategory.valueOf(categoryCode);
                } catch (IllegalArgumentException ex) {
                    category = ExpenseCategory.OTHER;
                }

                Number paymentDay = (Number) map.get("paymentDate");
                LocalDate expenseDate = today;
                if (paymentDay != null) {
                    int day = paymentDay.intValue();
                    int maxDay = today.lengthOfMonth();
                    expenseDate = today.withDayOfMonth(Math.min(day, maxDay));
                }

                String note = (String) map.getOrDefault("note", "");

                ShopExpenseRequest req = new ShopExpenseRequest();
                req.setAmount(BigDecimal.valueOf(amount.longValue()));
                req.setCategory(category);
                req.setDescription(note.isBlank() ? null : note);
                req.setExpenseDate(expenseDate);

                shopExpenseService.create(req);
            } catch (Exception ex) {
                log.warn("Skipped onboarding expense due to error: {}", ex.getMessage());
            }
        }
    }

    private String generateUniqueTenantId(String prefix) {
        for (int i = 0; i < 10; i++) {
            int suffix = ThreadLocalRandom.current().nextInt(10000, 99999);
            String candidate = prefix + suffix;
            try {
                tenantService.getTenantEntity(candidate);
            } catch (Exception ignored) {
                return candidate;
            }
        }
        return prefix + UUID.randomUUID().toString().replace("-", "").substring(0, 8);
    }
}
