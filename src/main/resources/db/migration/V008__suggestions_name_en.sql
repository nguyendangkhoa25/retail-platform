-- ============================================================
-- V008: Add name_en (English translation) to product_suggestions
--       and expense_suggestions.
--       API returns both name (VI) and nameEn (EN) so the mobile
--       app can display suggestions in the user's preferred language.
-- ============================================================

ALTER TABLE product_suggestions
    ADD COLUMN IF NOT EXISTS name_en VARCHAR(200) DEFAULT NULL;

ALTER TABLE expense_suggestions
    ADD COLUMN IF NOT EXISTS name_en VARCHAR(200) DEFAULT NULL;

-- ── product_suggestions: English translations ─────────────────
-- Shared beverages
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Nước suối'               THEN 'Mineral Water'
    WHEN 'Coca Cola'               THEN 'Coca Cola'
    WHEN 'Pepsi'                   THEN 'Pepsi'
    WHEN 'Bia Saigon'              THEN 'Saigon Beer'
    WHEN 'Bia Tiger'               THEN 'Tiger Beer'
    WHEN 'Trứng gà'                THEN 'Eggs'
    WHEN 'Bánh mì'                 THEN 'Bread'
    ELSE name_en END
WHERE name IN ('Nước suối','Coca Cola','Pepsi','Bia Saigon','Bia Tiger','Trứng gà','Bánh mì');

-- CONVENIENCE_STORE
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Mì tôm Hảo Hảo'         THEN 'Instant Noodles'
    WHEN 'Sữa tươi Vinamilk'       THEN 'Fresh Milk'
    WHEN 'Dầu ăn'                  THEN 'Cooking Oil'
    WHEN 'Gạo'                     THEN 'Rice'
    WHEN 'Nước mắm'                THEN 'Fish Sauce'
    WHEN 'Đường cát'               THEN 'Sugar'
    WHEN 'Bột giặt'                THEN 'Laundry Detergent'
    WHEN 'Dầu gội đầu'             THEN 'Shampoo'
    WHEN 'Xà phòng'                THEN 'Soap'
    WHEN 'Khăn giấy'               THEN 'Tissue Paper'
    WHEN 'Thuốc lá'                THEN 'Cigarettes'
    WHEN 'Pin AA'                  THEN 'AA Batteries'
    WHEN 'Sạc điện thoại'          THEN 'Phone Charger'
    WHEN 'Cáp USB'                 THEN 'USB Cable'
    WHEN 'Nước tăng lực Redbull'   THEN 'Red Bull Energy Drink'
    WHEN 'Snack khoai tây'         THEN 'Potato Chips'
    WHEN 'Kẹo cao su'              THEN 'Chewing Gum'
    ELSE name_en END
WHERE name IN ('Mì tôm Hảo Hảo','Sữa tươi Vinamilk','Dầu ăn','Gạo','Nước mắm','Đường cát',
               'Bột giặt','Dầu gội đầu','Xà phòng','Khăn giấy','Thuốc lá','Pin AA',
               'Sạc điện thoại','Cáp USB','Nước tăng lực Redbull','Snack khoai tây','Kẹo cao su');

-- FOOD_BEVERAGE
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Rau cải xanh'            THEN 'Green Vegetables'
    WHEN 'Thịt heo'                THEN 'Pork'
    WHEN 'Thịt bò'                 THEN 'Beef'
    WHEN 'Cá tươi'                 THEN 'Fresh Fish'
    WHEN 'Đậu hũ'                  THEN 'Tofu'
    WHEN 'Cà chua'                 THEN 'Tomatoes'
    WHEN 'Hành tây'                THEN 'Onions'
    WHEN 'Tỏi'                     THEN 'Garlic'
    WHEN 'Cà rốt'                  THEN 'Carrots'
    WHEN 'Dầu hào'                 THEN 'Oyster Sauce'
    ELSE name_en END
WHERE name IN ('Rau cải xanh','Thịt heo','Thịt bò','Cá tươi','Đậu hũ',
               'Cà chua','Hành tây','Tỏi','Cà rốt','Dầu hào');

-- RESTAURANT
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Phở bò'                  THEN 'Beef Pho'
    WHEN 'Cơm tấm sườn'            THEN 'Broken Rice with Grilled Pork'
    WHEN 'Bún bò Huế'              THEN 'Hue Spicy Beef Noodle'
    WHEN 'Bánh mì thịt'            THEN 'Banh Mi Sandwich'
    WHEN 'Gỏi cuốn'                THEN 'Fresh Spring Rolls'
    WHEN 'Chả giò'                 THEN 'Fried Spring Rolls'
    WHEN 'Cơm chiên dương châu'    THEN 'Yang Chow Fried Rice'
    WHEN 'Lẩu thái hải sản'        THEN 'Thai Seafood Hot Pot'
    WHEN 'Bún riêu cua'            THEN 'Crab Noodle Soup'
    WHEN 'Hủ tiếu Nam Vang'        THEN 'Nam Vang Noodle Soup'
    ELSE name_en END
WHERE name IN ('Phở bò','Cơm tấm sườn','Bún bò Huế','Bánh mì thịt','Gỏi cuốn',
               'Chả giò','Cơm chiên dương châu','Lẩu thái hải sản','Bún riêu cua','Hủ tiếu Nam Vang');

-- COFFEE_SHOP
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Cà phê sữa đá'           THEN 'Iced Milk Coffee'
    WHEN 'Bạc xỉu'                 THEN 'Vietnamese White Coffee'
    WHEN 'Cà phê đen đá'           THEN 'Iced Black Coffee'
    WHEN 'Trà sữa trân châu'       THEN 'Bubble Tea'
    WHEN 'Americano'               THEN 'Americano'
    WHEN 'Latte'                   THEN 'Latte'
    WHEN 'Cappuccino'              THEN 'Cappuccino'
    WHEN 'Nước ép cam'             THEN 'Orange Juice'
    WHEN 'Sinh tố bơ'              THEN 'Avocado Smoothie'
    WHEN 'Nước ép dứa'             THEN 'Pineapple Juice'
    WHEN 'Bánh croissant'          THEN 'Croissant'
    WHEN 'Sandwich'                THEN 'Sandwich'
    WHEN 'Bánh tiramisu'           THEN 'Tiramisu Cake'
    ELSE name_en END
WHERE name IN ('Cà phê sữa đá','Bạc xỉu','Cà phê đen đá','Trà sữa trân châu','Americano',
               'Latte','Cappuccino','Nước ép cam','Sinh tố bơ','Nước ép dứa',
               'Bánh croissant','Sandwich','Bánh tiramisu');

-- FASHION
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Áo thun basic'           THEN 'Basic T-Shirt'
    WHEN 'Quần jean'               THEN 'Jeans'
    WHEN 'Áo sơ mi'                THEN 'Dress Shirt'
    WHEN 'Đầm nữ'                  THEN "Women's Dress"
    WHEN 'Áo khoác'                THEN 'Jacket'
    WHEN 'Quần short'              THEN 'Shorts'
    WHEN 'Áo dài'                  THEN 'Ao Dai (Traditional Dress)'
    WHEN 'Áo len'                  THEN 'Sweater'
    WHEN 'Giày sneaker'            THEN 'Sneakers'
    WHEN 'Dép lê'                  THEN 'Flip-flops'
    WHEN 'Túi xách'                THEN 'Handbag'
    WHEN 'Mũ lưỡi trai'           THEN 'Baseball Cap'
    WHEN 'Tất vớ'                  THEN 'Socks'
    WHEN 'Thắt lưng'               THEN 'Belt'
    WHEN 'Kính mắt thời trang'     THEN 'Fashion Sunglasses'
    ELSE name_en END
WHERE name IN ('Áo thun basic','Quần jean','Áo sơ mi','Đầm nữ','Áo khoác','Quần short',
               'Áo dài','Áo len','Giày sneaker','Dép lê','Túi xách','Mũ lưỡi trai',
               'Tất vớ','Thắt lưng','Kính mắt thời trang');

-- ELECTRONICS
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Điện thoại smartphone'   THEN 'Smartphone'
    WHEN 'Laptop'                  THEN 'Laptop'
    WHEN 'Máy tính bảng'           THEN 'Tablet'
    WHEN 'Tai nghe bluetooth'      THEN 'Bluetooth Headphones'
    WHEN 'Loa bluetooth'           THEN 'Bluetooth Speaker'
    WHEN 'Đồng hồ thông minh'      THEN 'Smartwatch'
    WHEN 'Pin sạc dự phòng'        THEN 'Power Bank'
    WHEN 'Ốp lưng điện thoại'      THEN 'Phone Case'
    WHEN 'Bàn phím không dây'      THEN 'Wireless Keyboard'
    WHEN 'Chuột máy tính'          THEN 'Computer Mouse'
    WHEN 'Màn hình máy tính'       THEN 'Computer Monitor'
    WHEN 'Camera giám sát'         THEN 'Security Camera'
    ELSE name_en END
WHERE name IN ('Điện thoại smartphone','Laptop','Máy tính bảng','Tai nghe bluetooth',
               'Loa bluetooth','Đồng hồ thông minh','Pin sạc dự phòng','Ốp lưng điện thoại',
               'Bàn phím không dây','Chuột máy tính','Màn hình máy tính','Camera giám sát');

-- BARBER_SHOP
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Cắt tóc nam'             THEN "Men's Haircut"
    WHEN 'Cắt tóc nữ'              THEN "Women's Haircut"
    WHEN 'Cắt tóc trẻ em'          THEN "Children's Haircut"
    WHEN 'Nhuộm tóc'               THEN 'Hair Coloring'
    WHEN 'Uốn tóc'                 THEN 'Hair Perm'
    WHEN 'Duỗi tóc'                THEN 'Hair Straightening'
    WHEN 'Gội đầu'                 THEN 'Hair Wash'
    WHEN 'Cạo râu'                 THEN 'Shave'
    WHEN 'Massage đầu'             THEN 'Head Massage'
    WHEN 'Phục hồi tóc'            THEN 'Hair Treatment'
    WHEN 'Tạo kiểu tóc'            THEN 'Hair Styling'
    ELSE name_en END
WHERE name IN ('Cắt tóc nam','Cắt tóc nữ','Cắt tóc trẻ em','Nhuộm tóc','Uốn tóc',
               'Duỗi tóc','Gội đầu','Cạo râu','Massage đầu','Phục hồi tóc','Tạo kiểu tóc');

-- PHARMACY
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Paracetamol 500mg'       THEN 'Paracetamol 500mg'
    WHEN 'Vitamin C 1000mg'        THEN 'Vitamin C 1000mg'
    WHEN 'Vitamin tổng hợp'        THEN 'Multivitamin'
    WHEN 'Khẩu trang y tế'         THEN 'Medical Face Mask'
    WHEN 'Nước muối sinh lý 0.9%'  THEN 'Saline Solution 0.9%'
    WHEN 'Thuốc ho bổ phế'         THEN 'Cough Medicine'
    WHEN 'Băng y tế'               THEN 'Medical Bandage'
    WHEN 'Băng dán vết thương'     THEN 'Adhesive Bandage'
    WHEN 'Dầu xoa nóng'            THEN 'Heating Rub'
    WHEN 'Dầu khuynh diệp'         THEN 'Eucalyptus Oil'
    WHEN 'Nhiệt kế điện tử'        THEN 'Digital Thermometer'
    WHEN 'Máy đo huyết áp'         THEN 'Blood Pressure Monitor'
    WHEN 'Bông y tế'               THEN 'Medical Cotton'
    WHEN 'Cồn y tế 90°'            THEN 'Rubbing Alcohol 90°'
    WHEN 'Thuốc nhỏ mắt'           THEN 'Eye Drops'
    ELSE name_en END
WHERE name IN ('Paracetamol 500mg','Vitamin C 1000mg','Vitamin tổng hợp','Khẩu trang y tế',
               'Nước muối sinh lý 0.9%','Thuốc ho bổ phế','Băng y tế','Băng dán vết thương',
               'Dầu xoa nóng','Dầu khuynh diệp','Nhiệt kế điện tử','Máy đo huyết áp',
               'Bông y tế','Cồn y tế 90°','Thuốc nhỏ mắt');

-- JEWELRY
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Nhẫn vàng 18K'           THEN '18K Gold Ring'
    WHEN 'Nhẫn vàng 24K'           THEN '24K Gold Ring'
    WHEN 'Nhẫn cưới vàng 18K'      THEN '18K Gold Wedding Ring'
    WHEN 'Dây chuyền vàng 18K'     THEN '18K Gold Necklace'
    WHEN 'Dây chuyền vàng 24K'     THEN '24K Gold Necklace'
    WHEN 'Lắc tay vàng 18K'        THEN '18K Gold Bracelet'
    WHEN 'Lắc chân vàng 18K'       THEN '18K Gold Anklet'
    WHEN 'Bông tai vàng 18K'       THEN '18K Gold Earrings'
    WHEN 'Mặt dây chuyền vàng'     THEN 'Gold Necklace Pendant'
    WHEN 'Nhẫn bạc'                THEN 'Silver Ring'
    WHEN 'Dây chuyền bạc'          THEN 'Silver Necklace'
    ELSE name_en END
WHERE name IN ('Nhẫn vàng 18K','Nhẫn vàng 24K','Nhẫn cưới vàng 18K','Dây chuyền vàng 18K',
               'Dây chuyền vàng 24K','Lắc tay vàng 18K','Lắc chân vàng 18K','Bông tai vàng 18K',
               'Mặt dây chuyền vàng','Nhẫn bạc','Dây chuyền bạc');

-- PAWN_SHOP
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Điện thoại (cầm)'        THEN 'Smartphone (Pawn)'
    WHEN 'Laptop (cầm)'            THEN 'Laptop (Pawn)'
    WHEN 'Máy tính bảng (cầm)'     THEN 'Tablet (Pawn)'
    WHEN 'Đồng hồ (cầm)'           THEN 'Watch (Pawn)'
    WHEN 'Trang sức vàng (cầm)'    THEN 'Gold Jewelry (Pawn)'
    WHEN 'Xe máy (cầm)'            THEN 'Motorbike (Pawn)'
    WHEN 'Camera / Máy ảnh (cầm)'  THEN 'Camera (Pawn)'
    WHEN 'Tivi (cầm)'              THEN 'Television (Pawn)'
    WHEN 'Đồ gia dụng (cầm)'       THEN 'Home Appliance (Pawn)'
    ELSE name_en END
WHERE name IN ('Điện thoại (cầm)','Laptop (cầm)','Máy tính bảng (cầm)','Đồng hồ (cầm)',
               'Trang sức vàng (cầm)','Xe máy (cầm)','Camera / Máy ảnh (cầm)',
               'Tivi (cầm)','Đồ gia dụng (cầm)');

-- OTHER
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Sản phẩm'                THEN 'Product'
    WHEN 'Dịch vụ'                 THEN 'Service'
    ELSE name_en END
WHERE name IN ('Sản phẩm','Dịch vụ');

-- NAIL_SHOP (V003)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Sơn màu thường (tay)'    THEN 'Regular Polish (Hands)'
    WHEN 'Sơn màu thường (chân)'   THEN 'Regular Polish (Feet)'
    WHEN 'Sơn French'              THEN 'French Polish'
    WHEN 'Sơn gel (tay)'           THEN 'Gel Polish (Hands)'
    WHEN 'Sơn gel (chân)'          THEN 'Gel Polish (Feet)'
    WHEN 'Đắp bột acrylic'         THEN 'Acrylic Extensions'
    WHEN 'Đắp gel builder'         THEN 'Gel Builder Extensions'
    WHEN 'Tháo gel / Tháo bột'     THEN 'Gel / Acrylic Removal'
    WHEN 'Vẽ nail'                 THEN 'Nail Art Design'
    WHEN 'Nail art'                THEN 'Nail Art'
    WHEN 'Đính đá nail'            THEN 'Nail Rhinestones'
    WHEN 'Nail ombre'              THEN 'Ombre Nails'
    WHEN 'Manicure'                THEN 'Manicure'
    WHEN 'Dưỡng ẩm tay'           THEN 'Hand Moisturiser Treatment'
    WHEN 'Pedicure'                THEN 'Pedicure'
    WHEN 'Tẩy da chết chân'        THEN 'Foot Exfoliation'
    WHEN 'Combo tay + chân'        THEN 'Hands + Feet Combo'
    WHEN 'Combo gel tay + chân'    THEN 'Gel Hands + Feet Combo'
    ELSE name_en END
WHERE name IN ('Sơn màu thường (tay)','Sơn màu thường (chân)','Sơn French','Sơn gel (tay)',
               'Sơn gel (chân)','Đắp bột acrylic','Đắp gel builder','Tháo gel / Tháo bột',
               'Vẽ nail','Nail art','Đính đá nail','Nail ombre','Manicure','Dưỡng ẩm tay',
               'Pedicure','Tẩy da chết chân','Combo tay + chân','Combo gel tay + chân');

-- SPA_SHOP (V003)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Massage thư giãn 60p'         THEN 'Relaxation Massage 60min'
    WHEN 'Massage thư giãn 90p'         THEN 'Relaxation Massage 90min'
    WHEN 'Massage đầu & cổ'             THEN 'Head & Neck Massage'
    WHEN 'Massage bàn chân'             THEN 'Foot Massage'
    WHEN 'Massage đá nóng'              THEN 'Hot Stone Massage'
    WHEN 'Massage tinh dầu'             THEN 'Aromatherapy Massage'
    WHEN 'Chăm sóc da mặt cơ bản'      THEN 'Basic Facial'
    WHEN 'Chăm sóc da mặt chuyên sâu'  THEN 'Advanced Facial'
    WHEN 'Nặn mụn'                      THEN 'Acne Extraction'
    WHEN 'Đắp mặt nạ dưỡng ẩm'         THEN 'Hydrating Face Mask'
    WHEN 'Tẩy tế bào chết toàn thân'   THEN 'Full Body Exfoliation'
    WHEN 'Ủ trắng toàn thân'           THEN 'Full Body Whitening Treatment'
    WHEN 'Wax lông nách'               THEN 'Underarm Waxing'
    WHEN 'Wax lông chân'               THEN 'Leg Waxing'
    WHEN 'Wax bikini'                  THEN 'Bikini Waxing'
    WHEN 'Trị nám, tàn nhang'          THEN 'Pigmentation & Freckle Treatment'
    WHEN 'Trị mụn lưng'                THEN 'Back Acne Treatment'
    WHEN 'Combo mặt + massage'         THEN 'Facial + Massage Combo'
    WHEN 'Liệu trình 5 buổi'           THEN '5-Session Treatment Package'
    ELSE name_en END
WHERE name IN ('Massage thư giãn 60p','Massage thư giãn 90p','Massage đầu & cổ','Massage bàn chân',
               'Massage đá nóng','Massage tinh dầu','Chăm sóc da mặt cơ bản','Chăm sóc da mặt chuyên sâu',
               'Nặn mụn','Đắp mặt nạ dưỡng ẩm','Tẩy tế bào chết toàn thân','Ủ trắng toàn thân',
               'Wax lông nách','Wax lông chân','Wax bikini','Trị nám, tàn nhang','Trị mụn lưng',
               'Combo mặt + massage','Liệu trình 5 buổi');

-- BARBER_SHOP_MEN (V007)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Cắt tóc thường (nam)'          THEN 'Regular Haircut (Men)'
    WHEN 'Cắt Fade'                       THEN 'Fade Haircut'
    WHEN 'Cắt Undercut'                   THEN 'Undercut'
    WHEN 'Cắt tóc trẻ em (nam)'           THEN "Boy's Haircut"
    WHEN 'Cạo râu thường'                 THEN 'Standard Shave'
    WHEN 'Cạo râu + định hình râu'        THEN 'Shave + Beard Shaping'
    WHEN 'Trim & tỉa râu'                 THEN 'Beard Trim & Tidy'
    WHEN 'Gội đầu + massage đầu (nam)'    THEN 'Hair Wash + Head Massage (Men)'
    WHEN 'Massage đầu cổ vai 20p'         THEN 'Head, Neck & Shoulder Massage 20min'
    WHEN 'Tạo kiểu sáp / wax tóc'         THEN 'Hair Wax Styling'
    WHEN 'Nhuộm tóc nam'                  THEN "Men's Hair Coloring"
    WHEN 'Combo cắt + cạo râu'            THEN 'Haircut + Shave Combo'
    WHEN 'Combo cắt + gội + massage đầu'  THEN 'Haircut + Wash + Head Massage Combo'
    ELSE name_en END
WHERE name IN ('Cắt tóc thường (nam)','Cắt Fade','Cắt Undercut','Cắt tóc trẻ em (nam)',
               'Cạo râu thường','Cạo râu + định hình râu','Trim & tỉa râu',
               'Gội đầu + massage đầu (nam)','Massage đầu cổ vai 20p','Tạo kiểu sáp / wax tóc',
               'Nhuộm tóc nam','Combo cắt + cạo râu','Combo cắt + gội + massage đầu');

-- HAIR_SALON (V007)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Cắt tóc nữ ngắn'               THEN "Women's Short Haircut"
    WHEN 'Cắt tóc nữ dài'                THEN "Women's Long Haircut"
    WHEN 'Cắt tỉa layer'                  THEN 'Layer Cut'
    WHEN 'Nhuộm màu thời trang'           THEN 'Fashion Hair Coloring'
    WHEN 'Nhuộm highlight / ombre'        THEN 'Highlight / Ombre Coloring'
    WHEN 'Nhuộm phủ bạc'                  THEN 'Grey Coverage Coloring'
    WHEN 'Uốn xoăn Hàn Quốc'             THEN 'Korean-style Perm'
    WHEN 'Duỗi phồng / duỗi thẳng'       THEN 'Volume / Straightening Treatment'
    WHEN 'Ép tóc Keratin'                 THEN 'Keratin Treatment'
    WHEN 'Ủ phục hồi tóc hư tổn'          THEN 'Damaged Hair Repair Mask'
    WHEN 'Gội đầu dưỡng + massage đầu'    THEN 'Nourishing Hair Wash + Head Massage'
    WHEN 'Tạo kiểu đi tiệc / sự kiện'    THEN 'Event / Party Hairstyling'
    WHEN 'Combo cắt + nhuộm tóc'          THEN 'Cut + Color Combo'
    ELSE name_en END
WHERE name IN ('Cắt tóc nữ ngắn','Cắt tóc nữ dài','Cắt tỉa layer','Nhuộm màu thời trang',
               'Nhuộm highlight / ombre','Nhuộm phủ bạc','Uốn xoăn Hàn Quốc',
               'Duỗi phồng / duỗi thẳng','Ép tóc Keratin','Ủ phục hồi tóc hư tổn',
               'Gội đầu dưỡng + massage đầu','Tạo kiểu đi tiệc / sự kiện','Combo cắt + nhuộm tóc');

-- LASH_PMU_STUDIO (V007)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Nối mi cơ bản'               THEN 'Classic Lash Extensions'
    WHEN 'Nối mi volume'               THEN 'Volume Lash Extensions'
    WHEN 'Nối mi mega volume'          THEN 'Mega Volume Lash Extensions'
    WHEN 'Xăm mày tán bột / ombre'    THEN 'Powder Brow / Ombre Tattoo'
    WHEN 'Xăm mày giả lông'           THEN 'Hair-stroke Brow Tattoo'
    WHEN 'Xăm môi bóng / ombre'       THEN 'Glossy / Ombre Lip Tattoo'
    WHEN 'Xăm mí mắt trên'            THEN 'Upper Eyeliner Tattoo'
    WHEN 'Tháo mi'                    THEN 'Lash Removal'
    WHEN 'Điều chỉnh / fill mi'       THEN 'Lash Fill / Adjustment'
    WHEN 'Dưỡng phục hồi sau xăm'     THEN 'Post-Tattoo Recovery Care'
    WHEN 'Combo nối mi + fill mi'     THEN 'Lash Extension + Fill Combo'
    WHEN 'Combo mày + môi trọn gói'   THEN 'Brow + Lip Package'
    ELSE name_en END
WHERE name IN ('Nối mi cơ bản','Nối mi volume','Nối mi mega volume','Xăm mày tán bột / ombre',
               'Xăm mày giả lông','Xăm môi bóng / ombre','Xăm mí mắt trên','Tháo mi',
               'Điều chỉnh / fill mi','Dưỡng phục hồi sau xăm','Combo nối mi + fill mi',
               'Combo mày + môi trọn gói');

-- MASSAGE_SHOP (V007)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Massage thư giãn toàn thân 60p' THEN 'Full Body Relaxation Massage 60min'
    WHEN 'Massage toàn thân 90p'           THEN 'Full Body Massage 90min'
    WHEN 'Massage toàn thân 120p'          THEN 'Full Body Massage 120min'
    WHEN 'Massage chân phản xạ 30p'        THEN 'Foot Reflexology 30min'
    WHEN 'Massage chân phản xạ 60p'        THEN 'Foot Reflexology 60min'
    WHEN 'Massage đầu vai gáy 30p'         THEN 'Head, Neck & Shoulder Massage 30min'
    WHEN 'Massage lưng & cổ 30p'           THEN 'Back & Neck Massage 30min'
    WHEN 'Xông hơi ướt'                   THEN 'Steam Bath'
    WHEN 'Ngâm chân thảo dược'            THEN 'Herbal Foot Soak'
    WHEN 'Combo massage + ngâm chân'      THEN 'Massage + Foot Soak Combo'
    WHEN 'Combo toàn thân + xông hơi'     THEN 'Full Body Massage + Steam Combo'
    ELSE name_en END
WHERE name IN ('Massage thư giãn toàn thân 60p','Massage toàn thân 90p','Massage toàn thân 120p',
               'Massage chân phản xạ 30p','Massage chân phản xạ 60p','Massage đầu vai gáy 30p',
               'Massage lưng & cổ 30p','Xông hơi ướt','Ngâm chân thảo dược',
               'Combo massage + ngâm chân','Combo toàn thân + xông hơi');

-- BEAUTY_CLINIC (V007)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Nặn mụn an toàn tại thẩm mỹ viện' THEN 'Professional Acne Extraction'
    WHEN 'Trị mụn bằng laser'                THEN 'Laser Acne Treatment'
    WHEN 'Laser trẻ hóa da'                  THEN 'Laser Skin Rejuvenation'
    WHEN 'RF nâng cơ / căng da'              THEN 'RF Skin Tightening / Lifting'
    WHEN 'HIFU nâng cơ không phẫu thuật'     THEN 'HIFU Non-surgical Facelift'
    WHEN 'Triệt lông laser (1 vùng)'         THEN 'Laser Hair Removal (1 area)'
    WHEN 'Combo liệu trình da 5 buổi'        THEN '5-Session Skin Treatment Package'
    ELSE name_en END
WHERE name IN ('Nặn mụn an toàn tại thẩm mỹ viện','Trị mụn bằng laser','Laser trẻ hóa da',
               'RF nâng cơ / căng da','HIFU nâng cơ không phẫu thuật',
               'Triệt lông laser (1 vùng)','Combo liệu trình da 5 buổi');

-- MAKEUP_STUDIO (V007)
UPDATE product_suggestions SET name_en = CASE name
    WHEN 'Trang điểm nhẹ nhàng hàng ngày' THEN 'Everyday Natural Makeup'
    WHEN 'Trang điểm Hàn Quốc (K-makeup)' THEN 'K-Beauty Makeup'
    WHEN 'Trang điểm đi tiệc ban ngày'    THEN 'Daytime Party Makeup'
    WHEN 'Trang điểm dự tiệc tối / event' THEN 'Evening / Event Makeup'
    WHEN 'Trang điểm tốt nghiệp'          THEN 'Graduation Makeup'
    WHEN 'Trang điểm chụp ảnh'            THEN 'Photo Shoot Makeup'
    WHEN 'Trang điểm cô dâu thử (trial)'  THEN 'Bridal Trial Makeup'
    WHEN 'Trang điểm cô dâu ngày cưới'   THEN 'Wedding Day Bridal Makeup'
    WHEN 'Trang điểm phụ dâu / phù rể'   THEN 'Bridesmaid / Groomsman Makeup'
    WHEN 'Búi tóc đơn giản'               THEN 'Simple Hair Updo'
    WHEN 'Tạo kiểu tóc đi tiệc / sự kiện' THEN 'Event / Party Hairstyling'
    WHEN 'Combo trang điểm + tóc tiệc'   THEN 'Party Makeup + Hair Combo'
    WHEN 'Gói cưới cô dâu cơ bản'        THEN 'Basic Bridal Wedding Package'
    ELSE name_en END
WHERE name IN ('Trang điểm nhẹ nhàng hàng ngày','Trang điểm Hàn Quốc (K-makeup)',
               'Trang điểm đi tiệc ban ngày','Trang điểm dự tiệc tối / event',
               'Trang điểm tốt nghiệp','Trang điểm chụp ảnh','Trang điểm cô dâu thử (trial)',
               'Trang điểm cô dâu ngày cưới','Trang điểm phụ dâu / phù rể','Búi tóc đơn giản',
               'Tạo kiểu tóc đi tiệc / sự kiện','Combo trang điểm + tóc tiệc','Gói cưới cô dâu cơ bản');

-- ── expense_suggestions: English translations ─────────────────

-- Universal
UPDATE expense_suggestions SET name_en = CASE name
    WHEN 'Tiền thuê mặt bằng'            THEN 'Rent'
    WHEN 'Tiền điện'                      THEN 'Electricity'
    WHEN 'Tiền nước'                      THEN 'Water'
    WHEN 'Internet / WiFi'               THEN 'Internet / WiFi'
    WHEN 'Tiền điện thoại'               THEN 'Phone Bill'
    WHEN 'Lương nhân viên'               THEN 'Staff Wages'
    WHEN 'Vệ sinh cửa hàng'              THEN 'Shop Cleaning'
    WHEN 'Sửa chữa / bảo trì'           THEN 'Repair / Maintenance'
    WHEN 'Phí phần mềm quản lý'          THEN 'Management Software Fee'
    WHEN 'Chi phí quảng cáo / fanpage'   THEN 'Advertising / Social Media'
    WHEN 'Phí ngân hàng / chuyển khoản'  THEN 'Bank / Transfer Fees'
    WHEN 'Bảo hiểm cửa hàng'             THEN 'Shop Insurance'
    WHEN 'Thuế môn bài / phí kinh doanh' THEN 'Business License Tax'
    WHEN 'Camera / thiết bị an ninh'     THEN 'Security Camera / Equipment'
    WHEN 'In ấn / văn phòng phẩm'        THEN 'Printing / Stationery'
    WHEN 'Trang trí / nội thất cửa hàng' THEN 'Shop Decoration / Furniture'
    WHEN 'Đồng phục nhân viên'           THEN 'Staff Uniforms'
    WHEN 'Ăn uống nhân viên'             THEN 'Staff Meals'
    WHEN 'Chi phí giao hàng'             THEN 'Delivery Costs'
    WHEN 'Bao bì / túi đựng'             THEN 'Packaging / Bags'
    ELSE name_en END
WHERE name IN ('Tiền thuê mặt bằng','Tiền điện','Tiền nước','Internet / WiFi','Tiền điện thoại',
               'Lương nhân viên','Vệ sinh cửa hàng','Sửa chữa / bảo trì','Phí phần mềm quản lý',
               'Chi phí quảng cáo / fanpage','Phí ngân hàng / chuyển khoản','Bảo hiểm cửa hàng',
               'Thuế môn bài / phí kinh doanh','Camera / thiết bị an ninh','In ấn / văn phòng phẩm',
               'Trang trí / nội thất cửa hàng','Đồng phục nhân viên','Ăn uống nhân viên',
               'Chi phí giao hàng','Bao bì / túi đựng');

-- F&B, Restaurant, Coffee, Pharmacy, Fashion, Electronics, Jewelry/Pawn, Barber, Convenience, Nail, Spa, new beauty types
UPDATE expense_suggestions SET name_en = CASE name
    WHEN 'Nguyên liệu / thực phẩm'                  THEN 'Ingredients / Food Supplies'
    WHEN 'Gas / nhiên liệu nấu ăn'                   THEN 'Gas / Cooking Fuel'
    WHEN 'Dụng cụ bếp / nhà hàng'                   THEN 'Kitchen Equipment'
    WHEN 'Nguyên liệu cà phê / trà'                  THEN 'Coffee / Tea Ingredients'
    WHEN 'Ly / cốc / đồ pha chế'                    THEN 'Cups / Glasses / Barware'
    WHEN 'Phí hoa hồng ứng dụng giao đồ ăn'         THEN 'Food Delivery App Commission'
    WHEN 'Tủ lạnh bảo quản thuốc'                   THEN 'Medicine Refrigerator'
    WHEN 'Phí kiểm định / giấy phép dược phẩm'      THEN 'Pharmacy License / Inspection Fee'
    WHEN 'Bao bì đóng gói thuốc'                    THEN 'Medicine Packaging'
    WHEN 'Phí sàn thương mại điện tử'               THEN 'E-commerce Platform Fee'
    WHEN 'Móc treo / giá trưng bày'                 THEN 'Display Racks / Hangers'
    WHEN 'Bao bì / túi thời trang'                  THEN 'Fashion Bags / Packaging'
    WHEN 'Linh kiện / phụ kiện thay thế'            THEN 'Replacement Parts / Accessories'
    WHEN 'Chi phí bảo hành / dịch vụ sau bán'       THEN 'Warranty / After-sales Service Cost'
    WHEN 'Chi phí giám định hàng hóa'               THEN 'Product Authentication Cost'
    WHEN 'Két sắt / thiết bị bảo mật'               THEN 'Safe / Security Equipment'
    WHEN 'Phí bảo hiểm hàng quý giá'                THEN 'Valuable Goods Insurance'
    WHEN 'Vật tư dịch vụ (dao, kéo, hóa chất)'     THEN 'Service Supplies (razors, scissors, chemicals)'
    WHEN 'Khăn / đồ vệ sinh cá nhân'                THEN 'Towels / Personal Hygiene Supplies'
    WHEN 'Bảo trì / thuê ghế cắt tóc'               THEN 'Barber Chair Maintenance / Rental'
    WHEN 'Phí kiểm kho / kiểm đếm hàng'             THEN 'Stock Count / Inventory Fee'
    WHEN 'Túi nilon / bao bì siêu thị'              THEN 'Plastic Bags / Supermarket Packaging'
    WHEN 'Sơn / gel / bột nail'                     THEN 'Nail Polish / Gel / Powder'
    WHEN 'Đèn UV / máy khoan nail'                  THEN 'UV Lamp / Nail Drill'
    WHEN 'Khăn / bông tẩy trang / phụ kiện'         THEN 'Towels / Cotton Pads / Accessories'
    WHEN 'Dầu massage / tinh dầu aromatherapy'       THEN 'Massage Oil / Aromatherapy Essential Oil'
    WHEN 'Kem dưỡng / mặt nạ / vật tư spa'          THEN 'Moisturiser / Mask / Spa Supplies'
    WHEN 'Khăn / đồ vải spa'                        THEN 'Towels / Spa Linen'
    WHEN 'Máy massage / thiết bị spa'                THEN 'Massage Machine / Spa Equipment'
    WHEN 'Vật tư cắt tóc (tông đơ, dao, kéo)'       THEN 'Barbering Supplies (clippers, razors, scissors)'
    WHEN 'Dầu cạo râu / kem cạo râu'                THEN 'Shaving Oil / Shaving Cream'
    WHEN 'Khăn bông / khăn lạnh phục vụ'            THEN 'Cotton Towels / Cold Towels'
    WHEN 'Bảo trì ghế cắt / thiết bị salon'         THEN 'Barber Chair / Equipment Maintenance'
    WHEN 'Thuốc nhuộm / thuốc uốn / hóa chất tóc'  THEN 'Hair Dye / Perm / Hair Chemicals'
    WHEN 'Dầu gội / dầu xả chuyên nghiệp'           THEN 'Professional Shampoo / Conditioner'
    WHEN 'Khăn bông / áo choàng khách'              THEN 'Cotton Towels / Client Gowns'
    WHEN 'Bảo trì máy sấy / máy uốn / máy duỗi'    THEN 'Hair Dryer / Curler / Straightener Maintenance'
    WHEN 'Chỉ mi / keo mi / dung môi tháo keo'      THEN 'Lash Thread / Adhesive / Remover'
    WHEN 'Mực xăm / kim xăm tiêu hao'               THEN 'PMU Ink / Needles'
    WHEN 'Khăn vô trùng / vật tư tiệt khuẩn'        THEN 'Sterile Towels / Sterilisation Supplies'
    WHEN 'Bảo trì giường / ghế kỹ thuật viên'       THEN 'Technician Bed / Chair Maintenance'
    WHEN 'Tinh dầu / dầu massage chuyên dụng'       THEN 'Essential Oil / Professional Massage Oil'
    WHEN 'Khăn bông / đồ vải massage'               THEN 'Cotton Towels / Massage Linen'
    WHEN 'Bảo trì giường massage'                   THEN 'Massage Bed Maintenance'
    WHEN 'Đá bazan / thiết bị nhiệt massage'        THEN 'Basalt Stones / Thermal Massage Equipment'
    WHEN 'Hóa chất / serum / ampoule điều trị'      THEN 'Treatment Chemicals / Serum / Ampoule'
    WHEN 'Kim vi kim / đầu mũi khoan tiêu hao'      THEN 'Microneedles / Drill Tips'
    WHEN 'Khăn vô trùng / vật tư y tế 1 lần'        THEN 'Sterile Towels / Single-use Medical Supplies'
    WHEN 'Bảo trì thiết bị laser / RF / HIFU'       THEN 'Laser / RF / HIFU Equipment Maintenance'
    WHEN 'Phí kiểm định thiết bị thẩm mỹ'           THEN 'Aesthetic Equipment Inspection Fee'
    WHEN 'Mỹ phẩm / son / phấn / kem nền'           THEN 'Cosmetics / Lipstick / Powder / Foundation'
    WHEN 'Cọ makeup / dụng cụ trang điểm'           THEN 'Makeup Brushes / Tools'
    WHEN 'Đèn ring light / ghế trang điểm'          THEN 'Ring Light / Makeup Chair'
    WHEN 'Áo choàng / khăn phục vụ khách'           THEN 'Client Gown / Towels'
    ELSE name_en END
WHERE name_en IS NULL;
