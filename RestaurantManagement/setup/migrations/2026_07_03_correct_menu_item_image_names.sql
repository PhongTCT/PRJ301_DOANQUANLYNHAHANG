USE RestaurantManagement;
GO

UPDATE menu_item
SET item_name = N'Berry Caviar Verrine',
    description = N'Berry compote with yogurt cream, crisp pearls and meringue',
    image_url = 'assets/img/le-royal/menu/matcha-opera-cake.jpg'
WHERE item_name = N'Matcha Opera Cake';

UPDATE menu_item
SET item_name = N'Tea Pairing with Petit Fours',
    description = N'Tableside tea pairing served with small fruit and herb bites',
    image_url = 'assets/img/le-royal/menu/fresh-orange-juice.jpg'
WHERE item_name = N'Fresh Orange Juice';
GO

PRINT 'Corrected menu item names to match assigned local images.';
