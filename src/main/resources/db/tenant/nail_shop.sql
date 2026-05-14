-- ============================================================
-- TENANT SEED — DEFAULT DATA: NAIL STUDIO / TIỆM NAIL
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
-- SERVICE type is nail-shop specific; the remaining 18 standard
-- types are included so the owner can add retail products later.
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',      'Dịch vụ',                    'Dịch vụ tiệm nail / làm móng'),
    (current_setting('app.current_tenant', true), 'FOOD',         'Thực phẩm',                  'Thực phẩm và đồ ăn'),
    (current_setting('app.current_tenant', true), 'BEVERAGE',     'Đồ uống',                    'Nước giải khát, bia, nước suối'),
    (current_setting('app.current_tenant', true), 'DRUG',         'Dược phẩm',                  'Thuốc và sản phẩm dược'),
    (current_setting('app.current_tenant', true), 'CONVENIENCE',  'Hàng tiêu dùng',             'Hàng tiêu dùng thiết yếu'),
    (current_setting('app.current_tenant', true), 'BIKE',         'Xe đạp / Xe máy',            'Xe đạp và phụ tùng xe máy'),
    (current_setting('app.current_tenant', true), 'HARDWARE',     'Đồ sắt / Dụng cụ',          'Đồ sắt và dụng cụ'),
    (current_setting('app.current_tenant', true), 'CLOTHING',     'Quần áo / May mặc',          'Quần áo và phụ kiện'),
    (current_setting('app.current_tenant', true), 'ELECTRONICS',  'Điện tử',                    'Thiết bị điện tử'),
    (current_setting('app.current_tenant', true), 'FURNITURE',    'Đồ nội thất',                'Nội thất gia đình'),
    (current_setting('app.current_tenant', true), 'BEAUTY',       'Làm đẹp / Chăm sóc cá nhân','Sản phẩm làm đẹp và vệ sinh cá nhân'),
    (current_setting('app.current_tenant', true), 'TOYS',         'Đồ chơi / Trò chơi',        'Đồ chơi và trò chơi'),
    (current_setting('app.current_tenant', true), 'BOOKS',        'Sách / Văn phòng phẩm',     'Sách và văn phòng phẩm'),
    (current_setting('app.current_tenant', true), 'SPORTS',       'Thể thao / Ngoài trời',     'Thiết bị thể thao'),
    (current_setting('app.current_tenant', true), 'AUTO_PARTS',   'Phụ tùng ô tô',             'Phụ tùng và phụ kiện ô tô'),
    (current_setting('app.current_tenant', true), 'APPLIANCES',   'Đồ gia dụng',                'Thiết bị gia dụng'),
    (current_setting('app.current_tenant', true), 'OFFICE',       'Văn phòng phẩm',             'Đồ dùng văn phòng'),
    (current_setting('app.current_tenant', true), 'PET',          'Thú cưng',                  'Thức ăn và phụ kiện thú cưng'),
    (current_setting('app.current_tenant', true), 'HEALTH',       'Sức khỏe / Dinh dưỡng',     'Sản phẩm sức khỏe và dinh dưỡng')
ON CONFLICT (code, tenant_id) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;

-- ── 2. Service categories ─────────────────────────────────────
INSERT INTO category (tenant_id, name, parent_id) VALUES
    (current_setting('app.current_tenant', true), 'Sơn móng thường',     NULL),
    (current_setting('app.current_tenant', true), 'Gel & Acrylic',       NULL),
    (current_setting('app.current_tenant', true), 'Vẽ nail & Nghệ thuật',NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc bàn tay',   NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc bàn chân',  NULL),
    (current_setting('app.current_tenant', true), 'Combo & Gói dịch vụ',NULL);

-- ── 3. Services (22 pre-built nail services with duration_minutes) ─
INSERT INTO product (tenant_id, product_type_id, sku, name, description, price, cost_price, unit, status, duration_minutes)
SELECT
    current_setting('app.current_tenant', true),
    pt.id,
    p.sku, p.name, p.description,
    p.price::NUMERIC, 0::NUMERIC,
    'lần', 'ACTIVE',
    p.dur::INT
FROM (VALUES
    -- Sơn móng thường
    ('NAIL-001', 'Sơn màu thường (10 ngón tay)',  'Sơn màu thường đơn giản 10 ngón',             80000,  30),
    ('NAIL-002', 'Sơn màu thường (10 ngón chân)', 'Sơn màu thường đơn giản 10 ngón chân',        70000,  25),
    ('NAIL-003', 'Sơn màu Pháp (French)',          'Sơn French trắng đầu ngón kinh điển',        100000,  35),
    -- Gel & Acrylic
    ('NAIL-004', 'Sơn gel (tay)',                  'Sơn gel bền màu 2–3 tuần (tay)',             150000,  50),
    ('NAIL-005', 'Sơn gel (chân)',                 'Sơn gel bền màu 2–3 tuần (chân)',            120000,  40),
    ('NAIL-006', 'Đắp bột Acrylic (full set)',     'Đắp bột acrylic toàn bộ 10 ngón',           300000,  90),
    ('NAIL-007', 'Đắp gel Builder (full set)',     'Đắp gel cứng tạo hình 10 ngón',             280000,  80),
    ('NAIL-008', 'Đắp bột Dip Powder',             'Sơn bột nhúng bền và nhẹ hơn acrylic',      250000,  75),
    ('NAIL-009', 'Tháo gel / Tháo bột',            'Tháo gel hoặc bột acrylic an toàn',           80000,  30),
    -- Vẽ nail & Nghệ thuật
    ('NAIL-010', 'Vẽ nail đơn giản (mỗi ngón)',   'Họa tiết đơn giản: tim, hoa, sọc',            20000,  10),
    ('NAIL-011', 'Vẽ nail phức tạp (mỗi ngón)',   'Họa tiết phức tạp hoặc theo yêu cầu',         40000,  20),
    ('NAIL-012', 'Nail art full set (tay)',        'Vẽ nghệ thuật toàn bộ 10 ngón tay',          350000,  90),
    ('NAIL-013', 'Đính đá / Phụ kiện (mỗi ngón)', 'Đính đá rhinestone, charm, foil',             25000,  10),
    ('NAIL-014', 'Nail Ombre (full set)',          'Gradient màu ombre chuyên nghiệp',            250000,  70),
    -- Chăm sóc bàn tay
    ('NAIL-015', 'Manicure cơ bản',               'Cắt, dũa, đẩy da non, dưỡng ẩm tay',        100000,  40),
    ('NAIL-016', 'Manicure + Sơn gel',            'Manicure cơ bản kèm sơn gel',                220000,  70),
    ('NAIL-017', 'Dưỡng ẩm tay chuyên sâu',      'Ủ tay với kem dưỡng chuyên dụng',             80000,  25),
    -- Chăm sóc bàn chân
    ('NAIL-018', 'Pedicure cơ bản',               'Ngâm chân, cắt dũa, đẩy da non, dưỡng ẩm',  130000,  50),
    ('NAIL-019', 'Pedicure + Sơn gel',            'Pedicure cơ bản kèm sơn gel chân',           230000,  75),
    ('NAIL-020', 'Tẩy da chết bàn chân',         'Tẩy tế bào chết và massage bàn chân',         100000,  35),
    -- Combo & Gói dịch vụ
    ('NAIL-021', 'Combo Tay + Chân (sơn thường)', 'Sơn màu thường cả tay và chân',              130000,  50),
    ('NAIL-022', 'Combo Tay + Chân (gel)',        'Sơn gel cả tay và chân',                      250000,  80)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('NAIL-001', 'Sơn móng thường'),
    ('NAIL-002', 'Sơn móng thường'),
    ('NAIL-003', 'Sơn móng thường'),
    ('NAIL-004', 'Gel & Acrylic'),
    ('NAIL-005', 'Gel & Acrylic'),
    ('NAIL-006', 'Gel & Acrylic'),
    ('NAIL-007', 'Gel & Acrylic'),
    ('NAIL-008', 'Gel & Acrylic'),
    ('NAIL-009', 'Gel & Acrylic'),
    ('NAIL-010', 'Vẽ nail & Nghệ thuật'),
    ('NAIL-011', 'Vẽ nail & Nghệ thuật'),
    ('NAIL-012', 'Vẽ nail & Nghệ thuật'),
    ('NAIL-013', 'Vẽ nail & Nghệ thuật'),
    ('NAIL-014', 'Vẽ nail & Nghệ thuật'),
    ('NAIL-015', 'Chăm sóc bàn tay'),
    ('NAIL-016', 'Chăm sóc bàn tay'),
    ('NAIL-017', 'Chăm sóc bàn tay'),
    ('NAIL-018', 'Chăm sóc bàn chân'),
    ('NAIL-019', 'Chăm sóc bàn chân'),
    ('NAIL-020', 'Chăm sóc bàn chân'),
    ('NAIL-021', 'Combo & Gói dịch vụ'),
    ('NAIL-022', 'Combo & Gói dịch vụ')
) AS pc(sku, cat_name)
JOIN product p ON p.sku = pc.sku AND p.tenant_id = current_setting('app.current_tenant', true)
JOIN category c ON c.name = pc.cat_name AND c.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT DO NOTHING;

-- ── 5. Inventory (services are unlimited) ────────────────────
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
  AND p.sku LIKE 'NAIL-%'
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
    (current_setting('app.current_tenant', true), 'Bạc',       2000000,   1.25, '#9E9E9E', 'Chi tiêu từ 2 triệu VND',       2),
    (current_setting('app.current_tenant', true), 'Vàng',      10000000,  1.50, '#FFC107', 'Chi tiêu từ 10 triệu VND',      3),
    (current_setting('app.current_tenant', true), 'Kim cương', 50000000,  2.00, '#00BCD4', 'Chi tiêu từ 50 triệu VND',      4);

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
}', TRUE),
    (current_setting('app.current_tenant', true), 'PRODUCT_STAMP', 'Tem dịch vụ', '{
  "showShopName": true,
  "showSku": false,
  "showPrice": true,
  "showBarcode": false,
  "showLocation": false,
  "showBatch": false,
  "showExpiry": false,
  "labelWidth": 60,
  "labelHeight": 38
}', TRUE)
ON CONFLICT (template_type, name, tenant_id) DO NOTHING;

-- ── 9. Attribute groups & definitions (SERVICE type) ─────────
INSERT INTO attribute_group (tenant_id, product_type_id, code, name, display_order)
SELECT current_setting('app.current_tenant', true), id, 'nail_info', 'Thông tin dịch vụ nail', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'nail_type', 'Loại nail', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'nail_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'nail_target', 'Vị trí (Tay / Chân / Cả hai)', 'STRING', FALSE, FALSE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'nail_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'nail_art_style', 'Kiểu thiết kế', 'STRING', FALSE, TRUE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'nail_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
