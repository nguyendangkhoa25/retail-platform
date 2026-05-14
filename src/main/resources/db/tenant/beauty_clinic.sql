-- ============================================================
-- TENANT SEED — DEFAULT DATA: THẨM MỸ VIỆN / BEAUTY CLINIC
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',     'Dịch vụ',                    'Dịch vụ thẩm mỹ viện / điều trị thẩm mỹ'),
    (current_setting('app.current_tenant', true), 'BEAUTY',      'Làm đẹp / Chăm sóc cá nhân','Sản phẩm làm đẹp và vệ sinh cá nhân'),
    (current_setting('app.current_tenant', true), 'HEALTH',      'Sức khỏe / Dinh dưỡng',     'Sản phẩm sức khỏe và dinh dưỡng'),
    (current_setting('app.current_tenant', true), 'DRUG',        'Dược phẩm',                  'Thuốc và sản phẩm dược'),
    (current_setting('app.current_tenant', true), 'BEVERAGE',    'Đồ uống',                    'Nước giải khát, bia, nước suối'),
    (current_setting('app.current_tenant', true), 'FOOD',        'Thực phẩm',                  'Thực phẩm và đồ ăn'),
    (current_setting('app.current_tenant', true), 'CONVENIENCE', 'Hàng tiêu dùng',             'Hàng tiêu dùng thiết yếu'),
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
    (current_setting('app.current_tenant', true), 'BIKE',        'Xe đạp / Xe máy',            'Xe đạp và phụ tùng xe máy'),
    (current_setting('app.current_tenant', true), 'HARDWARE',    'Đồ sắt / Dụng cụ',          'Đồ sắt và dụng cụ')
ON CONFLICT (code, tenant_id) DO UPDATE SET name = EXCLUDED.name, description = EXCLUDED.description;

-- ── 2. Service categories ─────────────────────────────────────
INSERT INTO category (tenant_id, name, parent_id) VALUES
    (current_setting('app.current_tenant', true), 'Chăm sóc da mặt',       NULL),
    (current_setting('app.current_tenant', true), 'Trị mụn & Nám',         NULL),
    (current_setting('app.current_tenant', true), 'Công nghệ thẩm mỹ',     NULL),
    (current_setting('app.current_tenant', true), 'Điều trị cơ thể',       NULL),
    (current_setting('app.current_tenant', true), 'Waxing & Triệt lông',   NULL),
    (current_setting('app.current_tenant', true), 'Combo & Liệu trình',    NULL);

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
    -- Chăm sóc da mặt
    ('BC-001', 'Chăm sóc da cơ bản',             'Tẩy tế bào chết + đắp mặt nạ + dưỡng ẩm',      300000, 60),
    ('BC-002', 'Chăm sóc da chuyên sâu',          'Phân tích da + điều trị theo loại da',           500000, 90),
    ('BC-003', 'Lột da hóa học (Chemical Peel)',  'Tái tạo da bằng acid AHA/BHA/TCA nhẹ',          500000, 60),
    ('BC-004', 'Đắp mặt nạ dưỡng ẩm cao cấp',   'Mặt nạ serum dưỡng ẩm và làm sáng da',          200000, 40),
    ('BC-005', 'Nặn mụn chuyên nghiệp',           'Nặn mụn vô khuẩn + thu nhỏ lỗ chân lông',       350000, 60),
    -- Trị mụn & Nám
    ('BC-006', 'Trị mụn trứng cá',               'Liệu trình điều trị mụn trứng cá chuyên sâu',    600000, 90),
    ('BC-007', 'Trị nám & tàn nhang',            'Điều trị nám bằng serum và công nghệ ánh sáng',  700000, 75),
    ('BC-008', 'Trị thâm sau mụn',               'Giảm thâm và sẹo do mụn để lại',                500000, 60),
    ('BC-009', 'Trị nám laser',                  'Điều trị nám bằng laser ánh sáng xung',         1500000, 45),
    -- Công nghệ thẩm mỹ
    ('BC-010', 'RF nâng cơ (Radio Frequency)',   'Căng da và nâng cơ mặt bằng sóng RF',           1000000, 60),
    ('BC-011', 'HIFU nâng cơ mặt',              'Căng da siêu âm hội tụ không xâm lấn',          3000000, 90),
    ('BC-012', 'Microneedling tái tạo da',       'Vi kim tạo kênh dẫn truyền serum sâu vào da',    800000, 60),
    ('BC-013', 'IPL trị sắc tố & lỗ chân lông', 'IPL điều trị đốm nâu, sắc tố và se khít lỗ chân lông', 1000000, 45),
    ('BC-014', 'LED Therapy ánh sáng sinh học',  'Trị liệu ánh sáng xanh/đỏ kết hợp',             400000, 30),
    -- Điều trị cơ thể
    ('BC-015', 'Tẩy tế bào chết toàn thân',     'Tẩy da chết toàn thân bằng muối/đường',          350000, 45),
    ('BC-016', 'Ủ dưỡng thể trắng da',          'Ủ trắng toàn thân với kem dưỡng cao cấp',        450000, 60),
    ('BC-017', 'Trị thâm mông / thâm nách',     'Điều trị thâm vùng nách và mông',               400000, 45),
    ('BC-018', 'Điều trị rạn da',               'Giảm vết rạn da bằng vi kim hoặc laser',         800000, 60),
    -- Waxing & Triệt lông
    ('BC-019', 'Wax lông toàn thân',            'Wax lông toàn bộ cơ thể bằng sáp nóng',          500000, 60),
    ('BC-020', 'Wax lông nách',                 'Wax lông nách sáp nóng',                          80000, 15),
    ('BC-021', 'Triệt lông laser (vùng nhỏ)',   'Triệt lông bằng laser Diode/Alexandrite vùng nhỏ', 500000, 30),
    ('BC-022', 'Triệt lông laser (vùng lớn)',   'Triệt lông laser vùng lớn: chân, lưng',         1500000, 60),
    -- Combo & Liệu trình
    ('BC-023', 'Liệu trình 5 buổi chăm sóc da','Gói 5 buổi chăm sóc da mặt chuyên sâu',         2000000, 300),
    ('BC-024', 'Combo Trị mụn + Chăm sóc da',  'Trị mụn chuyên sâu + chăm sóc da cơ bản',        800000, 120)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('BC-001', 'Chăm sóc da mặt'),
    ('BC-002', 'Chăm sóc da mặt'),
    ('BC-003', 'Chăm sóc da mặt'),
    ('BC-004', 'Chăm sóc da mặt'),
    ('BC-005', 'Chăm sóc da mặt'),
    ('BC-006', 'Trị mụn & Nám'),
    ('BC-007', 'Trị mụn & Nám'),
    ('BC-008', 'Trị mụn & Nám'),
    ('BC-009', 'Trị mụn & Nám'),
    ('BC-010', 'Công nghệ thẩm mỹ'),
    ('BC-011', 'Công nghệ thẩm mỹ'),
    ('BC-012', 'Công nghệ thẩm mỹ'),
    ('BC-013', 'Công nghệ thẩm mỹ'),
    ('BC-014', 'Công nghệ thẩm mỹ'),
    ('BC-015', 'Điều trị cơ thể'),
    ('BC-016', 'Điều trị cơ thể'),
    ('BC-017', 'Điều trị cơ thể'),
    ('BC-018', 'Điều trị cơ thể'),
    ('BC-019', 'Waxing & Triệt lông'),
    ('BC-020', 'Waxing & Triệt lông'),
    ('BC-021', 'Waxing & Triệt lông'),
    ('BC-022', 'Waxing & Triệt lông'),
    ('BC-023', 'Combo & Liệu trình'),
    ('BC-024', 'Combo & Liệu trình')
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
  AND p.sku LIKE 'BC-%'
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
    (current_setting('app.current_tenant', true), 'Đồng',      0,          1.00, '#CD7F32', 'Thành viên cơ bản',              1),
    (current_setting('app.current_tenant', true), 'Bạc',       10000000,   1.25, '#9E9E9E', 'Chi tiêu từ 10 triệu VND',       2),
    (current_setting('app.current_tenant', true), 'Vàng',      50000000,   1.50, '#FFC107', 'Chi tiêu từ 50 triệu VND',       3),
    (current_setting('app.current_tenant', true), 'Kim cương', 150000000,  2.00, '#00BCD4', 'Chi tiêu từ 150 triệu VND',      4);

-- ── 8. Print template ─────────────────────────────────────────
INSERT INTO print_templates (tenant_id, template_type, name, config_json, is_default) VALUES
    (current_setting('app.current_tenant', true), 'POS_RECEIPT', 'Mặc định', '{
  "headerText": "",
  "footerText": "Cảm ơn quý khách!\nHẹn gặp lại lần sau!",
  "showAddress": true,
  "showTaxId": true,
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
SELECT current_setting('app.current_tenant', true), id, 'clinic_info', 'Thông tin dịch vụ', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'treatment_type', 'Loại điều trị (Chăm sóc/Trị liệu/Công nghệ/Triệt lông)', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'clinic_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'skin_type', 'Loại da phù hợp (Da thường/Da dầu/Da khô/Da nhạy cảm)', 'STRING', FALSE, FALSE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'clinic_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'technology', 'Công nghệ (Laser/RF/HIFU/IPL/LED/Vi kim)', 'STRING', FALSE, TRUE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'clinic_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'treatment_area', 'Vùng điều trị (Mặt/Cơ thể/Toàn thân)', 'STRING', FALSE, FALSE, TRUE, 4
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'clinic_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
