IF COL_LENGTH('area', 'name_vi') IS NULL
BEGIN
    ALTER TABLE area ADD name_vi NVARCHAR(100) NULL;
END;

IF COL_LENGTH('area', 'description_vi') IS NULL
BEGIN
    ALTER TABLE area ADD description_vi NVARCHAR(255) NULL;
END;

EXEC sp_executesql N'
UPDATE area
SET
    name = CASE id
        WHEN 1 THEN N''Main Dining Room''
        WHEN 2 THEN N''Garden Lounge''
        WHEN 3 THEN N''Skyline Gallery''
        ELSE name
    END,
    name_vi = CASE id
        WHEN 1 THEN N''Sảnh Tiệc Chính''
        WHEN 2 THEN N''Lounge Sân Vườn''
        WHEN 3 THEN N''Phòng Hướng Phố''
        ELSE COALESCE(name_vi, name)
    END,
    description = CASE id
        WHEN 1 THEN N''Central dining area for the dinner service.''
        WHEN 2 THEN N''A softer garden-side area for quiet tables.''
        WHEN 3 THEN N''Premium seating with a higher city view.''
        ELSE description
    END,
    description_vi = CASE id
        WHEN 1 THEN N''Không gian chính cho trải nghiệm bữa tối tiêu chuẩn.''
        WHEN 2 THEN N''Khu gần vườn yên tĩnh, phù hợp những bàn nhỏ cần riêng tư.''
        WHEN 3 THEN N''Khu ngồi cao cấp với tầm nhìn thành phố thoáng hơn.''
        ELSE COALESCE(description_vi, description)
    END
WHERE id IN (1, 2, 3) OR name_vi IS NULL OR description_vi IS NULL;
';
