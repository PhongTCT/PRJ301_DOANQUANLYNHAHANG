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
       OR item_name IN (N'a', N'asj', N'ew', N'F', N'ncs', N'á»­ere')
       OR base_price = 0;

    DECLARE @BadMenuSets TABLE (id INT PRIMARY KEY);
    INSERT INTO @BadMenuSets (id)
    SELECT id
    FROM menu_set
    WHERE id IN (1, 2, 3, 9, 14, 15, 16, 18, 19, 20, 21, 23)
       OR set_name LIKE N'%Codex%'
       OR set_name_vi LIKE N'%Codex%'
       OR set_name LIKE N'test%'
       OR set_name_vi LIKE N'test%'
       OR original_price = 0;

    DELETE FROM menu_set_item
    WHERE menu_item_id IN (SELECT id FROM @BadMenuItems)
       OR menu_set_id IN (SELECT id FROM @BadMenuSets);

    DELETE FROM menu_item_size
    WHERE menu_item_id IN (SELECT id FROM @BadMenuItems);

    DELETE FROM menu_item
    WHERE id IN (SELECT id FROM @BadMenuItems);

    DELETE FROM menu_set
    WHERE id IN (SELECT id FROM @BadMenuSets);

    DELETE FROM menu_category
    WHERE id = 6
       OR category_name LIKE N'%Codex%'
       OR category_name_vi LIKE N'%Codex%';

    DELETE FROM addon_service
    WHERE id IN (4, 5, 6, 7)
       OR service_name LIKE N'%Codex%'
       OR service_name IN (N'Rose', N'rngerj', N'hend')
       OR price = 0;

    COMMIT TRANSACTION;
    PRINT 'Cleaned Dev B test data and fixed mojibake menu text.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
