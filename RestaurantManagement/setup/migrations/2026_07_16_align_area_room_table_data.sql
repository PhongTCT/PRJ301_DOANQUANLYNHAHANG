USE RestaurantManagement;
GO

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE area
    SET name = N'Skyline Gallery',
        name_vi = N'Khu Hướng Phố',
        description = N'Premium seating with a higher city view.',
        description_vi = N'Khu ngồi cao cấp với tầm nhìn thành phố thoáng hơn.',
        price_modifier = 100000,
        is_active = 1
    WHERE id = 3 OR name = N'Skyline Gallery' OR name_vi = N'Phòng Hướng Phố';

    DECLARE @mainHallId INT = (SELECT TOP 1 id FROM area WHERE name = N'Main Dining Room' OR name_vi = N'Sảnh Tiệc Chính' ORDER BY id);
    DECLARE @gardenId INT = (SELECT TOP 1 id FROM area WHERE name = N'Garden Lounge' OR name_vi = N'Lounge Sân Vườn' ORDER BY id);
    DECLARE @skylineId INT = (SELECT TOP 1 id FROM area WHERE name = N'Skyline Gallery' OR name_vi = N'Khu Hướng Phố' ORDER BY id);

    IF @skylineId IS NULL
    BEGIN
        INSERT INTO area (name, name_vi, description, description_vi, price_modifier, is_active)
        VALUES (N'Skyline Gallery', N'Khu Hướng Phố', N'Premium seating with a higher city view.', N'Khu ngồi cao cấp với tầm nhìn thành phố thoáng hơn.', 100000, 1);
        SET @skylineId = SCOPE_IDENTITY();
    END

    IF NOT EXISTS (SELECT 1 FROM room WHERE room_name = N'Skyline Gallery Room')
    BEGIN
        INSERT INTO room (area_id, room_name, room_type, capacity, price_per_session, is_active)
        VALUES (@skylineId, N'Skyline Gallery Room', 'VIP', 16, 500000, 1);
    END

    DECLARE @gardenRoomId INT = (SELECT TOP 1 id FROM room WHERE room_name = N'Rose Garden Room' ORDER BY id);
    DECLARE @vvipRoomId INT = (SELECT TOP 1 id FROM room WHERE room_name = N'Royal VVIP Villa' ORDER BY id);
    DECLARE @skylineRoomId INT = (SELECT TOP 1 id FROM room WHERE room_name = N'Skyline Gallery Room' ORDER BY id);

    IF @gardenRoomId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dining_table WHERE table_code = 'G01')
        INSERT INTO dining_table (room_id, table_code, capacity, base_price, image_url, status)
        VALUES (@gardenRoomId, 'G01', 2, 50000, 'assets/img/le-royal/seating/private-table.jpg', 'AVAILABLE');

    IF @gardenRoomId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dining_table WHERE table_code = 'G02')
        INSERT INTO dining_table (room_id, table_code, capacity, base_price, image_url, status)
        VALUES (@gardenRoomId, 'G02', 4, 50000, 'assets/img/le-royal/seating/salon-table.jpg', 'AVAILABLE');

    IF @vvipRoomId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dining_table WHERE table_code = 'VVIP-01')
        INSERT INTO dining_table (room_id, table_code, capacity, base_price, image_url, status)
        VALUES (@vvipRoomId, 'VVIP-01', 10, 100000, 'assets/img/le-royal/seating/private-table.jpg', 'AVAILABLE');

    IF @skylineRoomId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dining_table WHERE table_code = 'SKY-01')
        INSERT INTO dining_table (room_id, table_code, capacity, base_price, image_url, status)
        VALUES (@skylineRoomId, 'SKY-01', 4, 100000, 'assets/img/le-royal/seating/dining-room.jpg', 'AVAILABLE');

    IF @skylineRoomId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dining_table WHERE table_code = 'SKY-02')
        INSERT INTO dining_table (room_id, table_code, capacity, base_price, image_url, status)
        VALUES (@skylineRoomId, 'SKY-02', 6, 100000, 'assets/img/le-royal/seating/counter-seat.jpg', 'AVAILABLE');

    COMMIT TRANSACTION;
    PRINT 'Aligned Area -> Room -> DiningTable demo data.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
