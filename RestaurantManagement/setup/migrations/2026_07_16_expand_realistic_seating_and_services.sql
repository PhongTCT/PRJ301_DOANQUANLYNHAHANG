USE RestaurantManagement;
GO

BEGIN TRANSACTION;

BEGIN TRY
    MERGE area AS target
    USING (VALUES
        (N'Main Dining Room', N'Sảnh Tiệc Chính', N'Central dining salon for the standard dinner service.', N'Không gian dùng bữa chính cho nhịp phục vụ buổi tối.', 0),
        (N'Garden Lounge', N'Lounge Sân Vườn', N'A softer garden-side area for quieter tables and small celebrations.', N'Khu gần vườn yên tĩnh cho bàn nhỏ và những buổi kỷ niệm riêng.', 100000),
        (N'Skyline Gallery', N'Khu Hướng Phố', N'Upper gallery seating with a city-facing view.', N'Khu ngồi tầng cao với tầm nhìn hướng phố.', 200000),
        (N'Chef Counter & Cellar', N'Quầy Bếp Và Hầm Rượu', N'Counter seats and intimate cellar rooms for tasting-menu guests.', N'Khu quầy bếp và phòng hầm rượu dành cho trải nghiệm tasting menu thân mật.', 150000)
    ) AS source(name, name_vi, description, description_vi, price_modifier)
        ON target.name = source.name
    WHEN MATCHED THEN
        UPDATE SET name_vi = source.name_vi,
                   description = source.description,
                   description_vi = source.description_vi,
                   price_modifier = source.price_modifier,
                   is_active = 1
    WHEN NOT MATCHED THEN
        INSERT (name, name_vi, description, description_vi, price_modifier, is_active)
        VALUES (source.name, source.name_vi, source.description, source.description_vi, source.price_modifier, 1);

    DECLARE @mainArea INT = (SELECT id FROM area WHERE name = N'Main Dining Room');
    DECLARE @gardenArea INT = (SELECT id FROM area WHERE name = N'Garden Lounge');
    DECLARE @skylineArea INT = (SELECT id FROM area WHERE name = N'Skyline Gallery');
    DECLARE @counterArea INT = (SELECT id FROM area WHERE name = N'Chef Counter & Cellar');

    UPDATE room SET room_name = N'Main Salon' WHERE room_name = N'Standard Room A';
    UPDATE room SET room_name = N'Rose Garden Salon' WHERE room_name = N'Rose Garden Room';

    MERGE room AS target
    USING (VALUES
        (@mainArea, N'Main Salon', 'STANDARD', 48, 0),
        (@mainArea, N'Golden VIP Room', 'VIP', 12, 300000),
        (@mainArea, N'Lotus Banquet Room', 'VIP', 24, 600000),
        (@gardenArea, N'Rose Garden Salon', 'STANDARD', 28, 0),
        (@gardenArea, N'Royal VVIP Villa', 'VVIP', 16, 1000000),
        (@skylineArea, N'Skyline Gallery Room', 'VIP', 18, 500000),
        (@counterArea, N'Chef Counter', 'STANDARD', 10, 150000),
        (@counterArea, N'Private Cellar Room', 'VIP', 8, 450000)
    ) AS source(area_id, room_name, room_type, capacity, price_per_session)
        ON target.room_name = source.room_name
    WHEN MATCHED THEN
        UPDATE SET area_id = source.area_id,
                   room_type = source.room_type,
                   capacity = source.capacity,
                   price_per_session = source.price_per_session,
                   is_active = 1
    WHEN NOT MATCHED THEN
        INSERT (area_id, room_name, room_type, capacity, price_per_session, is_active)
        VALUES (source.area_id, source.room_name, source.room_type, source.capacity, source.price_per_session, 1);

    DECLARE @mainSalon INT = (SELECT id FROM room WHERE room_name = N'Main Salon');
    DECLARE @goldenVip INT = (SELECT id FROM room WHERE room_name = N'Golden VIP Room');
    DECLARE @lotusBanquet INT = (SELECT id FROM room WHERE room_name = N'Lotus Banquet Room');
    DECLARE @roseGarden INT = (SELECT id FROM room WHERE room_name = N'Rose Garden Salon');
    DECLARE @vvipVilla INT = (SELECT id FROM room WHERE room_name = N'Royal VVIP Villa');
    DECLARE @skylineRoom INT = (SELECT id FROM room WHERE room_name = N'Skyline Gallery Room');
    DECLARE @chefCounter INT = (SELECT id FROM room WHERE room_name = N'Chef Counter');
    DECLARE @cellarRoom INT = (SELECT id FROM room WHERE room_name = N'Private Cellar Room');

    MERGE dining_table AS target
    USING (VALUES
        (@mainSalon, 'A01', 2, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A02', 2, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A03', 2, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A04', 2, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A05', 4, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A06', 4, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A07', 4, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A08', 4, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A09', 6, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A10', 6, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A11', 8, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@mainSalon, 'A12', 8, 0, 'assets/img/le-royal/seating/dining-room.jpg'),
        (@goldenVip, 'VIP-01', 6, 200000, 'assets/img/le-royal/seating/vip-room.jpg'),
        (@goldenVip, 'VIP-02', 8, 200000, 'assets/img/le-royal/seating/vip-room.jpg'),
        (@goldenVip, 'VIP-03', 10, 200000, 'assets/img/le-royal/seating/vip-room.jpg'),
        (@goldenVip, 'VIP-04', 12, 200000, 'assets/img/le-royal/seating/vip-room.jpg'),
        (@lotusBanquet, 'LB-01', 12, 200000, 'assets/img/le-royal/seating/long-private-room.jpg'),
        (@lotusBanquet, 'LB-02', 12, 200000, 'assets/img/le-royal/seating/long-private-room.jpg'),
        (@roseGarden, 'G01', 2, 50000, 'assets/img/le-royal/seating/private-table.jpg'),
        (@roseGarden, 'G02', 4, 50000, 'assets/img/le-royal/seating/private-table.jpg'),
        (@roseGarden, 'G03', 4, 50000, 'assets/img/le-royal/seating/private-table.jpg'),
        (@roseGarden, 'G04', 6, 50000, 'assets/img/le-royal/seating/salon-table.jpg'),
        (@roseGarden, 'G05', 6, 50000, 'assets/img/le-royal/seating/salon-table.jpg'),
        (@roseGarden, 'G06', 8, 50000, 'assets/img/le-royal/seating/salon-table.jpg'),
        (@vvipVilla, 'VVIP-01', 10, 300000, 'assets/img/le-royal/seating/long-private-room.jpg'),
        (@vvipVilla, 'VVIP-02', 12, 300000, 'assets/img/le-royal/seating/long-private-room.jpg'),
        (@skylineRoom, 'SKY-01', 2, 100000, 'assets/img/le-royal/seating/gallery-table.jpg'),
        (@skylineRoom, 'SKY-02', 2, 100000, 'assets/img/le-royal/seating/gallery-table.jpg'),
        (@skylineRoom, 'SKY-03', 4, 100000, 'assets/img/le-royal/seating/gallery-table.jpg'),
        (@skylineRoom, 'SKY-04', 6, 100000, 'assets/img/le-royal/seating/gallery-table.jpg'),
        (@chefCounter, 'CC-01', 4, 100000, 'assets/img/le-royal/seating/counter-seat.jpg'),
        (@chefCounter, 'CC-02', 6, 100000, 'assets/img/le-royal/seating/counter-seat.jpg'),
        (@cellarRoom, 'CEL-01', 6, 200000, 'assets/img/le-royal/seating/vip-room.jpg'),
        (@cellarRoom, 'CEL-02', 8, 200000, 'assets/img/le-royal/seating/vip-room.jpg')
    ) AS source(room_id, table_code, capacity, base_price, image_url)
        ON target.table_code = source.table_code
    WHEN MATCHED THEN
        UPDATE SET room_id = source.room_id,
                   capacity = source.capacity,
                   base_price = source.base_price,
                   image_url = source.image_url,
                   is_active = 1
    WHEN NOT MATCHED THEN
        INSERT (room_id, table_code, capacity, base_price, image_url, status, is_active)
        VALUES (source.room_id, source.table_code, source.capacity, source.base_price, source.image_url, 'AVAILABLE', 1);

    UPDATE dining_table
    SET image_url = CASE
            WHEN table_code IN ('VIP-03','VIP-04') THEN 'assets/img/le-royal/seating/long-private-room.jpg'
            WHEN table_code LIKE 'VIP-%' OR table_code LIKE 'CEL-%' THEN 'assets/img/le-royal/seating/vip-room.jpg'
            WHEN table_code LIKE 'VVIP-%' OR table_code LIKE 'LB-%' THEN 'assets/img/le-royal/seating/long-private-room.jpg'
            WHEN table_code LIKE 'G0[1-3]' THEN 'assets/img/le-royal/seating/gallery-table.jpg'
            WHEN table_code LIKE 'G0[4-6]' THEN 'assets/img/le-royal/seating/salon-table.jpg'
            WHEN table_code LIKE 'SKY-%' THEN 'assets/img/le-royal/seating/gallery-table.jpg'
            WHEN table_code LIKE 'CC-%' THEN 'assets/img/le-royal/seating/counter-seat.jpg'
            WHEN table_code LIKE 'A%' THEN 'assets/img/le-royal/seating/dining-room.jpg'
            ELSE image_url END;

    UPDATE dining_table
    SET table_code = N'VVIP-03',
        capacity = 10,
        base_price = 300000,
        image_url = 'assets/img/le-royal/seating/long-private-room.jpg'
    WHERE table_code = N'VIPP-01';

    UPDATE dining_table
    SET table_code = N'VVIP-04',
        capacity = 12,
        base_price = 300000,
        image_url = 'assets/img/le-royal/seating/long-private-room.jpg'
    WHERE table_code = N'VIPP-02';

    UPDATE menu_item
    SET item_name = N'Matcha Nightfall',
        item_name_vi = N'Đêm Trà Xanh',
        description = N'Matcha opera cake with layered cream, soft sponge and a clean bittersweet finish.',
        description_vi = N'Bánh opera matcha nhiều lớp với kem mềm, cốt bánh mịn và hậu vị ngọt đắng thanh.'
    WHERE image_url = 'assets/img/le-royal/menu/matcha-opera-cake.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Rượu Đêm Dài'
    WHERE image_url = 'assets/img/le-royal/menu/nocturne-reserve.jpg';

    UPDATE menu_item
    SET item_name_vi = N'Nến Rượu Bên Bàn'
    WHERE image_url = 'assets/img/le-royal/menu/sommelier-candle.jpg';

    UPDATE menu_set
    SET image_url = CASE
            WHEN set_name_vi = N'Non Xanh Nước Biếc' THEN 'assets/img/le-royal/menu-set/white-tasting-menu.jpg'
            WHEN set_name_vi = N'Trăng Trôi Trên Sóng' THEN 'assets/img/le-royal/menu-set/red-tasting-menu.jpg'
            WHEN set_name_vi = N'Lửa Ấm Cuối Vườn' THEN 'assets/img/le-royal/menu-set/festive-tasting-menu.jpg'
            WHEN set_name_vi = N'Sao Biển Ra Khơi' THEN 'assets/img/le-royal/menu-set/white-tasting-menu.jpg'
            WHEN set_name_vi = N'Mùa Vàng Giữ Gió' THEN 'assets/img/le-royal/menu-set/festive-tasting-menu.jpg'
            ELSE image_url END
    WHERE set_name_vi IN (N'Non Xanh Nước Biếc', N'Trăng Trôi Trên Sóng', N'Lửa Ấm Cuối Vườn', N'Sao Biển Ra Khơi', N'Mùa Vàng Giữ Gió');

    UPDATE addon_service
    SET service_name = N'Rose Bouquet',
        service_name_vi = N'Bó Hoa Hồng Đỏ',
        description = N'A hand-tied red rose bouquet prepared before the dinner service.',
        description_vi = N'Bó hoa hồng đỏ được chuẩn bị riêng trước giờ phục vụ buổi tối.',
        price = 350000,
        image_url = 'assets/img/le-royal/services/red-rose-bouquet.jpg',
        is_available = 1
    WHERE id = 2;

    MERGE addon_service AS target
    USING (VALUES
        (N'Garden Floral Styling', N'Vườn Hoa Bên Bàn', N'Seasonal flowers, moss details and candle placement arranged around the table.', N'Hoa theo mùa, rêu trang trí và ánh nến được sắp đặt quanh bàn tiệc.', 250000, 'assets/img/le-royal/services/garden-floral-table.jpg'),
        (N'Tableside Piano Performance', N'Piano Bên Bàn Tiệc', N'A private piano performance arranged for a quiet celebration during dinner.', N'Màn trình diễn piano riêng cho khoảnh khắc mừng tiệc trong bữa tối.', 700000, 'assets/img/le-royal/services/private-piano.jpg'),
        (N'Tableside Violin', N'Vĩ Cầm Bên Bàn', N'A private violin performance for a quiet celebration moment during dinner.', N'Một màn trình diễn vĩ cầm riêng cho khoảnh khắc mừng tiệc trong bữa tối.', 500000, 'assets/img/le-royal/services/table-violin.jpg')
    ) AS source(service_name, service_name_vi, description, description_vi, price, image_url)
        ON target.service_name = source.service_name
    WHEN MATCHED THEN
        UPDATE SET service_name_vi = source.service_name_vi,
                   description = source.description,
                   description_vi = source.description_vi,
                   price = source.price,
                   image_url = source.image_url,
                   is_available = 1
    WHEN NOT MATCHED THEN
        INSERT (service_name, service_name_vi, description, description_vi, price, image_url, is_available)
        VALUES (source.service_name, source.service_name_vi, source.description, source.description_vi, source.price, source.image_url, 1);

    UPDATE addon_service
    SET is_available = 0
    WHERE service_name IN (N'Keepsake Menu Card', N'Celebration Cake')
       OR service_name_vi IN (N'Thiệp Menu Kỷ Niệm', N'Bánh Mừng Đêm Tiệc');

    COMMIT TRANSACTION;
    PRINT 'Expanded realistic Dev B seating data and corrected add-on services.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
