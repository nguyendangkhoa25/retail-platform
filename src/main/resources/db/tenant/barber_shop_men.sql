-- ============================================================
-- TENANT SEED — DEFAULT DATA: TIỆM TÓC NAM / MEN'S BARBER SHOP
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',     'Dịch vụ',                    'Dịch vụ tiệm tóc nam / barber'),
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
    (current_setting('app.current_tenant', true), 'Cạo & Chăm sóc râu',  NULL),
    (current_setting('app.current_tenant', true), 'Gội đầu & Massage',   NULL),
    (current_setting('app.current_tenant', true), 'Tạo kiểu',            NULL),
    (current_setting('app.current_tenant', true), 'Combo',               NULL);

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
    -- Cắt tóc
    ('BM-001', 'Cắt tóc thường',           'Cắt tóc cơ bản cho nam',                         80000,  25),
    ('BM-002', 'Cắt Fade',                 'Cắt kỹ thuật Fade (low/mid/high)',               150000,  45),
    ('BM-003', 'Cắt Undercut',             'Cắt Undercut đỉnh tự chọn',                     150000,  45),
    ('BM-004', 'Cắt Buzz Cut',             'Cắt tông ngắn đều toàn đầu',                     70000,  20),
    ('BM-005', 'Cắt tóc trẻ em',          'Cắt tóc cho bé trai dưới 12 tuổi',               60000,  20),
    ('BM-006', 'Cắt kỹ thuật cao (Textured/Taper)', 'Cắt texture hoặc taper chuyên nghiệp', 180000,  60),
    -- Cạo & Chăm sóc râu
    ('BM-007', 'Cạo râu',                  'Cạo râu sạch bằng dao cạo thẳng',               50000,  15),
    ('BM-008', 'Cạo râu nóng truyền thống','Cạo râu nóng với khăn nóng và dao thẳng',       80000,  25),
    ('BM-009', 'Tỉa râu + tạo hình',       'Tỉa và tạo hình râu theo yêu cầu',              80000,  25),
    ('BM-010', 'Chăm sóc râu cao cấp',     'Tỉa, tạo hình, dưỡng râu và dưỡng ẩm da',     120000,  40),
    -- Gội đầu & Massage
    ('BM-011', 'Gội đầu đơn',             'Gội đầu với dầu gội thường',                     50000,  20),
    ('BM-012', 'Gội đầu dưỡng tóc',       'Gội đầu với dầu gội trị gàu / dưỡng tóc',       70000,  25),
    ('BM-013', 'Massage đầu & vai',        'Massage đầu và vai gáy thư giãn',               80000,  20),
    -- Tạo kiểu
    ('BM-014', 'Tạo kiểu gel / wax',      'Tạo kiểu bằng gel, wax hoặc pomade',             50000,  15),
    ('BM-015', 'Tạo kiểu đặc biệt',       'Tạo kiểu đi tiệc / sự kiện đặc biệt',          150000,  30),
    -- Combo
    ('BM-016', 'Combo Cắt + Gội',         'Cắt tóc + gội đầu đơn',                        120000,  45),
    ('BM-017', 'Combo Cắt + Cạo râu',     'Cắt tóc + cạo râu sạch',                       120000,  40),
    ('BM-018', 'Combo Cắt + Gội + Massage','Cắt tóc + gội đầu + massage đầu',              180000,  60),
    ('BM-019', 'Combo Full Barber',        'Cắt Fade + cạo râu + gội đầu + tạo kiểu',      280000,  90)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('BM-001', 'Cắt tóc'),
    ('BM-002', 'Cắt tóc'),
    ('BM-003', 'Cắt tóc'),
    ('BM-004', 'Cắt tóc'),
    ('BM-005', 'Cắt tóc'),
    ('BM-006', 'Cắt tóc'),
    ('BM-007', 'Cạo & Chăm sóc râu'),
    ('BM-008', 'Cạo & Chăm sóc râu'),
    ('BM-009', 'Cạo & Chăm sóc râu'),
    ('BM-010', 'Cạo & Chăm sóc râu'),
    ('BM-011', 'Gội đầu & Massage'),
    ('BM-012', 'Gội đầu & Massage'),
    ('BM-013', 'Gội đầu & Massage'),
    ('BM-014', 'Tạo kiểu'),
    ('BM-015', 'Tạo kiểu'),
    ('BM-016', 'Combo'),
    ('BM-017', 'Combo'),
    ('BM-018', 'Combo'),
    ('BM-019', 'Combo')
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
  AND p.sku LIKE 'BM-%'
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
    (current_setting('app.current_tenant', true), 'Đồng',      0,        1.00, '#CD7F32', 'Thành viên cơ bản',        1),
    (current_setting('app.current_tenant', true), 'Bạc',       2000000,  1.25, '#9E9E9E', 'Chi tiêu từ 2 triệu VND',  2),
    (current_setting('app.current_tenant', true), 'Vàng',      5000000,  1.50, '#FFC107', 'Chi tiêu từ 5 triệu VND',  3),
    (current_setting('app.current_tenant', true), 'Kim cương', 20000000, 2.00, '#00BCD4', 'Chi tiêu từ 20 triệu VND', 4);

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

-- ── 9. Attribute groups & definitions (SERVICE type) ─────────
INSERT INTO attribute_group (tenant_id, product_type_id, code, name, display_order)
SELECT current_setting('app.current_tenant', true), id, 'barber_info', 'Thông tin dịch vụ', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'cut_style', 'Kiểu cắt (Fade/Undercut/Classic/Buzz)', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'barber_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'includes_beard', 'Bao gồm râu (Có/Không)', 'STRING', FALSE, FALSE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'barber_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'skill_level', 'Cấp bậc thợ (Thợ phụ/Thợ chính/Master)', 'STRING', FALSE, FALSE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'barber_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
