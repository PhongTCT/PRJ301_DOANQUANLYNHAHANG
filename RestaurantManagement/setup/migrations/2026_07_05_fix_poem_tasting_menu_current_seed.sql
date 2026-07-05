USE RestaurantManagement;
GO

;WITH course_names AS (
    SELECT N'Le Royal Moonlit Journey' AS set_name, 1 AS item_id, N'Vườn Ai Mướt Quá' AS course_name_vi UNION ALL
    SELECT N'Le Royal Moonlit Journey', 2, N'Sương Khói Mờ Nhân Ảnh' UNION ALL
    SELECT N'Le Royal Moonlit Journey', 3, N'Thuyền Ai Đậu Bến Trăng' UNION ALL
    SELECT N'Le Royal Moonlit Journey', 25, N'Áo Em Trắng Quá' UNION ALL
    SELECT N'Le Royal Moonlit Journey', 6, N'Gió Theo Lối Gió' UNION ALL

    SELECT N'Garden of Quiet Tides', 10, N'Con Sóng Dưới Lòng Sâu' UNION ALL
    SELECT N'Garden of Quiet Tides', 14, N'Sóng Tìm Ra Tận Bể' UNION ALL
    SELECT N'Garden of Quiet Tides', 4, N'Ngày Xưa Và Ngày Sau' UNION ALL
    SELECT N'Garden of Quiet Tides', 26, N'Ngàn Con Sóng Nhỏ' UNION ALL
    SELECT N'Garden of Quiet Tides', 31, N'Bờ Xa Vỗ Mãi' UNION ALL

    SELECT N'Ember and Velvet Tasting', 13, N'Chờn Vờn Sương Sớm' UNION ALL
    SELECT N'Ember and Velvet Tasting', 15, N'Ấp Iu Nồng Đượm' UNION ALL
    SELECT N'Ember and Velvet Tasting', 19, N'Một Ngọn Lửa Lòng' UNION ALL
    SELECT N'Ember and Velvet Tasting', 28, N'Thương Về Bếp Lửa' UNION ALL
    SELECT N'Ember and Velvet Tasting', 5, N'Dậy Mùi Khói Bếp' UNION ALL

    SELECT N'Royal Shell Nocturne', 9, N'Mặt Trời Xuống Biển' UNION ALL
    SELECT N'Royal Shell Nocturne', 16, N'Câu Hát Căng Buồm' UNION ALL
    SELECT N'Royal Shell Nocturne', 18, N'Cá Bạc Biển Đông' UNION ALL
    SELECT N'Royal Shell Nocturne', 30, N'Sao Mờ Kéo Lưới' UNION ALL
    SELECT N'Royal Shell Nocturne', 51, N'Bình Minh Nâng Chén' UNION ALL

    SELECT N'The Amber Finale Course', 33, N'Nắng Hạ Chưa Phai' UNION ALL
    SELECT N'The Amber Finale Course', 39, N'Hương Mật Tháng Giêng' UNION ALL
    SELECT N'The Amber Finale Course', 24, N'Vội Vàng Giữ Ngọc' UNION ALL
    SELECT N'The Amber Finale Course', 27, N'Mây Gần Môi' UNION ALL
    SELECT N'The Amber Finale Course', 52, N'Men Say Rất Vội'
)
UPDATE msi
SET course_name_vi = course_names.course_name_vi
FROM menu_set_item msi
JOIN menu_set ms ON ms.id = msi.menu_set_id
JOIN course_names ON course_names.set_name = ms.set_name
    AND course_names.item_id = msi.menu_item_id;
GO

UPDATE menu_item SET item_name_vi = N'Gỏi Ngó Sen Tôm' WHERE id = 1;
UPDATE menu_item SET item_name_vi = N'Súp Cua Măng Tây' WHERE id = 2;
UPDATE menu_item SET item_name_vi = N'Thăn Bò Tiêu Đen' WHERE id = 3;
UPDATE menu_item SET item_name_vi = N'Cá Hồi Sốt Chanh Dây' WHERE id = 4;
UPDATE menu_item SET item_name_vi = N'Nước Cam Tươi' WHERE id = 5;
UPDATE menu_item SET item_name_vi = N'Rượu Vang Bordeaux' WHERE id = 6;
UPDATE menu_item SET item_name_vi = N'Cá Ngừ Caviar' WHERE id = 9;
UPDATE menu_item SET item_name_vi = N'Sò Điệp Carpaccio' WHERE id = 10;
UPDATE menu_item SET item_name_vi = N'Salad Vịt Hun Khói' WHERE id = 13;
UPDATE menu_item SET item_name_vi = N'Nước Dùng Nấm Truffle' WHERE id = 14;
UPDATE menu_item SET item_name_vi = N'Súp Bí Đỏ Kem Mịn' WHERE id = 15;
UPDATE menu_item SET item_name_vi = N'Súp Tôm Hùm' WHERE id = 16;
UPDATE menu_item SET item_name_vi = N'Cua Hoàng Đế Bơ Thảo Mộc' WHERE id = 18;
UPDATE menu_item SET item_name_vi = N'Ức Vịt Sốt Mận' WHERE id = 19;
UPDATE menu_item SET item_name_vi = N'Bào Ngư Risotto Saffron' WHERE id = 24;
UPDATE menu_item SET item_name_vi = N'Pavlova Chanh Dây' WHERE id = 25;
UPDATE menu_item SET item_name_vi = N'Sorbet Dâu Rừng' WHERE id = 26;
UPDATE menu_item SET item_name_vi = N'Panna Cotta Dừa' WHERE id = 27;
UPDATE menu_item SET item_name_vi = N'Tart Kem Yuzu' WHERE id = 28;
UPDATE menu_item SET item_name_vi = N'Bánh Opera Matcha' WHERE id = 30;
UPDATE menu_item SET item_name_vi = N'Champagne Pairing' WHERE id = 31;
UPDATE menu_item SET item_name_vi = N'Nocturne Reserve' WHERE id = 51;
UPDATE menu_item SET item_name_vi = N'Sommelier Candle' WHERE id = 52;
GO

PRINT 'Fixed poem course names against the current seeded menu item ids.';
