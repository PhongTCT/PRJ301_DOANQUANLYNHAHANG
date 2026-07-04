USE RestaurantManagement;
GO

UPDATE menu_item
SET item_name = N'White Fish Truffle Consomme',
    description = N'Clear truffle-scented broth with white fish and herbs',
    image_url = 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg'
WHERE item_name = N'Truffle Mushroom Consomme';

UPDATE menu_item
SET item_name = N'Shellfish Bisque',
    description = N'Rich shellfish broth finished with cream, herb butter and seafood garnish',
    image_url = 'assets/img/le-royal/menu/lobster-bisque.jpg'
WHERE item_name = N'Lobster Bisque';
GO

PRINT 'Corrected soup item names to match assigned local images.';
