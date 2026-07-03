USE RestaurantManagement;
GO

UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/lotus-stem-salad.jpg';
UPDATE menu_item SET base_price = 420000 WHERE image_url = 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg';
UPDATE menu_item SET base_price = 450000 WHERE image_url = 'assets/img/le-royal/menu/scallop-carpaccio.jpg';
UPDATE menu_item SET base_price = 320000 WHERE image_url = 'assets/img/le-royal/menu/garden-herb-tartlet.jpg';
UPDATE menu_item SET base_price = 460000 WHERE image_url = 'assets/img/le-royal/menu/crab-caviar-bites.jpg';
UPDATE menu_item SET base_price = 380000 WHERE image_url = 'assets/img/le-royal/menu/smoked-duck-salad.jpg';
UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/crab-asparagus-soup.jpg';
UPDATE menu_item SET base_price = 360000 WHERE image_url = 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg';
UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/pumpkin-veloute.jpg';
UPDATE menu_item SET base_price = 480000 WHERE image_url = 'assets/img/le-royal/menu/lobster-bisque.jpg';
UPDATE menu_item SET base_price = 780000 WHERE image_url = 'assets/img/le-royal/menu/black-pepper-beef-tenderloin.jpg';
UPDATE menu_item SET base_price = 680000 WHERE image_url = 'assets/img/le-royal/menu/pan-seared-salmon.jpg';
UPDATE menu_item SET base_price = 1380000 WHERE image_url = 'assets/img/le-royal/menu/grilled-spiny-lobster.jpg';
UPDATE menu_item SET base_price = 1480000 WHERE image_url = 'assets/img/le-royal/menu/king-crab-herb-butter.jpg';
UPDATE menu_item SET base_price = 720000 WHERE image_url = 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg';
UPDATE menu_item SET base_price = 1200000 WHERE image_url = 'assets/img/le-royal/menu/wagyu-short-rib.jpg';
UPDATE menu_item SET base_price = 820000 WHERE image_url = 'assets/img/le-royal/menu/miso-cod.jpg';
UPDATE menu_item SET base_price = 860000 WHERE image_url = 'assets/img/le-royal/menu/seafood-clay-pot.jpg';
UPDATE menu_item SET base_price = 650000 WHERE image_url = 'assets/img/le-royal/menu/roasted-chicken-roulade.jpg';
UPDATE menu_item SET base_price = 980000 WHERE image_url = 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg';
UPDATE menu_item SET base_price = 320000 WHERE image_url = 'assets/img/le-royal/menu/passion-fruit-pavlova.jpg';
UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/berry-sorbet-garden.jpg';
UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/coconut-panna-cotta.jpg';
UPDATE menu_item SET base_price = 340000 WHERE image_url = 'assets/img/le-royal/menu/yuzu-cream-tart.jpg';
UPDATE menu_item SET base_price = 380000 WHERE image_url = 'assets/img/le-royal/menu/chocolate-hazelnut-sphere.jpg';
UPDATE menu_item SET base_price = 360000 WHERE image_url = 'assets/img/le-royal/menu/matcha-opera-cake.jpg';
UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/fresh-orange-juice.jpg';
UPDATE menu_item SET base_price = 1200000 WHERE image_url = 'assets/img/le-royal/menu/bordeaux-red-wine.jpg';
UPDATE menu_item SET base_price = 580000 WHERE image_url = 'assets/img/le-royal/menu/champagne-pairing.jpg';
UPDATE menu_item SET base_price = 300000 WHERE image_url = 'assets/img/le-royal/menu/signature-citrus-cocktail.jpg';
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
UPDATE ms
SET ms.original_price = st.total_price,
    ms.discounted_price = CASE
        WHEN ms.discounted_price IS NULL OR ms.discounted_price < st.total_price THEN st.total_price
        ELSE ms.discounted_price
    END
FROM menu_set ms
JOIN set_totals st ON st.menu_set_id = ms.id;
GO

PRINT 'Raised Le Royal menu item prices to a minimum of 300000 VND.';
