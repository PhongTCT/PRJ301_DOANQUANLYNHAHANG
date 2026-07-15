USE RestaurantManagement;
GO

BEGIN TRANSACTION;

BEGIN TRY
    UPDATE menu_item
    SET item_name_vi = N'Gỏi Ngó Sen Tôm',
        description_vi = N'Ngó sen giòn với tôm, rau thơm, đậu phộng rang và xốt chanh.'
    WHERE id = 1
       OR image_url = 'assets/img/le-royal/menu/lotus-stem-salad.jpg';

    DECLARE @BadMenuItems TABLE (id INT PRIMARY KEY);
    INSERT INTO @BadMenuItems (id)
    SELECT id
    FROM menu_item
    WHERE id IN (7, 8, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 64, 65, 66, 67, 68, 69)
       OR item_name LIKE N'%Codex%'
       OR item_name_vi LIKE N'%Codex%'
       OR item_name LIKE N'test%'
       OR item_name_vi LIKE N'test%'
       OR item_name IN (N'a', N'asj', N'ew', N'F', N'ncs', N'Ã¡Â»Â­ere', N'HÆ°Æ¡ng vá» biá»n cáº£')
       OR base_price = 0;

    DECLARE @BadMenuSets TABLE (id INT PRIMARY KEY);
    INSERT INTO @BadMenuSets (id)
    SELECT id
    FROM menu_set
    WHERE id IN (1, 2, 3, 9, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23)
       OR set_name LIKE N'%Codex%'
       OR set_name_vi LIKE N'%Codex%'
       OR set_name LIKE N'test%'
       OR set_name_vi LIKE N'test%'
       OR set_name IN (N'12', N'qdq', N'gjfag', N'vbvs', N'vbvsjkw')
       OR set_name_vi IN (N'12', N'qdq', N'gjfag', N'vbvs', N'vbvsjkw')
       OR original_price = 0;

    DELETE FROM menu_set_item
    WHERE menu_item_id IN (
            SELECT id FROM @BadMenuItems
            WHERE id NOT IN (SELECT menu_item_id FROM reservation_menu_item WHERE menu_item_id IS NOT NULL)
        )
       OR menu_set_id IN (
            SELECT id FROM @BadMenuSets
            WHERE id NOT IN (SELECT menu_set_id FROM reservation_menu_item WHERE menu_set_id IS NOT NULL)
        );

    DELETE FROM menu_item_size
    WHERE menu_item_id IN (
        SELECT id FROM @BadMenuItems
        WHERE id NOT IN (SELECT menu_item_id FROM reservation_menu_item WHERE menu_item_id IS NOT NULL)
    );

    DELETE FROM menu_item
    WHERE id IN (
        SELECT id FROM @BadMenuItems
        WHERE id NOT IN (SELECT menu_item_id FROM reservation_menu_item WHERE menu_item_id IS NOT NULL)
    );

    UPDATE menu_item
    SET item_name = N'Archived test dish',
        item_name_vi = N'Món thử đã lưu trữ',
        description = N'Archived test record kept for reservation history.',
        description_vi = N'Dữ liệu thử được giữ lại để bảo toàn lịch sử đặt bàn.',
        base_price = CASE WHEN base_price <= 0 THEN 300000 ELSE base_price END,
        is_available = 0
    WHERE id IN (SELECT id FROM @BadMenuItems);

    DELETE FROM menu_set
    WHERE id IN (
        SELECT id FROM @BadMenuSets
        WHERE id NOT IN (SELECT menu_set_id FROM reservation_menu_item WHERE menu_set_id IS NOT NULL)
    );

    UPDATE menu_set
    SET set_name = N'Archived test menu',
        set_name_vi = N'Set thử đã lưu trữ',
        description = N'Archived test record kept for reservation history.',
        description_vi = N'Dữ liệu thử được giữ lại để bảo toàn lịch sử đặt bàn.',
        original_price = CASE WHEN original_price <= 0 THEN 300000 ELSE original_price END,
        discounted_price = CASE WHEN discounted_price <= 0 THEN original_price ELSE discounted_price END,
        is_available = 0
    WHERE id IN (SELECT id FROM @BadMenuSets);

    DELETE FROM menu_category
    WHERE (id = 6
       OR category_name LIKE N'%Codex%'
       OR category_name_vi LIKE N'%Codex%')
      AND id NOT IN (SELECT category_id FROM menu_item);

    DELETE FROM addon_service
    WHERE (id IN (4, 5, 6, 7)
       OR service_name LIKE N'%Codex%'
       OR service_name IN (N'Rose', N'rngerj', N'hend')
       OR price = 0)
      AND id NOT IN (SELECT addon_service_id FROM reservation_addon);

    UPDATE addon_service
    SET service_name = N'Archived test service',
        service_name_vi = N'Dịch vụ thử đã lưu trữ',
        description = N'Archived test record kept for reservation history.',
        description_vi = N'Dữ liệu thử được giữ lại để bảo toàn lịch sử đặt bàn.',
        price = CASE WHEN price <= 0 THEN 100000 ELSE price END,
        is_available = 0
    WHERE (id IN (4, 5, 6, 7)
       OR service_name LIKE N'%Codex%'
       OR service_name IN (N'Rose', N'rngerj', N'hend')
       OR price = 0);

    DELETE FROM dining_table
    WHERE (table_code IN (N'uhjbq', N'test', N'test01', N'test02')
       OR table_code LIKE N'Codex%')
      AND id NOT IN (SELECT dining_table_id FROM reservation_table);

    UPDATE dining_table
    SET table_code = CONCAT(N'ARCHIVED-', id),
        status = 'HOLD'
    WHERE table_code IN (N'uhjbq', N'test', N'test01', N'test02')
       OR table_code LIKE N'Codex%';

    COMMIT TRANSACTION;
    PRINT 'Cleaned Dev B test data and fixed mojibake menu text.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
