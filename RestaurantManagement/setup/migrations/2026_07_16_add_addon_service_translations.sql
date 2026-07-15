USE RestaurantManagement;
GO

IF COL_LENGTH('addon_service', 'service_name_vi') IS NULL
BEGIN
    ALTER TABLE addon_service ADD service_name_vi NVARCHAR(150) NULL;
END;

IF COL_LENGTH('addon_service', 'description_vi') IS NULL
BEGIN
    ALTER TABLE addon_service ADD description_vi NVARCHAR(MAX) NULL;
END;
GO

UPDATE addon_service
SET service_name_vi = CASE
        WHEN service_name = N'Rose Table Decoration' THEN N'Bàn Hoa Hồng Ánh Nến'
        WHEN service_name = N'Premium Birthday Cake' THEN N'Bánh Mừng Đêm Tiệc'
        WHEN service_name = N'Celebration Cake' THEN N'Bánh Mừng Đêm Tiệc'
        WHEN service_name = N'Table Violin Performance' THEN N'Khúc Vĩ Cầm Bên Bàn'
        ELSE COALESCE(NULLIF(service_name_vi, N''), service_name)
    END,
    description_vi = CASE
        WHEN service_name = N'Rose Table Decoration' THEN N'Hoa hồng tươi và ánh nến được sắp đặt riêng cho bàn tiệc.'
        WHEN service_name = N'Premium Birthday Cake' THEN N'Bánh chocolate hoặc trái cây chuẩn bị theo lời nhắn của khách.'
        WHEN service_name = N'Celebration Cake' THEN N'Bánh chocolate hoặc trái cây chuẩn bị theo lời nhắn của khách.'
        WHEN service_name = N'Table Violin Performance' THEN N'Màn trình diễn vĩ cầm riêng trong ba mươi phút cho buổi tối.'
        ELSE COALESCE(NULLIF(description_vi, N''), description)
    END;

UPDATE addon_service
SET service_name = N'Celebration Cake',
    description = N'Chocolate or fruit cake prepared on request'
WHERE service_name = N'Premium Birthday Cake';
GO
