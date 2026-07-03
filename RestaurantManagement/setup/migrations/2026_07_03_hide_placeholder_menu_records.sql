USE RestaurantManagement;
GO

UPDATE menu_item
SET is_available = 0
WHERE (image_url IS NULL OR image_url = '' OR base_price < 300000)
  AND item_name IN (N'test', N'test01', N'test02');

UPDATE menu_set
SET is_available = 0
WHERE (image_url IS NULL OR image_url = '')
  AND set_name IN (N'test', N'test01', N'test02');
GO

PRINT 'Hid placeholder test menu items and menu sets.';
