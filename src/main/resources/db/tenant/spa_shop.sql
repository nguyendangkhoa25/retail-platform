-- ============================================================
-- TENANT SEED — DEFAULT DATA: SPA / THẨM MỸ VIỆN
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
-- SERVICE type is spa-specific; the remaining 18 standard
-- types are included so the owner can add retail products later.
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',      'Dịch vụ',                    'Dịch vụ spa / thẩm mỹ viện'),
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
    (current_setting('app.current_tenant', true), 'Massage',                NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc da mặt',       NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc cơ thể',       NULL),
    (current_setting('app.current_tenant', true), 'Waxing & Triệt lông',   NULL),
    (current_setting('app.current_tenant', true), 'Điều trị đặc biệt',     NULL),
    (current_setting('app.current_tenant', true), 'Combo & Liệu trình',    NULL);

-- ── 3. Services (24 pre-built spa services with duration_minutes) ─
INSERT INTO product (tenant_id, product_type_id, sku, name, description, price, cost_price, unit, status, duration_minutes)
SELECT
    current_setting('app.current_tenant', true),
    pt.id,
    p.sku, p.name, p.description,
    p.price::NUMERIC, 0::NUMERIC,
    'lần', 'ACTIVE',
    p.dur::INT
FROM (VALUES
    -- Massage
    ('SPA-001', 'Massage thư giãn toàn thân',      'Massage thư giãn cơ thể 60 phút',            350000,  60),
    ('SPA-002', 'Massage thư giãn toàn thân 90p',  'Massage thư giãn cơ thể 90 phút',            500000,  90),
    ('SPA-003', 'Massage đầu & cổ vai gáy',        'Giảm đau đầu, căng thẳng vùng cổ vai',      200000,  45),
    ('SPA-004', 'Massage bàn chân phản xạ',        'Massage bấm huyệt bàn chân 45 phút',         200000,  45),
    ('SPA-005', 'Massage đá nóng',                 'Massage kết hợp đá bazan nóng 75 phút',      600000,  75),
    ('SPA-006', 'Massage aroma (tinh dầu)',        'Massage bằng tinh dầu thiên nhiên 60 phút',  450000,  60),
    -- Chăm sóc da mặt
    ('SPA-007', 'Chăm sóc da mặt cơ bản',         'Làm sạch sâu, tẩy da chết, đắp mặt nạ',    250000,  60),
    ('SPA-008', 'Chăm sóc da mặt chuyên sâu',     'Trị liệu chuyên sâu theo loại da',           400000,  90),
    ('SPA-009', 'Nặn mụn chuyên nghiệp',          'Nặn mụn vô trùng, thu nhỏ lỗ chân lông',   300000,  60),
    ('SPA-010', 'Lột da hóa học (Peel)',           'Tái tạo da bằng acid nhẹ',                   350000,  45),
    ('SPA-011', 'Đắp mặt nạ dưỡng ẩm',           'Mặt nạ dưỡng ẩm và làm sáng da',            150000,  30),
    -- Chăm sóc cơ thể
    ('SPA-012', 'Tẩy tế bào chết toàn thân',      'Tẩy da chết toàn thân bằng muối / đường',   300000,  45),
    ('SPA-013', 'Ủ dưỡng thể trắng da',           'Ủ trắng toàn thân với kem dưỡng cao cấp',   400000,  60),
    ('SPA-014', 'Quấn nóng giảm eo',              'Liệu pháp quấn nóng hỗ trợ giảm béo',       500000,  60),
    ('SPA-015', 'Dưỡng ẩm tay chân',             'Ủ và dưỡng ẩm chuyên sâu tay và chân',      200000,  40),
    -- Waxing & Triệt lông
    ('SPA-016', 'Wax lông nách',                  'Wax lông nách bằng sáp nóng / lạnh',         80000,  15),
    ('SPA-017', 'Wax lông chân (bắp đùi)',        'Wax lông đùi bằng sáp nóng',                150000,  30),
    ('SPA-018', 'Wax lông chân (toàn chân)',      'Wax lông toàn bộ hai chân',                  250000,  45),
    ('SPA-019', 'Wax bikini cơ bản',             'Wax vùng bikini tiêu chuẩn',                 200000,  30),
    ('SPA-020', 'Wax mặt (môi, mày)',            'Wax lông mặt: môi trên, chân mày',             60000,  15),
    -- Điều trị đặc biệt
    ('SPA-021', 'Trị nám, tàn nhang',             'Điều trị nám và tàn nhang bằng công nghệ',   500000,  60),
    ('SPA-022', 'Trị mụn lưng chuyên sâu',       'Làm sạch và trị mụn vùng lưng',              350000,  60),
    -- Combo & Liệu trình
    ('SPA-023', 'Combo Mặt + Massage 90p',        'Chăm sóc da mặt + massage thư giãn',         600000,  90),
    ('SPA-024', 'Liệu trình 5 buổi chăm sóc da', 'Gói 5 buổi chăm sóc da mặt chuyên sâu',    1800000, 300)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('SPA-001', 'Massage'),
    ('SPA-002', 'Massage'),
    ('SPA-003', 'Massage'),
    ('SPA-004', 'Massage'),
    ('SPA-005', 'Massage'),
    ('SPA-006', 'Massage'),
    ('SPA-007', 'Chăm sóc da mặt'),
    ('SPA-008', 'Chăm sóc da mặt'),
    ('SPA-009', 'Chăm sóc da mặt'),
    ('SPA-010', 'Chăm sóc da mặt'),
    ('SPA-011', 'Chăm sóc da mặt'),
    ('SPA-012', 'Chăm sóc cơ thể'),
    ('SPA-013', 'Chăm sóc cơ thể'),
    ('SPA-014', 'Chăm sóc cơ thể'),
    ('SPA-015', 'Chăm sóc cơ thể'),
    ('SPA-016', 'Waxing & Triệt lông'),
    ('SPA-017', 'Waxing & Triệt lông'),
    ('SPA-018', 'Waxing & Triệt lông'),
    ('SPA-019', 'Waxing & Triệt lông'),
    ('SPA-020', 'Waxing & Triệt lông'),
    ('SPA-021', 'Điều trị đặc biệt'),
    ('SPA-022', 'Điều trị đặc biệt'),
    ('SPA-023', 'Combo & Liệu trình'),
    ('SPA-024', 'Combo & Liệu trình')
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
  AND p.sku LIKE 'SPA-%'
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
SELECT current_setting('app.current_tenant', true), id, 'spa_info', 'Thông tin dịch vụ spa', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'treatment_type', 'Loại liệu trình', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'spa_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'skin_type', 'Loại da (Da thường / Da dầu / Da khô / Da nhạy cảm)', 'STRING', FALSE, FALSE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'spa_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'body_area', 'Vùng điều trị', 'STRING', FALSE, TRUE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'spa_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
