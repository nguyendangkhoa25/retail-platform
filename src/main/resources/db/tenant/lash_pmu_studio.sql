-- ============================================================
-- TENANT SEED — DEFAULT DATA: TIỆM MI / XĂM THẨM MỸ (LASH & PMU STUDIO)
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',     'Dịch vụ',                    'Dịch vụ nối mi / xăm thẩm mỹ'),
    (current_setting('app.current_tenant', true), 'BEAUTY',      'Làm đẹp / Chăm sóc cá nhân','Sản phẩm làm đẹp và vệ sinh cá nhân'),
    (current_setting('app.current_tenant', true), 'CONVENIENCE', 'Hàng tiêu dùng',             'Hàng tiêu dùng thiết yếu'),
    (current_setting('app.current_tenant', true), 'FOOD',        'Thực phẩm',                  'Thực phẩm và đồ ăn'),
    (current_setting('app.current_tenant', true), 'BEVERAGE',    'Đồ uống',                    'Nước giải khát, bia, nước suối'),
    (current_setting('app.current_tenant', true), 'DRUG',        'Dược phẩm',                  'Thuốc và sản phẩm dược'),
    (current_setting('app.current_tenant', true), 'CLOTHING',    'Quần áo / May mặc',          'Quần áo và phụ kiện'),
    (current_setting('app.current_tenant', true), 'ELECTRONICS', 'Điện tử',                    'Thiết bị điện tử'),
    (current_setting('app.current_tenant', true), 'FURNITURE',   'Đồ nội thất',                'Nội thất gia đình'),
    (current_setting('app.current_tenant', true), 'TOYS',        'Đồ chơi / Trò chơi',        'Đồ chơi và trò chơi'),
    (current_setting('app.current_tenant', true), 'BOOKS',       'Sách / Văn phòng phẩm',     'Sách và văn phòng phẩm'),
    (current_setting('app.current_tenant', true), 'SPORTS',      'Thể thao / Ngoài trời',     'Thiết bị thể thao'),
    (current_setting('app.current_tenant', true), 'AUTO_PARTS',  'Phụ tùng ô tô',             'Phụ tùng và phụ kiện ô tô'),
    (current_setting('app.current_tenant', true), 'APPLIANCES',  'Đồ gia dụng',                'Thiết bị gia dụng'),
    (current_setting('app.current_tenant', true), 'OFFICE',      'Văn phòng phẩm',             'Đồ dùng văn phòng'),
    (current_setting('app.current_tenant', true), 'PET',         'Thú cưng',                  'Thức ăn và phụ kiện thú cưng'),
    (current_setting('app.current_tenant', true), 'HEALTH',      'Sức khỏe / Dinh dưỡng',     'Sản phẩm sức khỏe và dinh dưỡng'),
    (current_setting('app.current_tenant', true), 'BIKE',        'Xe đạp / Xe máy',            'Xe đạp và phụ tùng xe máy'),
    (current_setting('app.current_tenant', true), 'HARDWARE',    'Đồ sắt / Dụng cụ',          'Đồ sắt và dụng cụ')
ON CONFLICT (code, tenant_id) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;

-- ── 2. Service categories ─────────────────────────────────────
INSERT INTO category (tenant_id, name, parent_id) VALUES
    (current_setting('app.current_tenant', true), 'Nối mi',              NULL),
    (current_setting('app.current_tenant', true), 'Xăm mày',            NULL),
    (current_setting('app.current_tenant', true), 'Xăm môi',            NULL),
    (current_setting('app.current_tenant', true), 'Xăm mí mắt',        NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc & Tháo',   NULL),
    (current_setting('app.current_tenant', true), 'Combo',              NULL);

-- ── 3. Services ───────────────────────────────────────────────
INSERT INTO product (tenant_id, product_type_id, sku, name, description, price, cost_price, unit, status, duration_minutes)
SELECT
    current_setting('app.current_tenant', true),
    pt.id,
    p.sku, p.name, p.description,
    p.price::NUMERIC, 0::NUMERIC,
    'lần', 'ACTIVE',
    p.dur::INT
FROM (VALUES
    -- Nối mi
    ('LP-001', 'Nối mi đơn Classic',           'Nối mi đơn tự nhiên, phù hợp mắt nhỏ',          350000, 90),
    ('LP-002', 'Nối mi thể tích Volume',        'Nối mi thể tích 2D-5D bồng bềnh',               500000, 120),
    ('LP-003', 'Nối mi Mega Volume',            'Nối mi siêu dày 6D-16D chuyên nghiệp',          700000, 150),
    ('LP-004', 'Nối mi Hybrid',                 'Kết hợp Classic + Volume tự nhiên sang trọng',  600000, 120),
    ('LP-005', 'Nối mi điêu luyện Wispy',       'Kiểu mi Wispy hiệu ứng phân tầng',              650000, 130),
    ('LP-006', 'Nối mi đuôi cá / Cat-eye',     'Kiểu mi kéo dài đuôi mắt như mèo',             550000, 110),
    -- Xăm mày
    ('LP-007', 'Xăm mày ngang cơ bản',         'Xăm mày ngang chân mày tự nhiên',               800000, 90),
    ('LP-008', 'Xăm mày giả lông Ombre',       'Xăm bột ombre mờ dần tự nhiên',               1200000, 120),
    ('LP-009', 'Xăm mày tán bột Powder Brows', 'Hiệu ứng tán bột đều màu sang trọng',         1500000, 120),
    ('LP-010', 'Xăm mày lông tơ Nano',         'Xăm lông tơ siêu mảnh tự nhiên',              2000000, 150),
    ('LP-011', 'Điều chỉnh / Sửa màu mày',    'Sửa màu hoặc điều chỉnh dáng mày cũ',          600000, 60),
    -- Xăm môi
    ('LP-012', 'Xăm môi căng bóng',            'Xăm căng bóng tạo môi đầy đặn',               1500000, 120),
    ('LP-013', 'Xăm môi ombre',                'Xăm ombre đậm nhạt tự nhiên',                 1800000, 150),
    ('LP-014', 'Xăm môi tán viền',             'Tán viền môi không rõ đường viền',             1300000, 120),
    ('LP-015', 'Điều chỉnh / Sửa màu môi',    'Sửa màu cũ hoặc thêm độ bão hòa',              800000, 60),
    -- Xăm mí mắt
    ('LP-016', 'Xăm mí trên (liner mảnh)',     'Xăm mí nước mảnh tự nhiên trên mắt',           800000, 60),
    ('LP-017', 'Xăm mí trên (liner đậm)',      'Xăm mí đậm đen sắc nét',                      1000000, 75),
    -- Chăm sóc & Tháo
    ('LP-018', 'Tháo mi nối',                  'Tháo mi nối an toàn không ảnh hưởng mi thật',   100000, 30),
    ('LP-019', 'Điền mi (fill-in)',             'Nối bù mi rụng sau 2-3 tuần',                   250000, 60),
    -- Combo
    ('LP-020', 'Combo Nối mi + Xăm mày',      'Nối mi Classic + xăm mày ombre cơ bản',        1400000, 180),
    ('LP-021', 'Combo Xăm mày + Xăm môi',     'Xăm mày powder + xăm môi ombre',              3000000, 240)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('LP-001', 'Nối mi'),
    ('LP-002', 'Nối mi'),
    ('LP-003', 'Nối mi'),
    ('LP-004', 'Nối mi'),
    ('LP-005', 'Nối mi'),
    ('LP-006', 'Nối mi'),
    ('LP-007', 'Xăm mày'),
    ('LP-008', 'Xăm mày'),
    ('LP-009', 'Xăm mày'),
    ('LP-010', 'Xăm mày'),
    ('LP-011', 'Xăm mày'),
    ('LP-012', 'Xăm môi'),
    ('LP-013', 'Xăm môi'),
    ('LP-014', 'Xăm môi'),
    ('LP-015', 'Xăm môi'),
    ('LP-016', 'Xăm mí mắt'),
    ('LP-017', 'Xăm mí mắt'),
    ('LP-018', 'Chăm sóc & Tháo'),
    ('LP-019', 'Chăm sóc & Tháo'),
    ('LP-020', 'Combo'),
    ('LP-021', 'Combo')
) AS pc(sku, cat_name)
JOIN product p ON p.sku = pc.sku AND p.tenant_id = current_setting('app.current_tenant', true)
JOIN category c ON c.name = pc.cat_name AND c.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT DO NOTHING;

-- ── 5. Inventory ─────────────────────────────────────────────
INSERT INTO inventory
    (tenant_id, product_id, quantity_in_stock, reorder_level, reorder_quantity,
     unit_cost, warehouse_location, status, inventory_type, last_restock_date)
SELECT
    current_setting('app.current_tenant', true),
    p.id,
    99999, 0, 0,
    0::NUMERIC, 'Tại chỗ', 'ACTIVE', 'RETAIL', NOW()
FROM product p
WHERE p.tenant_id = current_setting('app.current_tenant', true)
  AND p.sku LIKE 'LP-%'
ON CONFLICT (product_id) DO NOTHING;

-- ── 6. Loyalty program ───────────────────────────────────────
INSERT INTO loyalty_programs
    (tenant_id, points_per_amount, amount_per_points, redemption_points_per_discount,
     redemption_discount_amount, min_redemption_points, is_active)
VALUES
    (current_setting('app.current_tenant', true), 1, 10000, 100, 10000.00, 100, TRUE);

-- ── 7. Loyalty tiers ──────────────────────────────────────────
INSERT INTO loyalty_tiers
    (tenant_id, name, min_spend, points_multiplier, color, description, sort_order)
VALUES
    (current_setting('app.current_tenant', true), 'Đồng',      0,         1.00, '#CD7F32', 'Thành viên cơ bản',             1),
    (current_setting('app.current_tenant', true), 'Bạc',       5000000,   1.25, '#9E9E9E', 'Chi tiêu từ 5 triệu VND',       2),
    (current_setting('app.current_tenant', true), 'Vàng',      20000000,  1.50, '#FFC107', 'Chi tiêu từ 20 triệu VND',      3),
    (current_setting('app.current_tenant', true), 'Kim cương', 60000000,  2.00, '#00BCD4', 'Chi tiêu từ 60 triệu VND',      4);

-- ── 8. Print template ─────────────────────────────────────────
INSERT INTO print_templates (tenant_id, template_type, name, config_json, is_default) VALUES
    (current_setting('app.current_tenant', true), 'POS_RECEIPT', 'Mặc định', '{
  "headerText": "",
  "footerText": "Cảm ơn quý khách!\nHẹn gặp lại lần sau!",
  "showAddress": true,
  "showTaxId": false,
  "showOrderNumber": true,
  "showDateTime": true,
  "showCustomer": true,
  "showStaff": true,
  "showTaxBreakdown": false,
  "showCashDetails": false,
  "paperWidth": "80mm",
  "autoClose": true
}', TRUE)
ON CONFLICT (template_type, name, tenant_id) DO NOTHING;

-- ── 9. Attribute groups & definitions ────────────────────────
INSERT INTO attribute_group (tenant_id, product_type_id, code, name, display_order)
SELECT current_setting('app.current_tenant', true), id, 'lash_pmu_info', 'Thông tin dịch vụ', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'service_category', 'Nhóm dịch vụ (Nối mi/Xăm mày/Xăm môi/Xăm mí)', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'lash_pmu_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'technique', 'Kỹ thuật thực hiện', 'STRING', FALSE, TRUE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'lash_pmu_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'skin_type', 'Loại da / Mắt phù hợp', 'STRING', FALSE, FALSE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'lash_pmu_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
