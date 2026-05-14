-- ============================================================
-- V007: Product & expense suggestions for the 6 new beauty
--       shop types added in the ShopType enum expansion.
--
-- Types: BARBER_SHOP_MEN, HAIR_SALON, LASH_PMU_STUDIO,
--        MASSAGE_SHOP, BEAUTY_CLINIC, MAKEUP_STUDIO
--
-- category_name values MUST match exactly the names inserted
-- by each type's DML seed file (db/tenant/<type>.sql).
-- display_order starts at 400 to avoid clashing with prior
-- entries (V001 max ~191, V003 max 351).
-- ============================================================

-- ── BARBER_SHOP_MEN product suggestions ──────────────────────
-- Categories: Cắt tóc | Cạo & Chăm sóc râu | Gội đầu & Massage | Tạo kiểu | Combo

INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Cắt tóc thường (nam)',        '💇', 80000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 400, 'Cắt tóc'),
('Cắt Fade',                    '💇', 150000,  'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 401, 'Cắt tóc'),
('Cắt Undercut',                '💇', 150000,  'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 402, 'Cắt tóc'),
('Cắt tóc trẻ em (nam)',        '👦', 60000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 403, 'Cắt tóc'),
('Cạo râu thường',              '🪒', 50000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 410, 'Cạo & Chăm sóc râu'),
('Cạo râu + định hình râu',     '🪒', 80000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 411, 'Cạo & Chăm sóc râu'),
('Trim & tỉa râu',              '🪒', 40000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 412, 'Cạo & Chăm sóc râu'),
('Gội đầu + massage đầu (nam)', '💆', 80000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 420, 'Gội đầu & Massage'),
('Massage đầu cổ vai 20p',      '💆', 100000,  'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 421, 'Gội đầu & Massage'),
('Tạo kiểu sáp / wax tóc',     '✨', 50000,   'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 430, 'Tạo kiểu'),
('Nhuộm tóc nam',               '💈', 200000,  'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 431, 'Tạo kiểu'),
('Combo cắt + cạo râu',         '💈', 180000,  'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 440, 'Combo'),
('Combo cắt + gội + massage đầu','💈', 200000, 'Lần', 'SERVICE', FALSE, ARRAY['BARBER_SHOP_MEN'], 441, 'Combo')
ON CONFLICT (name) DO NOTHING;

-- ── HAIR_SALON product suggestions ───────────────────────────
-- Categories: Cắt tóc | Nhuộm tóc | Uốn & Duỗi | Chăm sóc tóc | Gội đầu & Massage | Tạo kiểu & Combo

INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Cắt tóc nữ ngắn',              '✂️', 120000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 450, 'Cắt tóc'),
('Cắt tóc nữ dài',               '✂️', 150000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 451, 'Cắt tóc'),
('Cắt tỉa layer',                '✂️', 130000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 452, 'Cắt tóc'),
('Nhuộm màu thời trang',         '🎨', 400000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 460, 'Nhuộm tóc'),
('Nhuộm highlight / ombre',      '🎨', 600000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 461, 'Nhuộm tóc'),
('Nhuộm phủ bạc',                '🎨', 300000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 462, 'Nhuộm tóc'),
('Uốn xoăn Hàn Quốc',           '💫', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 470, 'Uốn & Duỗi'),
('Duỗi phồng / duỗi thẳng',     '💫', 600000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 471, 'Uốn & Duỗi'),
('Ép tóc Keratin',               '💫', 700000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 472, 'Uốn & Duỗi'),
('Ủ phục hồi tóc hư tổn',       '🌿', 200000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 480, 'Chăm sóc tóc'),
('Gội đầu dưỡng + massage đầu', '💆', 100000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 490, 'Gội đầu & Massage'),
('Tạo kiểu đi tiệc / sự kiện',  '✨', 300000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 500, 'Tạo kiểu & Combo'),
('Combo cắt + nhuộm tóc',       '💈', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['HAIR_SALON'], 501, 'Tạo kiểu & Combo')
ON CONFLICT (name) DO NOTHING;

-- ── LASH_PMU_STUDIO product suggestions ──────────────────────
-- Categories: Nối mi | Xăm mày | Xăm môi | Xăm mí mắt | Chăm sóc & Tháo | Combo

INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Nối mi cơ bản',               '👁', 200000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 510, 'Nối mi'),
('Nối mi volume',               '👁', 350000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 511, 'Nối mi'),
('Nối mi mega volume',          '👁', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 512, 'Nối mi'),
('Xăm mày tán bột / ombre',    '✏', 2000000, 'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 520, 'Xăm mày'),
('Xăm mày giả lông',           '✏', 2500000, 'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 521, 'Xăm mày'),
('Xăm môi bóng / ombre',       '💋', 3000000, 'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 530, 'Xăm môi'),
('Xăm mí mắt trên',            '👁', 1500000, 'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 540, 'Xăm mí mắt'),
('Tháo mi',                    '✂', 100000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 550, 'Chăm sóc & Tháo'),
('Điều chỉnh / fill mi',       '👁', 150000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 551, 'Chăm sóc & Tháo'),
('Dưỡng phục hồi sau xăm',     '🌿', 200000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 552, 'Chăm sóc & Tháo'),
('Combo nối mi + fill mi',     '✨', 450000,  'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 560, 'Combo'),
('Combo mày + môi trọn gói',   '✨', 5000000, 'Lần', 'SERVICE', FALSE, ARRAY['LASH_PMU_STUDIO'], 561, 'Combo')
ON CONFLICT (name) DO NOTHING;

-- ── MASSAGE_SHOP product suggestions ─────────────────────────
-- Categories: Massage toàn thân | Massage chân phản xạ | Massage đầu & vai gáy |
--             Massage lưng & cổ | Xông hơi & Ngâm | Combo

INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Massage thư giãn toàn thân 60p', '💆', 200000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 570, 'Massage toàn thân'),
('Massage toàn thân 90p',          '💆', 280000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 571, 'Massage toàn thân'),
('Massage toàn thân 120p',         '💆', 350000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 572, 'Massage toàn thân'),
('Massage chân phản xạ 30p',       '🦶', 100000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 580, 'Massage chân phản xạ'),
('Massage chân phản xạ 60p',       '🦶', 180000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 581, 'Massage chân phản xạ'),
('Massage đầu vai gáy 30p',        '💆', 100000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 590, 'Massage đầu & vai gáy'),
('Massage lưng & cổ 30p',          '💆', 150000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 600, 'Massage lưng & cổ'),
('Xông hơi ướt',                   '🌊', 100000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 610, 'Xông hơi & Ngâm'),
('Ngâm chân thảo dược',            '🌿', 80000,  'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 611, 'Xông hơi & Ngâm'),
('Combo massage + ngâm chân',      '✨', 250000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 620, 'Combo'),
('Combo toàn thân + xông hơi',     '✨', 400000, 'Lần', 'SERVICE', FALSE, ARRAY['MASSAGE_SHOP'], 621, 'Combo')
ON CONFLICT (name) DO NOTHING;

-- ── BEAUTY_CLINIC product suggestions ────────────────────────
-- Categories: Chăm sóc da mặt | Trị mụn & Nám | Công nghệ thẩm mỹ |
--             Điều trị cơ thể | Waxing & Triệt lông | Combo & Liệu trình
--
-- Several facial/body services overlap with SPA_SHOP suggestions
-- already in V003.  Append BEAUTY_CLINIC to those rows so they
-- surface during beauty-clinic onboarding without name conflicts.

UPDATE product_suggestions
SET shop_types = array_append(shop_types, 'BEAUTY_CLINIC')
WHERE name IN (
    'Chăm sóc da mặt cơ bản',
    'Chăm sóc da mặt chuyên sâu',
    'Đắp mặt nạ dưỡng ẩm',
    'Tẩy tế bào chết toàn thân',
    'Ủ trắng toàn thân',
    'Wax lông nách',
    'Wax lông chân',
    'Trị nám, tàn nhang'
)
  AND NOT ('BEAUTY_CLINIC' = ANY(shop_types));

-- Clinic-specific additions (procedures not offered at generic spas)
INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Nặn mụn an toàn tại thẩm mỹ viện', '🫧', 300000,  'Lần', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 630, 'Trị mụn & Nám'),
('Trị mụn bằng laser',               '💡', 600000,  'Lần', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 631, 'Trị mụn & Nám'),
('Laser trẻ hóa da',                 '💡', 1200000, 'Lần', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 640, 'Công nghệ thẩm mỹ'),
('RF nâng cơ / căng da',             '⚡', 1500000, 'Lần', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 641, 'Công nghệ thẩm mỹ'),
('HIFU nâng cơ không phẫu thuật',    '💡', 2000000, 'Lần', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 642, 'Công nghệ thẩm mỹ'),
('Triệt lông laser (1 vùng)',        '💡', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 650, 'Waxing & Triệt lông'),
('Combo liệu trình da 5 buổi',       '📋', 1500000, 'Gói', 'SERVICE', FALSE, ARRAY['BEAUTY_CLINIC'], 660, 'Combo & Liệu trình')
ON CONFLICT (name) DO NOTHING;

-- ── MAKEUP_STUDIO product suggestions ────────────────────────
-- Categories: Trang điểm ngày thường | Trang điểm đi tiệc | Trang điểm cô dâu |
--             Làm tóc & Phụ kiện | Combo & Gói cưới

INSERT INTO product_suggestions
    (name, emoji, default_price, unit, product_type_code, dynamic_price, shop_types, display_order, category_name)
VALUES
('Trang điểm nhẹ nhàng hàng ngày', '💄', 200000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 670, 'Trang điểm ngày thường'),
('Trang điểm Hàn Quốc (K-makeup)', '💄', 300000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 671, 'Trang điểm ngày thường'),
('Trang điểm đi tiệc ban ngày',    '💄', 400000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 680, 'Trang điểm đi tiệc'),
('Trang điểm dự tiệc tối / event', '💄', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 681, 'Trang điểm đi tiệc'),
('Trang điểm tốt nghiệp',          '🎓', 350000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 682, 'Trang điểm đi tiệc'),
('Trang điểm chụp ảnh',            '📸', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 683, 'Trang điểm đi tiệc'),
('Trang điểm cô dâu thử (trial)',  '👰', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 690, 'Trang điểm cô dâu'),
('Trang điểm cô dâu ngày cưới',   '👰', 1500000, 'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 691, 'Trang điểm cô dâu'),
('Trang điểm phụ dâu / phù rể',   '💍', 500000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 692, 'Trang điểm cô dâu'),
('Búi tóc đơn giản',               '💇', 150000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 700, 'Làm tóc & Phụ kiện'),
('Tạo kiểu tóc đi tiệc / sự kiện','✨', 300000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 701, 'Làm tóc & Phụ kiện'),
('Combo trang điểm + tóc tiệc',   '✨', 700000,  'Lần', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 710, 'Combo & Gói cưới'),
('Gói cưới cô dâu cơ bản',        '👰', 2500000, 'Gói', 'SERVICE', FALSE, ARRAY['MAKEUP_STUDIO'], 711, 'Combo & Gói cưới')
ON CONFLICT (name) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════
-- Expense suggestions for new beauty shop types
-- display_order values are local to each INSERT batch
-- ═══════════════════════════════════════════════════════════════

-- ─── BARBER_SHOP_MEN ────────────────────────────────────────────

INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Vật tư cắt tóc (tông đơ, dao, kéo)',  '💈', 'SUPPLIES',    '{BARBER_SHOP_MEN}', 1),
  ('Dầu cạo râu / kem cạo râu',           '🪒', 'SUPPLIES',    '{BARBER_SHOP_MEN}', 2),
  ('Khăn bông / khăn lạnh phục vụ',       '🧴', 'CLEANING',    '{BARBER_SHOP_MEN}', 3),
  ('Bảo trì ghế cắt / thiết bị salon',   '💺', 'MAINTENANCE', '{BARBER_SHOP_MEN}', 4)
ON CONFLICT (name) DO NOTHING;

-- ─── HAIR_SALON ─────────────────────────────────────────────────

INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Thuốc nhuộm / thuốc uốn / hóa chất tóc', '🎨', 'SUPPLIES',    '{HAIR_SALON}', 1),
  ('Dầu gội / dầu xả chuyên nghiệp',          '🧴', 'SUPPLIES',    '{HAIR_SALON}', 2),
  ('Khăn bông / áo choàng khách',             '🧺', 'CLEANING',    '{HAIR_SALON}', 3),
  ('Bảo trì máy sấy / máy uốn / máy duỗi',   '🔧', 'MAINTENANCE', '{HAIR_SALON}', 4)
ON CONFLICT (name) DO NOTHING;

-- ─── LASH_PMU_STUDIO ────────────────────────────────────────────

INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Chỉ mi / keo mi / dung môi tháo keo',  '👁', 'SUPPLIES',    '{LASH_PMU_STUDIO}', 1),
  ('Mực xăm / kim xăm tiêu hao',           '✏', 'SUPPLIES',    '{LASH_PMU_STUDIO}', 2),
  ('Khăn vô trùng / vật tư tiệt khuẩn',   '🧤', 'CLEANING',    '{LASH_PMU_STUDIO}', 3),
  ('Bảo trì giường / ghế kỹ thuật viên',  '🛋', 'MAINTENANCE', '{LASH_PMU_STUDIO}', 4)
ON CONFLICT (name) DO NOTHING;

-- ─── MASSAGE_SHOP ───────────────────────────────────────────────

INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Tinh dầu / dầu massage chuyên dụng',  '🌿', 'SUPPLIES',    '{MASSAGE_SHOP}', 1),
  ('Khăn bông / đồ vải massage',          '🛁', 'CLEANING',    '{MASSAGE_SHOP}', 2),
  ('Bảo trì giường massage',              '🛏', 'MAINTENANCE', '{MASSAGE_SHOP}', 3),
  ('Đá bazan / thiết bị nhiệt massage',   '🪨', 'EQUIPMENT',   '{MASSAGE_SHOP}', 4)
ON CONFLICT (name) DO NOTHING;

-- ─── BEAUTY_CLINIC ──────────────────────────────────────────────

INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Hóa chất / serum / ampoule điều trị', '🧪', 'SUPPLIES',    '{BEAUTY_CLINIC}', 1),
  ('Kim vi kim / đầu mũi khoan tiêu hao', '💉', 'SUPPLIES',    '{BEAUTY_CLINIC}', 2),
  ('Khăn vô trùng / vật tư y tế 1 lần',  '🧤', 'CLEANING',    '{BEAUTY_CLINIC}', 3),
  ('Bảo trì thiết bị laser / RF / HIFU',  '🔧', 'MAINTENANCE', '{BEAUTY_CLINIC}', 4),
  ('Phí kiểm định thiết bị thẩm mỹ',     '📋', 'TAX',         '{BEAUTY_CLINIC}', 5)
ON CONFLICT (name) DO NOTHING;

-- ─── MAKEUP_STUDIO ──────────────────────────────────────────────

INSERT INTO expense_suggestions (name, emoji, category_code, shop_types, display_order) VALUES
  ('Mỹ phẩm / son / phấn / kem nền',    '💄', 'SUPPLIES',  '{MAKEUP_STUDIO}', 1),
  ('Cọ makeup / dụng cụ trang điểm',   '🖌', 'SUPPLIES',  '{MAKEUP_STUDIO}', 2),
  ('Đèn ring light / ghế trang điểm',  '💡', 'EQUIPMENT', '{MAKEUP_STUDIO}', 3),
  ('Áo choàng / khăn phục vụ khách',   '🧺', 'CLEANING',  '{MAKEUP_STUDIO}', 4)
ON CONFLICT (name) DO NOTHING;
