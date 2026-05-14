-- ============================================================
-- TENANT SEED — DEFAULT DATA: SALON TÓC / HAIR SALON (NỮ & UNISEX)
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',     'Dịch vụ',                    'Dịch vụ salon tóc nữ / unisex'),
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
    (current_setting('app.current_tenant', true), 'Cắt tóc',              NULL),
    (current_setting('app.current_tenant', true), 'Nhuộm tóc',           NULL),
    (current_setting('app.current_tenant', true), 'Uốn & Duỗi',          NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc tóc',        NULL),
    (current_setting('app.current_tenant', true), 'Gội đầu & Massage',   NULL),
    (current_setting('app.current_tenant', true), 'Tạo kiểu & Combo',    NULL);

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
    -- Cắt tóc nữ
    ('HS-001', 'Cắt tóc nữ ngắn',              'Cắt tóc ngắn cho nữ',                           120000,  45),
    ('HS-002', 'Cắt tóc nữ dài',               'Cắt tóc dài cho nữ, kèm tỉa thưa',             150000,  60),
    ('HS-003', 'Cắt layer',                     'Cắt layer tạo độ phồng và bồng bềnh',           150000,  60),
    ('HS-004', 'Cắt tóc nam / unisex',          'Cắt tóc cơ bản cho nam hoặc unisex',             80000,  30),
    ('HS-005', 'Tỉa tóc & chỉnh đuôi',         'Tỉa thưa và chỉnh lại đuôi tóc',                80000,  30),
    -- Nhuộm tóc
    ('HS-006', 'Nhuộm màu toàn bộ (tóc ngắn)', 'Nhuộm màu đơn toàn đầu tóc ngắn',             400000,  90),
    ('HS-007', 'Nhuộm màu toàn bộ (tóc dài)',  'Nhuộm màu đơn toàn đầu tóc dài',              600000, 120),
    ('HS-008', 'Nhuộm highlight',               'Nhuộm highlight / balayage từng sợi',          700000, 150),
    ('HS-009', 'Nhuộm ombre / highlight dài',   'Kỹ thuật ombre hoặc balayage tóc dài',         900000, 180),
    ('HS-010', 'Tẩy tóc',                       'Tẩy màu cũ để chuẩn bị nhuộm màu mới',        400000,  60),
    -- Uốn & Duỗi
    ('HS-011', 'Uốn tóc (tóc ngắn)',            'Uốn xoăn tóc ngắn hoặc trung bình',           400000, 120),
    ('HS-012', 'Uốn tóc (tóc dài)',             'Uốn xoăn tóc dài',                             600000, 150),
    ('HS-013', 'Duỗi / Ép thẳng (tóc ngắn)',   'Duỗi hoặc ép thẳng tóc ngắn / trung',         400000, 120),
    ('HS-014', 'Duỗi / Ép thẳng (tóc dài)',    'Duỗi hoặc ép thẳng tóc dài',                   600000, 150),
    ('HS-015', 'Ép Keratin phục hồi',           'Ép Keratin làm mượt và phục hồi tóc hư',       900000, 180),
    ('HS-016', 'Uốn phồng chân tóc',           'Uốn phồng tạo volume cho tóc xẹp',             500000, 120),
    -- Chăm sóc tóc
    ('HS-017', 'Hấp dầu phục hồi',             'Hấp dầu dưỡng ẩm sâu phục hồi tóc hư',        200000,  60),
    ('HS-018', 'Hấp dầu Collagen',             'Hấp dầu Collagen tăng độ đàn hồi',             300000,  75),
    ('HS-019', 'Cắt tỉa tóc hư tơi',          'Cắt bỏ phần tóc bị hư, ngọn tóc chẻ',          80000,  20),
    -- Gội đầu & Massage
    ('HS-020', 'Gội đầu đơn',                  'Gội đầu với dầu gội phù hợp loại tóc',          60000,  25),
    ('HS-021', 'Gội đầu + xả dưỡng',          'Gội đầu kèm xả dưỡng tóc chuyên dụng',          80000,  35),
    ('HS-022', 'Gội đầu + massage đầu',        'Gội đầu kết hợp massage thư giãn',              100000,  40),
    -- Tạo kiểu & Combo
    ('HS-023', 'Tạo kiểu đi tiệc',            'Tạo kiểu tóc đi dự tiệc hoặc sự kiện',         200000,  45),
    ('HS-024', 'Combo Cắt + Gội + Sấy',       'Cắt tóc + gội đầu + sấy tạo kiểu',             200000,  75),
    ('HS-025', 'Combo Cắt + Hấp dầu',         'Cắt tóc + hấp dầu phục hồi',                   300000,  90)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('HS-001', 'Cắt tóc'),
    ('HS-002', 'Cắt tóc'),
    ('HS-003', 'Cắt tóc'),
    ('HS-004', 'Cắt tóc'),
    ('HS-005', 'Cắt tóc'),
    ('HS-006', 'Nhuộm tóc'),
    ('HS-007', 'Nhuộm tóc'),
    ('HS-008', 'Nhuộm tóc'),
    ('HS-009', 'Nhuộm tóc'),
    ('HS-010', 'Nhuộm tóc'),
    ('HS-011', 'Uốn & Duỗi'),
    ('HS-012', 'Uốn & Duỗi'),
    ('HS-013', 'Uốn & Duỗi'),
    ('HS-014', 'Uốn & Duỗi'),
    ('HS-015', 'Uốn & Duỗi'),
    ('HS-016', 'Uốn & Duỗi'),
    ('HS-017', 'Chăm sóc tóc'),
    ('HS-018', 'Chăm sóc tóc'),
    ('HS-019', 'Chăm sóc tóc'),
    ('HS-020', 'Gội đầu & Massage'),
    ('HS-021', 'Gội đầu & Massage'),
    ('HS-022', 'Gội đầu & Massage'),
    ('HS-023', 'Tạo kiểu & Combo'),
    ('HS-024', 'Tạo kiểu & Combo'),
    ('HS-025', 'Tạo kiểu & Combo')
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
  AND p.sku LIKE 'HS-%'
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
    (current_setting('app.current_tenant', true), 'Bạc',       3000000,   1.25, '#9E9E9E', 'Chi tiêu từ 3 triệu VND',       2),
    (current_setting('app.current_tenant', true), 'Vàng',      15000000,  1.50, '#FFC107', 'Chi tiêu từ 15 triệu VND',      3),
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
}', TRUE)
ON CONFLICT (template_type, name, tenant_id) DO NOTHING;

-- ── 9. Attribute groups & definitions ────────────────────────
INSERT INTO attribute_group (tenant_id, product_type_id, code, name, display_order)
SELECT current_setting('app.current_tenant', true), id, 'salon_info', 'Thông tin dịch vụ', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'service_type', 'Loại dịch vụ (Cắt/Nhuộm/Uốn/Duỗi/Hấp)', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'salon_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'hair_length', 'Độ dài tóc (Ngắn/Trung bình/Dài)', 'STRING', FALSE, FALSE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'salon_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'gender_target', 'Đối tượng (Nam/Nữ/Unisex)', 'STRING', FALSE, FALSE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'salon_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
