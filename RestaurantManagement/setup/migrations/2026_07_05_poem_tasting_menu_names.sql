USE RestaurantManagement;
GO

IF COL_LENGTH('menu_set', 'set_name_vi') IS NULL
BEGIN
    ALTER TABLE menu_set ADD set_name_vi NVARCHAR(150) NULL;
END
GO

IF COL_LENGTH('menu_set', 'description_vi') IS NULL
BEGIN
    ALTER TABLE menu_set ADD description_vi NVARCHAR(MAX) NULL;
END
GO

IF COL_LENGTH('menu_set_item', 'course_name') IS NULL
BEGIN
    ALTER TABLE menu_set_item ADD course_name NVARCHAR(150) NULL;
END
GO

IF COL_LENGTH('menu_set_item', 'course_name_vi') IS NULL
BEGIN
    ALTER TABLE menu_set_item ADD course_name_vi NVARCHAR(150) NULL;
END
GO

UPDATE menu_set
SET set_name_vi = N'Trăng Về Vĩ Dạ',
    description_vi = N'Một thực đơn tối lấy cảm hứng từ ánh trăng, khu vườn và màn sương xứ Huế.'
WHERE set_name = N'Le Royal Moonlit Journey';

UPDATE menu_set
SET set_name_vi = N'Dữ Dội Và Dịu Êm',
    description_vi = N'Một nhịp biển mềm, đi từ vị tươi mát đến dư âm lấp lánh như sóng.'
WHERE set_name = N'Garden of Quiet Tides';

UPDATE menu_set
SET set_name_vi = N'Bếp Lửa Ấp Iu',
    description_vi = N'Một tasting menu ấm, sâu và có khói, gợi cảm giác bữa tối bên bếp lửa.'
WHERE set_name = N'Ember and Velvet Tasting';

UPDATE menu_set
SET set_name_vi = N'Đoàn Thuyền Sao Biển',
    description_vi = N'Một hành trình hải vị đêm, từ mặt biển tối đến khoang thuyền đầy sao.'
WHERE set_name = N'Royal Shell Nocturne';

UPDATE menu_set
SET set_name_vi = N'Tắt Nắng Buộc Gió',
    description_vi = N'Một thực đơn tiệc sáng rực, giữ lại hương vàng, men say và khoảnh khắc đang chín.'
WHERE set_name = N'The Amber Finale Course';

;WITH course_names AS (
    SELECT N'Le Royal Moonlit Journey' AS set_name, N'Lotus Stem Salad' AS item_name, N'Vườn Ai Mướt Quá' AS course_name_vi UNION ALL
    SELECT N'Le Royal Moonlit Journey', N'Crab Asparagus Soup', N'Sương Khói Mờ Nhân Ảnh' UNION ALL
    SELECT N'Le Royal Moonlit Journey', N'Black Pepper Beef Tenderloin', N'Thuyền Ai Đậu Bến Trăng' UNION ALL
    SELECT N'Le Royal Moonlit Journey', N'Passion Fruit Pavlova', N'Áo Em Trắng Quá' UNION ALL
    SELECT N'Le Royal Moonlit Journey', N'Bordeaux Red Wine', N'Gió Theo Lối Gió' UNION ALL

    SELECT N'Garden of Quiet Tides', N'Scallop Carpaccio', N'Con Sóng Dưới Lòng Sâu' UNION ALL
    SELECT N'Garden of Quiet Tides', N'Truffle Mushroom Consommé', N'Sóng Tìm Ra Tận Bể' UNION ALL
    SELECT N'Garden of Quiet Tides', N'Pan Seared Salmon', N'Ngày Xưa Và Ngày Sau' UNION ALL
    SELECT N'Garden of Quiet Tides', N'Berry Sorbet Garden', N'Ngàn Con Sóng Nhỏ' UNION ALL
    SELECT N'Garden of Quiet Tides', N'Champagne Pairing', N'Bờ Xa Vỗ Mãi' UNION ALL

    SELECT N'Ember and Velvet Tasting', N'Smoked Duck Salad', N'Chờn Vờn Sương Sớm' UNION ALL
    SELECT N'Ember and Velvet Tasting', N'Pumpkin Velouté', N'Ấp Iu Nồng Đượm' UNION ALL
    SELECT N'Ember and Velvet Tasting', N'Duck Breast Plum Jus', N'Một Ngọn Lửa Lòng' UNION ALL
    SELECT N'Ember and Velvet Tasting', N'Yuzu Cream Tart', N'Thương Về Bếp Lửa' UNION ALL
    SELECT N'Ember and Velvet Tasting', N'Fresh Orange Juice', N'Dậy Mùi Khói Bếp' UNION ALL

    SELECT N'Royal Shell Nocturne', N'Tuna Tartare Caviar', N'Mặt Trời Xuống Biển' UNION ALL
    SELECT N'Royal Shell Nocturne', N'Lobster Bisque', N'Câu Hát Căng Buồm' UNION ALL
    SELECT N'Royal Shell Nocturne', N'King Crab Herb Butter', N'Cá Bạc Biển Đông' UNION ALL
    SELECT N'Royal Shell Nocturne', N'Matcha Opera Cake', N'Sao Mờ Kéo Lưới' UNION ALL
    SELECT N'Royal Shell Nocturne', N'Nocturne Reserve', N'Bình Minh Nâng Chén' UNION ALL

    SELECT N'The Amber Finale Course', N'Saffron Orbit', N'Nắng Hạ Chưa Phai' UNION ALL
    SELECT N'The Amber Finale Course', N'Rose Gold Broth', N'Hương Mật Tháng Giêng' UNION ALL
    SELECT N'The Amber Finale Course', N'Abalone Saffron Risotto', N'Vội Vàng Giữ Ngọc' UNION ALL
    SELECT N'The Amber Finale Course', N'Coconut Panna Cotta', N'Mây Gần Môi' UNION ALL
    SELECT N'The Amber Finale Course', N'Sommelier Candle', N'Men Say Rất Vội'
)
UPDATE msi
SET course_name_vi = course_names.course_name_vi
FROM menu_set_item msi
JOIN menu_set ms ON ms.id = msi.menu_set_id
JOIN menu_item mi ON mi.id = msi.menu_item_id
JOIN course_names ON course_names.set_name = ms.set_name
    AND course_names.item_name = mi.item_name;
GO

UPDATE menu_item SET item_name_vi = N'Gỏi Ngó Sen Tôm' WHERE item_name = N'Lotus Stem Salad';
UPDATE menu_item SET item_name_vi = N'Súp Cua Măng Tây' WHERE item_name = N'Crab Asparagus Soup';
UPDATE menu_item SET item_name_vi = N'Thăn Bò Tiêu Đen' WHERE item_name = N'Black Pepper Beef Tenderloin';
UPDATE menu_item SET item_name_vi = N'Cá Hồi Sốt Chanh Dây' WHERE item_name = N'Pan Seared Salmon';
UPDATE menu_item SET item_name_vi = N'Nước Cam Tươi' WHERE item_name = N'Fresh Orange Juice';
UPDATE menu_item SET item_name_vi = N'Rượu Vang Bordeaux' WHERE item_name = N'Bordeaux Red Wine';
UPDATE menu_item SET item_name_vi = N'Cá Ngừ Caviar' WHERE item_name = N'Tuna Tartare Caviar';
UPDATE menu_item SET item_name_vi = N'Sò Điệp Carpaccio' WHERE item_name = N'Scallop Carpaccio';
UPDATE menu_item SET item_name_vi = N'Salad Vịt Hun Khói' WHERE item_name = N'Smoked Duck Salad';
UPDATE menu_item SET item_name_vi = N'Nước Dùng Nấm Truffle' WHERE item_name = N'Truffle Mushroom Consommé';
UPDATE menu_item SET item_name_vi = N'Súp Bí Đỏ Kem Mịn' WHERE item_name = N'Pumpkin Velouté';
UPDATE menu_item SET item_name_vi = N'Súp Tôm Hùm' WHERE item_name = N'Lobster Bisque';
UPDATE menu_item SET item_name_vi = N'Cua Hoàng Đế Bơ Thảo Mộc' WHERE item_name = N'King Crab Herb Butter';
UPDATE menu_item SET item_name_vi = N'Ức Vịt Sốt Mận' WHERE item_name = N'Duck Breast Plum Jus';
UPDATE menu_item SET item_name_vi = N'Bào Ngư Risotto Saffron' WHERE item_name = N'Abalone Saffron Risotto';
UPDATE menu_item SET item_name_vi = N'Pavlova Chanh Dây' WHERE item_name = N'Passion Fruit Pavlova';
UPDATE menu_item SET item_name_vi = N'Sorbet Dâu Rừng' WHERE item_name = N'Berry Sorbet Garden';
UPDATE menu_item SET item_name_vi = N'Panna Cotta Dừa' WHERE item_name = N'Coconut Panna Cotta';
UPDATE menu_item SET item_name_vi = N'Tart Kem Yuzu' WHERE item_name = N'Yuzu Cream Tart';
UPDATE menu_item SET item_name_vi = N'Bánh Opera Matcha' WHERE item_name = N'Matcha Opera Cake';
UPDATE menu_item SET item_name_vi = N'Champagne Pairing' WHERE item_name = N'Champagne Pairing';
UPDATE menu_item SET item_name_vi = N'Nocturne Reserve' WHERE item_name = N'Nocturne Reserve';
UPDATE menu_item SET item_name_vi = N'Sommelier Candle' WHERE item_name = N'Sommelier Candle';
GO

PRINT 'Updated menu sets with Vietnamese poem themes and set-specific course names.';
