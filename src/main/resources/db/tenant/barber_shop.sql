-- ============================================================
-- TENANT SEED — DEFAULT DATA: BARBER SHOP / SALON (TIỆM CẮT TÓC)
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
-- SERVICE type is barber-shop specific; the remaining 18 standard
-- types are included so the owner can add retail products later.
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',      'Dịch vụ',                    'Dịch vụ tiệm tóc / salon'),
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
    (current_setting('app.current_tenant', true), 'Cắt tóc nam',          NULL),
    (current_setting('app.current_tenant', true), 'Cắt tóc nữ',          NULL),
    (current_setting('app.current_tenant', true), 'Nhuộm & Uốn',         NULL),
    (current_setting('app.current_tenant', true), 'Chăm sóc râu',        NULL),
    (current_setting('app.current_tenant', true), 'Gội đầu & Massage',   NULL),
    (current_setting('app.current_tenant', true), 'Tạo kiểu & Combo',    NULL);

-- ── 3. Services (25 pre-built services with duration_minutes) ─
-- cost_price = 0 for services (no material cost tracked here).
-- NOTE: stock quantity is set very high (99999) because services are
-- unlimited. A future SERVICE inventory type will skip stock deduction.
INSERT INTO product (tenant_id, product_type_id, sku, name, description, price, cost_price, unit, status, duration_minutes)
SELECT
    current_setting('app.current_tenant', true),
    pt.id,
    p.sku, p.name, p.description,
    p.price::NUMERIC, 0::NUMERIC,
    'dịch vụ', 'ACTIVE',
    p.dur::INT
FROM (VALUES
    -- Cắt tóc nam
    ('SVC-001', 'Cắt tóc nam',                     'Cắt tóc cơ bản cho nam',                         80000,  30),
    ('SVC-002', 'Cắt + gội đầu nam',               'Cắt tóc kèm gội đầu cho nam',                   100000,  45),
    ('SVC-003', 'Cắt tóc trẻ em',                  'Cắt tóc cho bé (dưới 12 tuổi)',                  60000,  20),
    ('SVC-004', 'Cắt Fade / Undercut',              'Cắt kỹ thuật Fade hoặc Undercut',               150000,  60),
    -- Cắt tóc nữ
    ('SVC-005', 'Cắt tóc nữ',                      'Cắt tóc cơ bản cho nữ',                         120000,  45),
    ('SVC-006', 'Cắt + gội đầu nữ',                'Cắt tóc kèm gội đầu cho nữ',                   150000,  60),
    ('SVC-007', 'Cắt layer / Cắt tỉa nữ',          'Cắt layer hoặc tỉa thưa cho nữ',               150000,  60),
    -- Nhuộm & Uốn
    ('SVC-008', 'Nhuộm tóc',                        'Nhuộm màu toàn bộ mái tóc',                    400000,  90),
    ('SVC-009', 'Nhuộm highlight',                  'Nhuộm highlight / ombre',                       600000, 120),
    ('SVC-010', 'Uốn tóc',                          'Uốn xoăn toàn bộ',                             500000, 120),
    ('SVC-011', 'Duỗi / Thẳng tóc',                'Duỗi hoặc ép thẳng tóc',                        500000, 120),
    ('SVC-012', 'Ép tóc Keratin',                   'Ép Keratin phục hồi và làm mượt tóc',          800000, 180),
    -- Chăm sóc râu
    ('SVC-013', 'Cạo râu',                          'Cạo râu sạch bằng dao cạo',                     50000,  15),
    ('SVC-014', 'Tỉa râu + tạo hình',              'Tỉa và tạo hình râu theo yêu cầu',              80000,  30),
    ('SVC-015', 'Cạo râu nóng truyền thống',        'Cạo râu nóng kiểu truyền thống',                70000,  20),
    -- Gội đầu & Massage
    ('SVC-016', 'Gội đầu dưỡng tóc',               'Gội đầu với dầu dưỡng chuyên dụng',            80000,  30),
    ('SVC-017', 'Massage đầu',                      'Massage đầu thư giãn 30 phút',                 100000,  30),
    ('SVC-018', 'Gội + massage đầu',               'Gội đầu kết hợp massage thư giãn',             130000,  45),
    ('SVC-019', 'Hấp dầu phục hồi tóc',            'Hấp dầu dưỡng ẩm và phục hồi tóc hư',        200000,  60),
    -- Tạo kiểu & Combo
    ('SVC-020', 'Tạo kiểu tóc',                    'Tạo kiểu bằng gel, wax hoặc sáp',             100000,  30),
    ('SVC-021', 'Tạo kiểu đặc biệt',               'Tạo kiểu đi tiệc / sự kiện',                  250000,  60),
    ('SVC-022', 'Combo cắt + cạo râu',             'Cắt tóc nam kèm cạo râu',                     120000,  45),
    ('SVC-023', 'Combo đầy đủ',                    'Cắt tóc + gội đầu + massage',                  200000,  90),
    ('SVC-024', 'Gói chăm sóc tóc',               'Cắt + hấp dầu + nhuộm màu nhẹ',               500000, 150),
    ('SVC-025', 'Combo trẻ em',                    'Cắt tóc + gội đầu cho bé',                     80000,  30)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('SVC-001', 'Cắt tóc nam'),
    ('SVC-002', 'Cắt tóc nam'),
    ('SVC-003', 'Cắt tóc nam'),
    ('SVC-004', 'Cắt tóc nam'),
    ('SVC-005', 'Cắt tóc nữ'),
    ('SVC-006', 'Cắt tóc nữ'),
    ('SVC-007', 'Cắt tóc nữ'),
    ('SVC-008', 'Nhuộm & Uốn'),
    ('SVC-009', 'Nhuộm & Uốn'),
    ('SVC-010', 'Nhuộm & Uốn'),
    ('SVC-011', 'Nhuộm & Uốn'),
    ('SVC-012', 'Nhuộm & Uốn'),
    ('SVC-013', 'Chăm sóc râu'),
    ('SVC-014', 'Chăm sóc râu'),
    ('SVC-015', 'Chăm sóc râu'),
    ('SVC-016', 'Gội đầu & Massage'),
    ('SVC-017', 'Gội đầu & Massage'),
    ('SVC-018', 'Gội đầu & Massage'),
    ('SVC-019', 'Gội đầu & Massage'),
    ('SVC-020', 'Tạo kiểu & Combo'),
    ('SVC-021', 'Tạo kiểu & Combo'),
    ('SVC-022', 'Tạo kiểu & Combo'),
    ('SVC-023', 'Tạo kiểu & Combo'),
    ('SVC-024', 'Tạo kiểu & Combo'),
    ('SVC-025', 'Tạo kiểu & Combo')
) AS pc(sku, cat_name)
JOIN product p ON p.sku = pc.sku AND p.tenant_id = current_setting('app.current_tenant', true)
JOIN category c ON c.name = pc.cat_name AND c.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT DO NOTHING;

-- ── 5. Inventory (services are unlimited — high stock until a
--    service inventory type is implemented to skip deduction) ──
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
  AND p.sku LIKE 'SVC-%'
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

-- ── 8. Print template (service receipt) ──────────────────────
-- Shows staff name; hides tax breakdown and cash details (service shops
-- typically collect cash simply and don't need tax line items).
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
SELECT current_setting('app.current_tenant', true), id, 'service_info', 'Thông tin dịch vụ', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'service_type', 'Loại dịch vụ', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'service_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'gender_target', 'Đối tượng (Nam/Nữ/Unisex)', 'STRING', FALSE, FALSE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'service_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'skill_level', 'Cấp bậc thợ', 'STRING', FALSE, FALSE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'service_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
