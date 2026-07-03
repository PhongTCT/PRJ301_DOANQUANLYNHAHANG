USE RestaurantManagement;
GO

DECLARE @appetizerId INT = (SELECT TOP 1 id FROM menu_category WHERE category_type = 'APPETIZER' ORDER BY id);
DECLARE @soupId INT = (SELECT TOP 1 id FROM menu_category WHERE category_type = 'SOUP' ORDER BY id);
DECLARE @mainCourseId INT = (SELECT TOP 1 id FROM menu_category WHERE category_type = 'MAIN' ORDER BY id);
DECLARE @dessertId INT = (SELECT TOP 1 id FROM menu_category WHERE category_type = 'DESSERT' ORDER BY id);
DECLARE @drinkId INT = (SELECT TOP 1 id FROM menu_category WHERE category_type = 'DRINK' ORDER BY id);

MERGE menu_item AS target
USING (VALUES
    (@appetizerId, N'Saffron Orbit', N'A bright first course with crisp textures and warm saffron notes', 'assets/img/le-royal/menu/saffron-orbit.jpg', 360000),
    (@appetizerId, N'Ivory Petal', N'A delicate plated opening with floral lift and light citrus finish', 'assets/img/le-royal/menu/ivory-petal.jpg', 380000),
    (@appetizerId, N'Seasonal Quartet', N'Four small seasonal bites arranged as a tasting prelude', 'assets/img/le-royal/menu/seasonal-quartet.jpg', 520000),
    (@appetizerId, N'Ember Petite', N'A single warm bite with smoked aroma and herb glaze', 'assets/img/le-royal/menu/ember-petite.jpg', 340000),
    (@soupId, N'Earthen Bloom', N'A grounded broth course with toasted aromatics and tender garnish', 'assets/img/le-royal/menu/earthen-bloom.jpg', 330000),
    (@soupId, N'Porcelain Whisper', N'A pale, creamy soup served with garden herbs and soft mineral notes', 'assets/img/le-royal/menu/porcelain-whisper.jpg', 340000),
    (@soupId, N'Rose Gold Broth', N'A warm golden broth with layered sweetness and gentle spice', 'assets/img/le-royal/menu/rose-gold-broth.jpg', 360000),
    (@mainCourseId, N'Silver Leaf Nocturne', N'A composed seafood plate with bright sauce and soft herb oil', 'assets/img/le-royal/menu/silver-leaf.jpg', 720000),
    (@mainCourseId, N'Jade Crown', N'A refined ocean course with green herb notes and a clean finish', 'assets/img/le-royal/menu/jade-crown.jpg', 780000),
    (@mainCourseId, N'Saffron Sun', N'A golden main course with warm spice, butter and citrus sauce', 'assets/img/le-royal/menu/saffron-sun.jpg', 760000),
    (@mainCourseId, N'Pale Orbit', N'A gentle main course with fruit acidity and a light cream sauce', 'assets/img/le-royal/menu/pale-orbit.jpg', 680000),
    (@mainCourseId, N'Black Garden', N'A deep, earthy main course with roasted notes and dark jus', 'assets/img/le-royal/menu/black-garden.jpg', 900000),
    (@mainCourseId, N'Midnight Lotus', N'A dark-plated main course with floral garnish and layered umami', 'assets/img/le-royal/menu/midnight-lotus.jpg', 840000),
    (@mainCourseId, N'Hidden Cove', N'A coastal main course with fresh herbs and quiet briny sweetness', 'assets/img/le-royal/menu/hidden-cove.jpg', 820000),
    (@dessertId, N'Green Ribbon', N'A clean green dessert with soft cream, leaf aroma and crisp finish', 'assets/img/le-royal/menu/green-ribbon.jpg', 320000),
    (@dessertId, N'Tiny Forest', N'A small forest-inspired dessert with berry, cream and roasted crumble', 'assets/img/le-royal/menu/tiny-forest.jpg', 340000),
    (@dessertId, N'Ruby Drop', N'A jewel-like dessert with bright berry acidity and cool sweetness', 'assets/img/le-royal/menu/ruby-drop.jpg', 360000),
    (@dessertId, N'Moss Pearl', N'A quiet green dessert with soft mousse and delicate herbal finish', 'assets/img/le-royal/menu/moss-pearl.jpg', 330000),
    (@drinkId, N'Nocturne Reserve', N'A sommelier-selected reserve pour for richer tasting menus', 'assets/img/le-royal/menu/nocturne-reserve.jpg', 1350000),
    (@drinkId, N'Sommelier Candle', N'A premium table-side wine pairing chosen for the evening courses', 'assets/img/le-royal/menu/sommelier-candle.jpg', 980000)
) AS src(category_id, item_name, description, image_url, base_price)
ON target.image_url = src.image_url
WHEN MATCHED THEN
    UPDATE SET
        target.category_id = src.category_id,
        target.item_name = src.item_name,
        target.description = src.description,
        target.base_price = src.base_price,
        target.is_available = 1
WHEN NOT MATCHED THEN
    INSERT (category_id, item_name, description, image_url, base_price, is_available)
    VALUES (src.category_id, src.item_name, src.description, src.image_url, src.base_price, 1);
GO

MERGE menu_set AS target
USING (VALUES
    (N'Le Royal Moonlit Journey', N'A poised evening tasting menu moving from garden freshness to a warm ember finish.', 'DINNER', 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg'),
    (N'Garden of Quiet Tides', N'A soft coastal progression with bright sauces, gentle broth and a silver finish.', 'DINNER', 'assets/img/le-royal/menu/pan-seared-salmon.jpg'),
    (N'Ember and Velvet Tasting', N'A darker, rounded menu built around smoke, fruit, roasted depth and quiet sweetness.', 'DINNER', 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg'),
    (N'Royal Shell Nocturne', N'A premium seafood-led tasting menu with deep broth, shellfish and reserve pairing.', 'DINNER', 'assets/img/le-royal/menu/king-crab-herb-butter.jpg'),
    (N'The Amber Finale Course', N'A celebratory course menu with saffron warmth, jade richness and candlelit wine.', 'DINNER', 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg')
) AS src(set_name, description, meal_time, image_url)
ON target.set_name = src.set_name
WHEN MATCHED THEN
    UPDATE SET
        target.description = src.description,
        target.meal_time = src.meal_time,
        target.image_url = src.image_url,
        target.is_available = 1
WHEN NOT MATCHED THEN
    INSERT (set_name, description, meal_time, original_price, discounted_price, image_url, is_available)
    VALUES (src.set_name, src.description, src.meal_time, 0, 0, src.image_url, 1);
GO

WITH set_items AS (
    SELECT * FROM (VALUES
        (N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/lotus-stem-salad.jpg'),
        (N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/crab-asparagus-soup.jpg'),
        (N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg'),
        (N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg'),
        (N'Le Royal Moonlit Journey', 'assets/img/le-royal/menu/bordeaux-red-wine.jpg'),
        (N'Garden of Quiet Tides', 'assets/img/le-royal/menu/scallop-carpaccio.jpg'),
        (N'Garden of Quiet Tides', 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg'),
        (N'Garden of Quiet Tides', 'assets/img/le-royal/menu/pan-seared-salmon.jpg'),
        (N'Garden of Quiet Tides', 'assets/img/le-royal/menu/berry-sorbet-garden.jpg'),
        (N'Garden of Quiet Tides', 'assets/img/le-royal/menu/champagne-pairing.jpg'),
        (N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/smoked-duck-salad.jpg'),
        (N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/pumpkin-veloute.jpg'),
        (N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg'),
        (N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/yuzu-cream-tart.jpg'),
        (N'Ember and Velvet Tasting', 'assets/img/le-royal/menu/fresh-orange-juice.jpg'),
        (N'Royal Shell Nocturne', 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg'),
        (N'Royal Shell Nocturne', 'assets/img/le-royal/menu/lobster-bisque.jpg'),
        (N'Royal Shell Nocturne', 'assets/img/le-royal/menu/king-crab-herb-butter.jpg'),
        (N'Royal Shell Nocturne', 'assets/img/le-royal/menu/matcha-opera-cake.jpg'),
        (N'Royal Shell Nocturne', 'assets/img/le-royal/menu/nocturne-reserve.jpg'),
        (N'The Amber Finale Course', 'assets/img/le-royal/menu/saffron-orbit.jpg'),
        (N'The Amber Finale Course', 'assets/img/le-royal/menu/rose-gold-broth.jpg'),
        (N'The Amber Finale Course', 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg'),
        (N'The Amber Finale Course', 'assets/img/le-royal/menu/coconut-panna-cotta.jpg'),
        (N'The Amber Finale Course', 'assets/img/le-royal/menu/sommelier-candle.jpg')
    ) AS v(set_name, image_url)
)
INSERT INTO menu_set_item (menu_set_id, menu_item_id, quantity)
SELECT ms.id, mi.id, 1
FROM set_items si
JOIN menu_set ms ON ms.set_name = si.set_name
JOIN menu_item mi ON mi.image_url = si.image_url
WHERE NOT EXISTS (
    SELECT 1
    FROM menu_set_item existing
    WHERE existing.menu_set_id = ms.id
      AND existing.menu_item_id = mi.id
      AND existing.default_size_id IS NULL
);
GO

;WITH set_totals AS (
    SELECT
        msi.menu_set_id,
        SUM((mi.base_price + ISNULL(ms.price_modifier, 0)) * msi.quantity) AS total_price
    FROM menu_set_item msi
    JOIN menu_item mi ON mi.id = msi.menu_item_id
    LEFT JOIN menu_item_size ms ON ms.id = msi.default_size_id
    GROUP BY msi.menu_set_id
)
UPDATE menu_set
SET original_price = st.total_price,
    discounted_price = CASE
        WHEN discounted_price IS NULL OR discounted_price < st.total_price THEN st.total_price
        ELSE discounted_price
    END
FROM menu_set
JOIN set_totals st ON st.menu_set_id = menu_set.id;
GO

PRINT 'Seeded 20 additional menu items and 5 poetic set menus.';
