USE RestaurantManagement;
GO

IF NOT EXISTS (SELECT 1 FROM menu_category WHERE category_type = 'APPETIZER')
    INSERT INTO menu_category (category_name, meal_time, category_type, sort_order) VALUES (N'Appetizers', 'ALL_DAY', 'APPETIZER', 1);

IF NOT EXISTS (SELECT 1 FROM menu_category WHERE category_type = 'SOUP')
    INSERT INTO menu_category (category_name, meal_time, category_type, sort_order) VALUES (N'Soups', 'ALL_DAY', 'SOUP', 2);

IF NOT EXISTS (SELECT 1 FROM menu_category WHERE category_type = 'MAIN')
    INSERT INTO menu_category (category_name, meal_time, category_type, sort_order) VALUES (N'Main Courses', 'ALL_DAY', 'MAIN', 3);

IF NOT EXISTS (SELECT 1 FROM menu_category WHERE category_type = 'DESSERT')
    INSERT INTO menu_category (category_name, meal_time, category_type, sort_order) VALUES (N'Desserts', 'ALL_DAY', 'DESSERT', 4);

IF NOT EXISTS (SELECT 1 FROM menu_category WHERE category_type = 'DRINK')
    INSERT INTO menu_category (category_name, meal_time, category_type, sort_order) VALUES (N'Drinks', 'ALL_DAY', 'DRINK', 5);

UPDATE menu_category SET category_name = N'Appetizers', meal_time = 'ALL_DAY', sort_order = 1, is_active = 1 WHERE category_type = 'APPETIZER';
UPDATE menu_category SET category_name = N'Soups', meal_time = 'ALL_DAY', sort_order = 2, is_active = 1 WHERE category_type = 'SOUP';
UPDATE menu_category SET category_name = N'Main Courses', meal_time = 'ALL_DAY', sort_order = 3, is_active = 1 WHERE category_type = 'MAIN';
UPDATE menu_category SET category_name = N'Desserts', meal_time = 'ALL_DAY', sort_order = 4, is_active = 1 WHERE category_type = 'DESSERT';
UPDATE menu_category SET category_name = N'Drinks', meal_time = 'ALL_DAY', sort_order = 5, is_active = 1 WHERE category_type = 'DRINK';
GO

MERGE menu_item AS target
USING (VALUES
    ('APPETIZER', N'Silk Garden Prelude', N'Crisp lotus stem with shrimp, herbs, roasted peanut and lime dressing', 'assets/img/le-royal/menu/lotus-stem-salad.jpg', 300000),
    ('APPETIZER', N'Crimson Tide', N'Cold diced tuna, citrus gel, shallot oil and oscietra-style caviar', 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg', 420000),
    ('APPETIZER', N'Moonlit Shore', N'Thin scallop slices with yuzu kosho, herb oil and sea grapes', 'assets/img/le-royal/menu/scallop-carpaccio.jpg', 450000),
    ('APPETIZER', N'Little Green Sonata', N'Fine pastry tart with herbs, whipped cheese and pickled greens', 'assets/img/le-royal/menu/garden-herb-tartlet.jpg', 320000),
    ('APPETIZER', N'Golden Ember Bites', N'Petite crab canapes with creamy roe sauce and toasted crumbs', 'assets/img/le-royal/menu/crab-caviar-bites.jpg', 460000),
    ('APPETIZER', N'Velvet Orchard', N'Smoked duck breast, young leaves, plum vinaigrette and toasted seeds', 'assets/img/le-royal/menu/smoked-duck-salad.jpg', 380000),
    ('SOUP', N'Amber Pour', N'Warm soup with crab meat and fresh green asparagus', 'assets/img/le-royal/menu/crab-asparagus-soup.jpg', 300000),
    ('SOUP', N'Quiet Tide', N'Clear truffle-scented broth with white fish and herbs', 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg', 360000),
    ('SOUP', N'Autumn Glow', N'Silky pumpkin soup with cream, pumpkin seed oil and toasted almond', 'assets/img/le-royal/menu/pumpkin-veloute.jpg', 300000),
    ('SOUP', N'Deep Sea Velvet', N'Rich shellfish broth finished with cream, herb butter and seafood garnish', 'assets/img/le-royal/menu/lobster-bisque.jpg', 480000),
    ('MAIN', N'Midnight Ember', N'Grilled beef tenderloin with black pepper jus and seasonal vegetables', 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg', 780000),
    ('MAIN', N'Golden Current', N'Salmon with golden butter and passion fruit sauce', 'assets/img/le-royal/menu/pan-seared-salmon.jpg', 680000),
    ('MAIN', N'Red Reef', N'Charcoal grilled lobster with garlic herb butter and lemon', 'assets/img/le-royal/menu/grilled-spiny-lobster.jpg', 1380000),
    ('MAIN', N'Royal Shell Bloom', N'Steamed king crab served with warm herb butter and citrus salt', 'assets/img/le-royal/menu/king-crab-herb-butter.jpg', 1480000),
    ('MAIN', N'Plum Dusk', N'Pink roasted duck breast with spiced plum jus and root vegetables', 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg', 720000),
    ('MAIN', N'Black Fan Nocturne', N'Slow cooked wagyu short rib with red wine sauce and mushroom puree', 'assets/img/le-royal/menu/wagyu-short-rib.jpg', 1200000),
    ('MAIN', N'Pale River', N'White cod marinated in miso, served with dashi butter sauce', 'assets/img/le-royal/menu/miso-cod.jpg', 820000),
    ('MAIN', N'Clay Pot Reverie', N'Prawns, scallop and fish simmered in aromatic clay pot sauce', 'assets/img/le-royal/menu/seafood-clay-pot.jpg', 860000),
    ('MAIN', N'Sunlit Roulade', N'Chicken roulade with foie gras stuffing, herb jus and carrot puree', 'assets/img/le-royal/menu/roasted-chicken-roulade.jpg', 650000),
    ('MAIN', N'Jade Lagoon', N'Creamy saffron risotto with abalone, parmesan and chive oil', 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg', 980000),
    ('DESSERT', N'Cloud on Blue Porcelain', N'Crisp meringue with passion fruit curd, cream and fresh herbs', 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg', 320000),
    ('DESSERT', N'Ruby Garden', N'Raspberry sorbet with berry compote, edible flowers and crisp tuile', 'assets/img/le-royal/menu/berry-sorbet-garden.jpg', 300000),
    ('DESSERT', N'Mist Pearl', N'Coconut panna cotta with tropical fruit and lime espuma', 'assets/img/le-royal/menu/coconut-panna-cotta.jpg', 300000),
    ('DESSERT', N'Honeyed Crown', N'Buttery tart shell with yuzu cream, meringue and basil gel', 'assets/img/le-royal/menu/yuzu-cream-tart.jpg', 340000),
    ('DESSERT', N'Atlas Eclipse', N'Dark chocolate mousse with hazelnut praline and cocoa crumble', 'assets/img/le-royal/menu/chocolate-hazelnut-sphere.jpg', 380000),
    ('DESSERT', N'Berry Nightfall', N'Berry compote with yogurt cream, crisp pearls and meringue', 'assets/img/le-royal/menu/matcha-opera-cake.jpg', 360000),
    ('DRINK', N'Afternoon Ritual', N'Tableside tea pairing served with small fruit and herb bites', 'assets/img/le-royal/menu/fresh-orange-juice.jpg', 300000),
    ('DRINK', N'Cellar Twilight', N'Imported French red wine with dark berry notes and smooth tannin', 'assets/img/le-royal/menu/bordeaux-red-wine.jpg', 1200000),
    ('DRINK', N'Silver Celebration', N'One glass of brut champagne selected for tasting menus', 'assets/img/le-royal/menu/champagne-pairing.jpg', 580000),
    ('DRINK', N'Amber Finale', N'House citrus cocktail with herbal syrup and sparkling finish', 'assets/img/le-royal/menu/signature-citrus-cocktail.jpg', 300000)
) AS src(category_type, item_name, description, image_url, base_price)
ON target.image_url = src.image_url OR target.item_name = src.item_name
WHEN MATCHED THEN
    UPDATE SET
        target.category_id = (SELECT TOP 1 id FROM menu_category WHERE category_type = src.category_type ORDER BY id),
        target.description = src.description,
        target.image_url = src.image_url,
        target.base_price = src.base_price,
        target.is_available = 1
WHEN NOT MATCHED THEN
    INSERT (category_id, item_name, description, image_url, base_price, is_available)
    VALUES ((SELECT TOP 1 id FROM menu_category WHERE category_type = src.category_type ORDER BY id), src.item_name, src.description, src.image_url, src.base_price, 1);
GO

PRINT 'Seeded 30 Le Royal menu items with local prj_images assets.';
