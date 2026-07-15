/* Dev B final image/content correction.
   Keeps dish images, drink images, and seating images aligned with what is actually shown. */

UPDATE menu_item
SET item_name = N'Midnight Hearth',
    item_name_vi = N'Bếp Đêm',
    description = N'A warm main course with a clear roasted profile, deep sauce and a clean pepper finish.',
    description_vi = N'Món chính ấm vị với sắc nướng rõ, xốt trầm và hậu tiêu gọn.',
    image_url = 'assets/img/le-royal/menu/roasted-beef-red-wine-jus.png'
WHERE image_url = 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg'
   OR item_name_vi = N'Bếp Đêm';

UPDATE menu_item
SET item_name = N'Citrus Garden Fizz',
    item_name_vi = N'Nắng Cam Trong Ly',
    description = N'A bright fruit drink with fresh acidity, served to reset the palate between courses.',
    description_vi = N'Một ly trái cây sáng vị, chua thơm vừa đủ để làm sạch khẩu vị giữa các course.',
    image_url = 'assets/img/le-royal/menu/passion-fruit-fizz.jpg'
WHERE image_url = 'assets/img/le-royal/menu/fresh-orange-juice.jpg'
   OR item_name_vi = N'Nắng Cam Trong Ly';

UPDATE menu_item
SET item_name = N'Silver Toast',
    item_name_vi = N'Ánh Bạc Khai Tiệc',
    description = N'A selected sparkling wine pour for the opening rhythm of an evening tasting menu.',
    description_vi = N'Một ly vang sủi được chọn cho nhịp mở đầu của tasting menu buổi tối.',
    image_url = 'assets/img/le-royal/menu/sparkling-wine.jpg'
WHERE image_url = 'assets/img/le-royal/menu/champagne-pairing.jpg'
   OR item_name_vi IN (N'Ánh Bạc Khai Tiệc', N'Ly Bạc Mừng Tiệc');

UPDATE menu_item
SET item_name = N'Cellar Pairing',
    item_name_vi = N'Hầm Rượu Bên Bàn',
    description = N'A cellar-led pairing selected around the evening courses rather than a single bottle.',
    description_vi = N'Phần rượu được chọn theo nhịp món của buổi tối, không phải một chai riêng lẻ.',
    image_url = 'assets/img/le-royal/menu/sommelier-candle.jpg'
WHERE image_url = 'assets/img/le-royal/menu/sommelier-candle.jpg'
   OR item_name_vi = N'Nến Rượu Bên Bàn';

UPDATE menu_item
SET item_name = N'Amber Finale',
    item_name_vi = N'Hổ Phách Khép Màn',
    description = N'A smoky citrus cocktail with a warm finish for the last note of dinner.',
    description_vi = N'Một ly cocktail cam chanh có sắc khói nhẹ, dùng như nốt kết ấm của bữa tối.',
    image_url = 'assets/img/le-royal/menu/smoked-citrus-old-fashioned.jpg'
WHERE image_url = 'assets/img/le-royal/menu/signature-citrus-cocktail.jpg'
   OR item_name_vi = N'Hổ Phách Khép Màn';

UPDATE menu_set
SET image_url = CASE set_name_vi
        WHEN N'Non Xanh Nước Biếc' THEN 'assets/img/le-royal/menu/garden-herb-tartlet.jpg'
        WHEN N'Trăng Trôi Trên Sóng' THEN 'assets/img/le-royal/menu/scallop-carpaccio.jpg'
        WHEN N'Lửa Ấm Cuối Vườn' THEN 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg'
        WHEN N'Sao Biển Ra Khơi' THEN 'assets/img/le-royal/menu/king-crab-herb-butter.jpg'
        WHEN N'Mùa Vàng Giữ Gió' THEN 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg'
        ELSE image_url END
WHERE set_name_vi IN (N'Non Xanh Nước Biếc', N'Trăng Trôi Trên Sóng', N'Lửa Ấm Cuối Vườn', N'Sao Biển Ra Khơi', N'Mùa Vàng Giữ Gió');

;WITH table_images AS (
    SELECT 'A01' AS table_code, 'assets/img/le-royal/seating/round-romantic-table.jpg' AS image_url UNION ALL
    SELECT 'A02', 'assets/img/le-royal/seating/intimate-round-table.jpg' UNION ALL
    SELECT 'A03', 'assets/img/le-royal/seating/round-romantic-table.jpg' UNION ALL
    SELECT 'A04', 'assets/img/le-royal/seating/intimate-round-table.jpg' UNION ALL
    SELECT 'A05', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'A06', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'A07', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'A08', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'A09', 'assets/img/le-royal/seating/arch-six-seat.jpg' UNION ALL
    SELECT 'A10', 'assets/img/le-royal/seating/floral-six-seat.jpg' UNION ALL
    SELECT 'A11', 'assets/img/le-royal/seating/private-eight-seat.jpg' UNION ALL
    SELECT 'A12', 'assets/img/le-royal/seating/private-eight-seat.jpg' UNION ALL
    SELECT 'CC-01', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'CC-02', 'assets/img/le-royal/seating/arch-six-seat.jpg' UNION ALL
    SELECT 'CEL-01', 'assets/img/le-royal/seating/arch-six-seat.jpg' UNION ALL
    SELECT 'CEL-02', 'assets/img/le-royal/seating/private-eight-seat.jpg' UNION ALL
    SELECT 'G01', 'assets/img/le-royal/seating/round-romantic-table.jpg' UNION ALL
    SELECT 'G02', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'G03', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'G04', 'assets/img/le-royal/seating/floral-six-seat.jpg' UNION ALL
    SELECT 'G05', 'assets/img/le-royal/seating/arch-six-seat.jpg' UNION ALL
    SELECT 'G06', 'assets/img/le-royal/seating/garden-long-table.jpg' UNION ALL
    SELECT 'LB-01', 'assets/img/le-royal/seating/champagne-banquet-table.jpg' UNION ALL
    SELECT 'LB-02', 'assets/img/le-royal/seating/event-long-table.jpg' UNION ALL
    SELECT 'SKY-01', 'assets/img/le-royal/seating/intimate-round-table.jpg' UNION ALL
    SELECT 'SKY-02', 'assets/img/le-royal/seating/round-romantic-table.jpg' UNION ALL
    SELECT 'SKY-03', 'assets/img/le-royal/seating/floral-four-seat.jpg' UNION ALL
    SELECT 'SKY-04', 'assets/img/le-royal/seating/arch-six-seat.jpg' UNION ALL
    SELECT 'VIP-01', 'assets/img/le-royal/seating/floral-six-seat.jpg' UNION ALL
    SELECT 'VIP-02', 'assets/img/le-royal/seating/private-eight-seat.jpg' UNION ALL
    SELECT 'VIP-03', 'assets/img/le-royal/seating/wine-cellar-long-table.jpg' UNION ALL
    SELECT 'VIP-04', 'assets/img/le-royal/seating/wine-cellar-long-table.jpg' UNION ALL
    SELECT 'VVIP-01', 'assets/img/le-royal/seating/wine-cellar-long-table.jpg' UNION ALL
    SELECT 'VVIP-02', 'assets/img/le-royal/seating/event-long-table.jpg' UNION ALL
    SELECT 'VVIP-03', 'assets/img/le-royal/seating/wine-cellar-long-table.jpg' UNION ALL
    SELECT 'VVIP-04', 'assets/img/le-royal/seating/champagne-banquet-table.jpg'
)
UPDATE dt
SET image_url = ti.image_url
FROM dining_table dt
JOIN table_images ti ON ti.table_code = dt.table_code;

UPDATE addon_service
SET service_name = N'Rose Bouquet',
    service_name_vi = N'Bó Hoa Hồng Đỏ',
    description = N'A red rose bouquet prepared for anniversaries, proposals or quiet celebrations.',
    description_vi = N'Bó hồng đỏ chuẩn bị cho kỷ niệm, lời cầu hôn hoặc một buổi tối cần dấu nhấn riêng.',
    image_url = 'assets/img/le-royal/services/red-rose-bouquet.jpg'
WHERE service_name_vi = N'Thiệp Menu Kỷ Niệm'
   OR service_name = N'Keepsake Menu Card';
GO
