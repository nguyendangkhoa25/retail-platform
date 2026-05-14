-- ============================================================
-- TENANT SEED — DEFAULT DATA: TIỆM TRANG ĐIỂM / STUDIO CÔ DÂU (MAKEUP & BRIDAL STUDIO)
-- PostgreSQL / shared-DB version.
-- All INSERTs are idempotent (ON CONFLICT DO NOTHING or DO UPDATE).
-- tenant_id sourced from app.current_tenant session variable.
-- ============================================================

-- ── 1. Product types ─────────────────────────────────────────
INSERT INTO product_type (tenant_id, code, name, description) VALUES
    (current_setting('app.current_tenant', true), 'SERVICE',     'Dịch vụ',                    'Dịch vụ trang điểm / studio cô dâu'),
    (current_setting('app.current_tenant', true), 'BEAUTY',      'Làm đẹp / Chăm sóc cá nhân','Sản phẩm làm đẹp và vệ sinh cá nhân'),
    (current_setting('app.current_tenant', true), 'CLOTHING',    'Quần áo / May mặc',          'Quần áo và phụ kiện'),
    (current_setting('app.current_tenant', true), 'CONVENIENCE', 'Hàng tiêu dùng',             'Hàng tiêu dùng thiết yếu'),
    (current_setting('app.current_tenant', true), 'FOOD',        'Thực phẩm',                  'Thực phẩm và đồ ăn'),
    (current_setting('app.current_tenant', true), 'BEVERAGE',    'Đồ uống',                    'Nước giải khát, bia, nước suối'),
    (current_setting('app.current_tenant', true), 'DRUG',        'Dược phẩm',                  'Thuốc và sản phẩm dược'),
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
    (current_setting('app.current_tenant', true), 'Trang điểm ngày thường',  NULL),
    (current_setting('app.current_tenant', true), 'Trang điểm đi tiệc',     NULL),
    (current_setting('app.current_tenant', true), 'Trang điểm cô dâu',      NULL),
    (current_setting('app.current_tenant', true), 'Làm tóc & Phụ kiện',     NULL),
    (current_setting('app.current_tenant', true), 'Combo & Gói cưới',       NULL);

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
    -- Trang điểm ngày thường
    ('MK-001', 'Trang điểm nhẹ nhàng hàng ngày',   'Makeup tự nhiên phù hợp đi làm, đi học',         200000, 45),
    ('MK-002', 'Trang điểm Hàn Quốc (K-makeup)',   'Phong cách trang điểm tươi sáng kiểu Hàn',       300000, 60),
    ('MK-003', 'Trang điểm retouching (chỉnh sửa)','Chỉnh sửa makeup nhẹ đã có sẵn',                  100000, 20),
    -- Trang điểm đi tiệc
    ('MK-004', 'Trang điểm đi tiệc ban ngày',       'Makeup rạng rỡ phù hợp tiệc ban ngày',           400000, 60),
    ('MK-005', 'Trang điểm dự tiệc tối / event',   'Makeup đậm hơn, sang trọng cho tiệc tối',         500000, 75),
    ('MK-006', 'Trang điểm chụp ảnh',              'Makeup chuyên biệt dưới ánh đèn flash',            500000, 60),
    ('MK-007', 'Trang điểm tốt nghiệp',            'Makeup trẻ trung cho lễ tốt nghiệp',               350000, 60),
    ('MK-008', 'Trang điểm Halloween / cosplay',   'Makeup nghệ thuật theo chủ đề đặc biệt',           600000, 90),
    -- Trang điểm cô dâu
    ('MK-009', 'Trang điểm cô dâu thử (trial)',    'Thử nghiệm makeup trước ngày cưới',                500000, 90),
    ('MK-010', 'Trang điểm cô dâu ngày cưới',      'Makeup cô dâu chính thức ngày cưới',             1500000, 120),
    ('MK-011', 'Trang điểm cô dâu cao cấp',        'Makeup cô dâu toàn diện với airbrush',           2500000, 150),
    ('MK-012', 'Trang điểm phụ dâu / phù rể',     'Makeup cho phụ dâu hoặc phù rể',                  500000, 60),
    ('MK-013', 'Trang điểm mẹ cô dâu / chú rể',   'Makeup trang trọng cho phụ huynh ngày cưới',      600000, 75),
    -- Làm tóc & Phụ kiện
    ('MK-014', 'Búi tóc đơn giản',                'Búi tóc gọn đẹp cho ngày thường',                  150000, 30),
    ('MK-015', 'Tạo kiểu tóc đi tiệc',            'Tạo kiểu tóc phức tạp cho sự kiện',               300000, 45),
    ('MK-016', 'Tạo kiểu tóc cô dâu',             'Tạo kiểu tóc cô dâu kết hợp phụ kiện',            800000, 90),
    ('MK-017', 'Đặt vương miện / phụ kiện tóc',   'Gắn vương miện, hoa, cài tóc cưới',               200000, 20),
    -- Combo & Gói cưới
    ('MK-018', 'Combo Trang điểm + Tóc (tiệc)',   'Trang điểm tiệc + tạo kiểu tóc',                  700000, 120),
    ('MK-019', 'Gói cưới cô dâu cơ bản',          'Thử makeup + makeup ngày cưới + tóc cô dâu',     2500000, 360),
    ('MK-020', 'Gói cưới cô dâu cao cấp',         'Airbrush makeup + tóc + phụ dâu (2 người)',       4500000, 480)
) AS p(sku, name, description, price, dur)
JOIN product_type pt ON pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (sku, tenant_id) DO NOTHING;

-- ── 4. Product-category assignments ──────────────────────────
INSERT INTO product_category (product_id, category_id)
SELECT p.id, c.id
FROM (VALUES
    ('MK-001', 'Trang điểm ngày thường'),
    ('MK-002', 'Trang điểm ngày thường'),
    ('MK-003', 'Trang điểm ngày thường'),
    ('MK-004', 'Trang điểm đi tiệc'),
    ('MK-005', 'Trang điểm đi tiệc'),
    ('MK-006', 'Trang điểm đi tiệc'),
    ('MK-007', 'Trang điểm đi tiệc'),
    ('MK-008', 'Trang điểm đi tiệc'),
    ('MK-009', 'Trang điểm cô dâu'),
    ('MK-010', 'Trang điểm cô dâu'),
    ('MK-011', 'Trang điểm cô dâu'),
    ('MK-012', 'Trang điểm cô dâu'),
    ('MK-013', 'Trang điểm cô dâu'),
    ('MK-014', 'Làm tóc & Phụ kiện'),
    ('MK-015', 'Làm tóc & Phụ kiện'),
    ('MK-016', 'Làm tóc & Phụ kiện'),
    ('MK-017', 'Làm tóc & Phụ kiện'),
    ('MK-018', 'Combo & Gói cưới'),
    ('MK-019', 'Combo & Gói cưới'),
    ('MK-020', 'Combo & Gói cưới')
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
  AND p.sku LIKE 'MK-%'
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
    (current_setting('app.current_tenant', true), 'Kim cương', 80000000,  2.00, '#00BCD4', 'Chi tiêu từ 80 triệu VND',      4);

-- ── 8. Print template ─────────────────────────────────────────
INSERT INTO print_templates (tenant_id, template_type, name, config_json, is_default) VALUES
    (current_setting('app.current_tenant', true), 'POS_RECEIPT', 'Mặc định', '{
  "headerText": "",
  "footerText": "Cảm ơn quý khách!\nChúc cô dâu thật xinh đẹp và hạnh phúc!",
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
SELECT current_setting('app.current_tenant', true), id, 'makeup_info', 'Thông tin dịch vụ', 1
FROM product_type WHERE code = 'SERVICE' AND tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (product_type_id, code) DO UPDATE SET display_order = EXCLUDED.display_order;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'occasion', 'Dịp sử dụng (Ngày thường/Tiệc/Cô dâu/Sự kiện)', 'STRING', FALSE, TRUE, TRUE, 1
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'makeup_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'makeup_style', 'Phong cách (Tự nhiên/Glamour/Hàn Quốc/Cổ điển)', 'STRING', FALSE, TRUE, TRUE, 2
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'makeup_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO attribute_definition
    (tenant_id, product_type_id, attribute_group_id, code, name, data_type,
     required, searchable, filterable, display_order)
SELECT current_setting('app.current_tenant', true), pt.id, ag.id,
    'includes_hair', 'Bao gồm làm tóc (Có/Không)', 'STRING', FALSE, FALSE, TRUE, 3
FROM product_type pt
JOIN attribute_group ag ON ag.product_type_id = pt.id AND ag.code = 'makeup_info'
WHERE pt.code = 'SERVICE' AND pt.tenant_id = current_setting('app.current_tenant', true)
ON CONFLICT (code, product_type_id) DO UPDATE SET name = EXCLUDED.name;

-- ── 10. Shop configuration ────────────────────────────────────
INSERT INTO shop_config (tenant_id, config_key, config_value, config_group, encrypted) VALUES
    (current_setting('app.current_tenant', true), 'cash_denominations', '1000,2000,5000,10000,20000,50000,100000,200000,500000', 'POS', FALSE)
ON CONFLICT (config_key, tenant_id) DO NOTHING;
