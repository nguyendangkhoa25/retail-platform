-- ============================================================
-- V003: Add category_name to product_suggestions and backfill
--       BARBER_SHOP rows. Add NAIL_SHOP and SPA_SHOP rows.
-- ============================================================

ALTER TABLE product_suggestions
    ADD COLUMN IF NOT EXISTS category_name VARCHAR(200) DEFAULT NULL;

-- ── Backfill existing BARBER_SHOP suggestions ─────────────────
-- Category names must match exactly what barber_shop.sql inserts
-- into the `category` table for each tenant.
UPDATE product_suggestions SET category_name = 'Cắt tóc nam'        WHERE name = 'Cắt tóc nam';
UPDATE product_suggestions SET category_name = 'Cắt tóc nữ'         WHERE name = 'Cắt tóc nữ';
UPDATE product_suggestions SET category_name = 'Cắt tóc nam'        WHERE name = 'Cắt tóc trẻ em';
UPDATE product_suggestions SET category_name = 'Nhuộm & Uốn'        WHERE name = 'Nhuộm tóc';
UPDATE product_suggestions SET category_name = 'Nhuộm & Uốn'        WHERE name = 'Uốn tóc';
UPDATE product_suggestions SET category_name = 'Nhuộm & Uốn'        WHERE name = 'Duỗi tóc';
UPDATE product_suggestions SET category_name = 'Gội đầu & Massage'  WHERE name = 'Gội đầu';
UPDATE product_suggestions SET category_name = 'Chăm sóc râu'       WHERE name = 'Cạo râu';
UPDATE product_suggestions SET category_name = 'Gội đầu & Massage'  WHERE name = 'Massage đầu';
UPDATE product_suggestions SET category_name = 'Gội đầu & Massage'  WHERE name = 'Phục hồi tóc';
UPDATE product_suggestions SET category_name = 'Tạo kiểu & Combo'   WHERE name = 'Tạo kiểu tóc';

-- ── NAIL_SHOP suggestions ─────────────────────────────────────
INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Sơn màu thường (tay)',    '💅', 80000,   'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 200, 'Sơn móng thường'),
('Sơn màu thường (chân)',   '💅', 70000,   'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 201, 'Sơn móng thường'),
('Sơn French',             '💅', 100000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 202, 'Sơn móng thường'),
('Sơn gel (tay)',          '💅', 150000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 210, 'Gel & Acrylic'),
('Sơn gel (chân)',         '💅', 120000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 211, 'Gel & Acrylic'),
('Đắp bột acrylic',       '💅', 300000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 212, 'Gel & Acrylic'),
('Đắp gel builder',       '💅', 280000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 213, 'Gel & Acrylic'),
('Tháo gel / Tháo bột',   '💅', 80000,   'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 214, 'Gel & Acrylic'),
('Vẽ nail',               '🎨', 200000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 220, 'Vẽ nail & Nghệ thuật'),
('Nail art',              '🎨', 300000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 221, 'Vẽ nail & Nghệ thuật'),
('Đính đá nail',          '💎', 150000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 222, 'Vẽ nail & Nghệ thuật'),
('Nail ombre',            '🎨', 250000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 223, 'Vẽ nail & Nghệ thuật'),
('Manicure',              '✋', 100000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 230, 'Chăm sóc bàn tay'),
('Dưỡng ẩm tay',         '🧴', 80000,   'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 231, 'Chăm sóc bàn tay'),
('Pedicure',              '🦶', 130000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 240, 'Chăm sóc bàn chân'),
('Tẩy da chết chân',     '🦶', 100000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 241, 'Chăm sóc bàn chân'),
('Combo tay + chân',     '💅', 130000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 250, 'Combo & Gói dịch vụ'),
('Combo gel tay + chân', '💅', 250000,  'Lần',   'SERVICE', FALSE, ARRAY['NAIL_SHOP'], 251, 'Combo & Gói dịch vụ')
ON CONFLICT (name) DO NOTHING;

-- ── SPA_SHOP suggestions ──────────────────────────────────────
INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Massage thư giãn 60p',   '💆', 350000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 300, 'Massage'),
('Massage thư giãn 90p',   '💆', 500000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 301, 'Massage'),
('Massage đầu & cổ',      '💆', 200000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 302, 'Massage'),
('Massage bàn chân',      '🦶', 200000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 303, 'Massage'),
('Massage đá nóng',       '🪨', 600000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 304, 'Massage'),
('Massage tinh dầu',      '🌿', 450000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 305, 'Massage'),
('Chăm sóc da mặt cơ bản','✨', 250000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 310, 'Chăm sóc da mặt'),
('Chăm sóc da mặt chuyên sâu','✨', 400000, 'Lần', 'SERVICE', FALSE, ARRAY['SPA_SHOP'], 311, 'Chăm sóc da mặt'),
('Nặn mụn',              '🫧', 300000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 312, 'Chăm sóc da mặt'),
('Đắp mặt nạ dưỡng ẩm',  '🎭', 150000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 313, 'Chăm sóc da mặt'),
('Tẩy tế bào chết toàn thân','🧖', 300000,'Lần',  'SERVICE', FALSE, ARRAY['SPA_SHOP'], 320, 'Chăm sóc cơ thể'),
('Ủ trắng toàn thân',    '🧖', 400000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 321, 'Chăm sóc cơ thể'),
('Wax lông nách',        '✂️', 80000,   'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 330, 'Waxing & Triệt lông'),
('Wax lông chân',        '✂️', 200000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 331, 'Waxing & Triệt lông'),
('Wax bikini',           '✂️', 200000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 332, 'Waxing & Triệt lông'),
('Trị nám, tàn nhang',   '✨', 500000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 340, 'Điều trị đặc biệt'),
('Trị mụn lưng',        '🫧', 350000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 341, 'Điều trị đặc biệt'),
('Combo mặt + massage',  '💆', 600000,  'Lần',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 350, 'Combo & Liệu trình'),
('Liệu trình 5 buổi',   '📋', 1800000, 'Gói',   'SERVICE', FALSE, ARRAY['SPA_SHOP'], 351, 'Combo & Liệu trình')
ON CONFLICT (name) DO NOTHING;

-- ── NAIL_SHOP expense suggestions ─────────────────────────────
INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Sơn / gel / bột nail',            '💅', 'SUPPLIES',    '{NAIL_SHOP}', 1),
  ('Đèn UV / máy khoan nail',         '🔧', 'EQUIPMENT',   '{NAIL_SHOP}', 2),
  ('Khăn / bông tẩy trang / phụ kiện','🧴', 'CLEANING',    '{NAIL_SHOP}', 3)
ON CONFLICT (name) DO NOTHING;

-- ── SPA_SHOP expense suggestions ──────────────────────────────
INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Dầu massage / tinh dầu aromatherapy','🌿', 'SUPPLIES',   '{SPA_SHOP}', 1),
  ('Kem dưỡng / mặt nạ / vật tư spa',   '🧴', 'SUPPLIES',   '{SPA_SHOP}', 2),
  ('Khăn / đồ vải spa',                 '🛁', 'CLEANING',   '{SPA_SHOP}', 3),
  ('Máy massage / thiết bị spa',        '🔧', 'EQUIPMENT',  '{SPA_SHOP}', 4)
ON CONFLICT (name) DO NOTHING;
