USE RestaurantManagement;
GO

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE menu_set
    SET set_name = CASE id
            WHEN 4 THEN N'Green Mountains, Clear Water'
            WHEN 5 THEN N'Moon Over Quiet Tides'
            WHEN 6 THEN N'Ember Garden Nocturne'
            WHEN 7 THEN N'Starlit Sea Voyage'
            WHEN 8 THEN N'Golden Wind Reverie'
            ELSE set_name END,
        set_name_vi = CASE id
            WHEN 4 THEN N'Non Xanh Nước Biếc'
            WHEN 5 THEN N'Trăng Trôi Trên Sóng'
            WHEN 6 THEN N'Lửa Ấm Cuối Vườn'
            WHEN 7 THEN N'Sao Biển Ra Khơi'
            WHEN 8 THEN N'Mùa Vàng Giữ Gió'
            ELSE set_name_vi END,
        description = CASE id
            WHEN 4 THEN N'A gentle green tasting menu: garden notes, clear broth, pale fish and a quiet herbal finish.'
            WHEN 5 THEN N'A coastal evening sequence shaped by chilled seafood, warm shellfish broth and moonlit wine.'
            WHEN 6 THEN N'A warm dinner built around smoke, duck, pumpkin, embered sauces and a soft citrus ending.'
            WHEN 7 THEN N'A premium sea-led tasting menu moving from tuna and lobster to king crab and reserve wine.'
            WHEN 8 THEN N'A festive golden menu with floral openings, saffron warmth, abalone and candlelit pairing.'
            ELSE description END,
        description_vi = CASE id
            WHEN 4 THEN N'Một tasting menu xanh và trong: hương vườn, nước dùng thanh, cá trắng và hậu vị thảo mộc.'
            WHEN 5 THEN N'Một nhịp biển dưới ánh trăng: hải vị mát, nước dùng ấm và ly rượu đi cùng cuối bữa.'
            WHEN 6 THEN N'Một bữa tối ấm với khói nhẹ, vị vịt, bí đỏ, xốt trầm và kết ngọt cam chanh.'
            WHEN 7 THEN N'Hành trình hải vị cao cấp, đi từ cá ngừ và tôm hùm đến cua hoàng đế và rượu reserve.'
            WHEN 8 THEN N'Một set menu vàng ấm cho buổi tối đặc biệt: hoa, saffron, bào ngư và ánh nến.'
            ELSE description_vi END,
        image_url = CASE id
            WHEN 4 THEN 'assets/img/le-royal/menu-set/white-tasting-menu.jpg'
            WHEN 5 THEN 'assets/img/le-royal/menu-set/red-tasting-menu.jpg'
            WHEN 6 THEN 'assets/img/le-royal/menu-set/festive-tasting-menu.jpg'
            WHEN 7 THEN 'assets/img/le-royal/menu-set/white-tasting-menu.jpg'
            WHEN 8 THEN 'assets/img/le-royal/menu-set/festive-tasting-menu.jpg'
            ELSE image_url END
    WHERE id IN (4, 5, 6, 7, 8);

    UPDATE menu_item
    SET item_name = CASE id
            WHEN 1 THEN N'First Rain in the Garden'
            WHEN 3 THEN N'Midnight Hearth'
            WHEN 5 THEN N'Orange Light'
            WHEN 6 THEN N'Cellar Velvet'
            WHEN 9 THEN N'Crimson Tide'
            WHEN 10 THEN N'Moonlit Shore'
            WHEN 11 THEN N'Little Green Sonata'
            WHEN 12 THEN N'Golden Ember Bites'
            WHEN 13 THEN N'Velvet Orchard'
            WHEN 14 THEN N'Quiet Tide'
            WHEN 15 THEN N'Autumn Glow'
            WHEN 16 THEN N'Deep Sea Velvet'
            WHEN 17 THEN N'Red Reef'
            WHEN 18 THEN N'Royal Shell Bloom'
            WHEN 19 THEN N'Plum Dusk'
            WHEN 20 THEN N'Black Fan Nocturne'
            WHEN 21 THEN N'Pale River'
            WHEN 22 THEN N'Clay Pot Reverie'
            WHEN 23 THEN N'Sunlit Roulade'
            WHEN 24 THEN N'Jade Lagoon'
            WHEN 27 THEN N'Mist Pearl'
            WHEN 28 THEN N'Honeyed Crown'
            WHEN 29 THEN N'Atlas Eclipse'
            WHEN 30 THEN N'Berry Nightfall'
            WHEN 31 THEN N'Silver Celebration'
            WHEN 32 THEN N'Amber Finale'
            ELSE item_name END,
        item_name_vi = CASE id
            WHEN 1 THEN N'Mưa Đầu Vườn'
            WHEN 3 THEN N'Bếp Đêm'
            WHEN 5 THEN N'Nắng Cam Trong Ly'
            WHEN 6 THEN N'Nhung Đỏ Hầm Rượu'
            WHEN 9 THEN N'Triều Đỏ'
            WHEN 10 THEN N'Bờ Trăng'
            WHEN 11 THEN N'Tiểu Khúc Lá Non'
            WHEN 12 THEN N'Đốm Vàng Đầu Bữa'
            WHEN 13 THEN N'Vườn Nhung Khói'
            WHEN 14 THEN N'Sóng Lặng'
            WHEN 15 THEN N'Nắng Thu'
            WHEN 16 THEN N'Nhung Biển Sâu'
            WHEN 17 THEN N'Rạn Đỏ'
            WHEN 18 THEN N'Hoa Vỏ Biển'
            WHEN 19 THEN N'Hoàng Hôn Mận'
            WHEN 20 THEN N'Dạ Khúc Quạt Đen'
            WHEN 21 THEN N'Dòng Sông Trắng'
            WHEN 22 THEN N'Mộng Niêu Trầm'
            WHEN 23 THEN N'Cuộn Nắng Mềm'
            WHEN 24 THEN N'Đầm Ngọc'
            WHEN 27 THEN N'Ngọc Sương'
            WHEN 28 THEN N'Vương Miện Mật'
            WHEN 29 THEN N'Nhật Thực Ca Cao'
            WHEN 30 THEN N'Đêm Dâu Rừng'
            WHEN 31 THEN N'Ly Bạc Mừng Tiệc'
            WHEN 32 THEN N'Hổ Phách Khép Màn'
            ELSE item_name_vi END,
        description = CASE id
            WHEN 5 THEN N'Fresh orange juice served chilled with a light citrus garnish.'
            WHEN 30 THEN N'Matcha opera cake with layered cream, soft sponge and a clean bittersweet finish.'
            ELSE description END,
        description_vi = CASE id
            WHEN 5 THEN N'Nước cam tươi phục vụ lạnh, điểm hương cam chanh nhẹ.'
            WHEN 30 THEN N'Bánh opera matcha nhiều lớp với kem mềm, cốt bánh mịn và hậu vị ngọt đắng thanh.'
            ELSE description_vi END,
        image_url = CASE id
            WHEN 1 THEN 'assets/img/le-royal/menu/lotus-stem-salad.jpg'
            ELSE image_url END
    WHERE id IN (1,3,5,6,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,27,28,29,30,31,32);

    UPDATE menu_set_item SET menu_item_id = 11, course_name = N'The Green', course_name_vi = N'Mở Đầu Xanh' WHERE id = 8;
    UPDATE menu_set_item SET menu_item_id = 21, course_name = N'The Clear Water', course_name_vi = N'Dòng Nước Biếc' WHERE id = 10;
    UPDATE menu_set_item SET menu_item_id = 47, course_name = N'The Leaf', course_name_vi = N'Lá Non Khép Bữa' WHERE id = 12;

    UPDATE menu_set_item SET menu_item_id = 10, course_name = N'The Moon Shore', course_name_vi = N'Bờ Trăng Mát' WHERE id = 13;
    UPDATE menu_set_item SET menu_item_id = 16, course_name = N'The Warm Tide', course_name_vi = N'Sóng Ấm' WHERE id = 14;
    UPDATE menu_set_item SET menu_item_id = 40, course_name = N'The Silver Wake', course_name_vi = N'Vệt Bạc Ngoài Khơi' WHERE id = 17;

    UPDATE menu_set_item SET menu_item_id = 13, course_name = N'The Smoke', course_name_vi = N'Khói Đầu Vườn' WHERE id = 18;
    UPDATE menu_set_item SET menu_item_id = 15, course_name = N'The Hearth', course_name_vi = N'Bếp Bí Đỏ' WHERE id = 19;
    UPDATE menu_set_item SET menu_item_id = 19, course_name = N'The Ember', course_name_vi = N'Than Hồng Mềm' WHERE id = 20;
    UPDATE menu_set_item SET menu_item_id = 28, course_name = N'The Citrus Crown', course_name_vi = N'Vương Miện Cam Chanh' WHERE id = 21;
    UPDATE menu_set_item SET menu_item_id = 32, course_name = N'The Amber Glass', course_name_vi = N'Ly Hổ Phách' WHERE id = 22;

    UPDATE menu_set_item SET menu_item_id = 9, course_name = N'The First Tide', course_name_vi = N'Triều Đầu' WHERE id = 23;
    UPDATE menu_set_item SET menu_item_id = 16, course_name = N'The Deep Broth', course_name_vi = N'Nước Sâu' WHERE id = 24;
    UPDATE menu_set_item SET menu_item_id = 18, course_name = N'The Royal Shell', course_name_vi = N'Vỏ Biển Hoàng Gia' WHERE id = 25;
    UPDATE menu_set_item SET menu_item_id = 30, course_name = N'The Night Sweet', course_name_vi = N'Ngọt Vị Đêm' WHERE id = 26;
    UPDATE menu_set_item SET menu_item_id = 51, course_name = N'The Reserve Pour', course_name_vi = N'Ly Rượu Sao Xa' WHERE id = 27;

    UPDATE menu_set_item SET menu_item_id = 34, course_name = N'The Flower', course_name_vi = N'Cánh Hoa Đầu Bữa' WHERE id = 29;
    UPDATE menu_set_item SET menu_item_id = 39, course_name = N'The Golden Broth', course_name_vi = N'Nước Vàng Hồng' WHERE id = 30;
    UPDATE menu_set_item SET menu_item_id = 24, course_name = N'The Jade', course_name_vi = N'Đầm Ngọc Giữ Gió' WHERE id = 31;
    UPDATE menu_set_item SET menu_item_id = 27, course_name = N'The Mist', course_name_vi = N'Hạt Sương Cuối Mùa' WHERE id = 32;

    UPDATE dining_table
    SET image_url = CASE
            WHEN table_code IN ('A01','A02','A03','A04') THEN 'assets/img/le-royal/seating/dining-room.jpg'
            WHEN table_code IN ('VIP-01','VIP-02') THEN 'assets/img/le-royal/seating/private-table.jpg'
            WHEN table_code IN ('VIPP-01','VIPP-02','VVIP-01') THEN 'assets/img/le-royal/seating/long-private-room.jpg'
            WHEN table_code IN ('G01','G02') THEN 'assets/img/le-royal/seating/salon-table.jpg'
            WHEN table_code IN ('SKY-01','SKY-02') THEN 'assets/img/le-royal/seating/counter-seat.jpg'
            ELSE image_url END;

    UPDATE addon_service
    SET service_name = N'Garden Floral Styling',
        service_name_vi = N'Vườn Hoa Bên Bàn',
        description = N'Seasonal flowers, moss details and candle placement arranged around the table.',
        description_vi = N'Hoa theo mùa, rêu trang trí và ánh nến được sắp đặt quanh bàn tiệc.',
        image_url = 'assets/img/le-royal/services/garden-floral-table.jpg'
    WHERE id = 1;

    UPDATE addon_service
    SET service_name = N'Keepsake Menu Card',
        service_name_vi = N'Thiệp Menu Kỷ Niệm',
        description = N'Personalized printed menu card with guest names, short note and evening course rhythm.',
        description_vi = N'Thiệp menu in riêng với tên khách, lời nhắn ngắn và nhịp course của buổi tối.',
        image_url = 'assets/img/le-royal/Personalized Menu Card.jpg'
    WHERE id = 2;

    UPDATE addon_service
    SET service_name = N'Tableside Violin',
        service_name_vi = N'Vĩ Cầm Bên Bàn',
        description = N'A private violin performance for a quiet celebration moment during dinner.',
        description_vi = N'Một màn trình diễn vĩ cầm riêng cho khoảnh khắc mừng tiệc trong bữa tối.',
        image_url = 'assets/img/le-royal/services/table-violin.jpg'
    WHERE id = 3;

    ;WITH set_totals AS (
        SELECT msi.menu_set_id, SUM(mi.base_price * msi.quantity) AS total_price
        FROM menu_set_item msi
        JOIN menu_item mi ON mi.id = msi.menu_item_id
        GROUP BY msi.menu_set_id
    )
    UPDATE ms
    SET original_price = st.total_price,
        discounted_price = st.total_price
    FROM menu_set ms
    JOIN set_totals st ON st.menu_set_id = ms.id;

    COMMIT TRANSACTION;
    PRINT 'Refined Dev B poetic menu names and corrected images by asset type.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
