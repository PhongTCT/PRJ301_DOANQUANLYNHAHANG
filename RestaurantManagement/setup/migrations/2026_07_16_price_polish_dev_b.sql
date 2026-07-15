/* Dev B price polish for a dinner-only fine dining project.
   Prices are in VND and are tuned so menu items, tasting sets, rooms and tables feel consistent. */

UPDATE menu_item
SET base_price = CASE image_url
        WHEN 'assets/img/le-royal/menu/lotus-stem-salad.jpg' THEN 360000
        WHEN 'assets/img/le-royal/menu/tuna-tartare-caviar.jpg' THEN 620000
        WHEN 'assets/img/le-royal/menu/scallop-carpaccio.jpg' THEN 580000
        WHEN 'assets/img/le-royal/menu/garden-herb-tartlet.jpg' THEN 380000
        WHEN 'assets/img/le-royal/menu/crab-caviar-bites.jpg' THEN 680000
        WHEN 'assets/img/le-royal/menu/smoked-duck-salad.jpg' THEN 520000
        WHEN 'assets/img/le-royal/menu/ivory-petal.jpg' THEN 420000
        WHEN 'assets/img/le-royal/menu/seasonal-quartet.jpg' THEN 560000
        WHEN 'assets/img/le-royal/menu/ember-petite.jpg' THEN 390000
        WHEN 'assets/img/le-royal/menu/truffle-mushroom-consomme.jpg' THEN 420000
        WHEN 'assets/img/le-royal/menu/pumpkin-veloute.jpg' THEN 360000
        WHEN 'assets/img/le-royal/menu/lobster-bisque.jpg' THEN 680000
        WHEN 'assets/img/le-royal/menu/earthen-bloom.jpg' THEN 390000
        WHEN 'assets/img/le-royal/menu/porcelain-whisper.jpg' THEN 420000
        WHEN 'assets/img/le-royal/menu/rose-gold-broth.jpg' THEN 460000
        WHEN 'assets/img/le-royal/menu/roasted-beef-red-wine-jus.png' THEN 980000
        WHEN 'assets/img/le-royal/menu/grilled-spiny-lobster.jpg' THEN 1580000
        WHEN 'assets/img/le-royal/menu/king-crab-herb-butter.jpg' THEN 1680000
        WHEN 'assets/img/le-royal/menu/duck-breast-plum-jus.jpg' THEN 920000
        WHEN 'assets/img/le-royal/menu/wagyu-short-rib.jpg' THEN 1800000
        WHEN 'assets/img/le-royal/menu/miso-cod.jpg' THEN 980000
        WHEN 'assets/img/le-royal/menu/seafood-clay-pot.jpg' THEN 980000
        WHEN 'assets/img/le-royal/menu/roasted-chicken-roulade.jpg' THEN 760000
        WHEN 'assets/img/le-royal/menu/abalone-saffron-risotto.jpg' THEN 1280000
        WHEN 'assets/img/le-royal/menu/silver-leaf.jpg' THEN 860000
        WHEN 'assets/img/le-royal/menu/jade-crown.jpg' THEN 920000
        WHEN 'assets/img/le-royal/menu/pale-orbit.jpg' THEN 820000
        WHEN 'assets/img/le-royal/menu/black-garden.jpg' THEN 980000
        WHEN 'assets/img/le-royal/menu/midnight-lotus.jpg' THEN 920000
        WHEN 'assets/img/le-royal/menu/hidden-cove.jpg' THEN 980000
        WHEN 'assets/img/le-royal/menu/coconut-panna-cotta.jpg' THEN 320000
        WHEN 'assets/img/le-royal/menu/yuzu-cream-tart.jpg' THEN 380000
        WHEN 'assets/img/le-royal/menu/chocolate-hazelnut-sphere.jpg' THEN 450000
        WHEN 'assets/img/le-royal/menu/matcha-opera-cake.jpg' THEN 420000
        WHEN 'assets/img/le-royal/menu/green-ribbon.jpg' THEN 360000
        WHEN 'assets/img/le-royal/menu/tiny-forest.jpg' THEN 390000
        WHEN 'assets/img/le-royal/menu/ruby-drop.jpg' THEN 380000
        WHEN 'assets/img/le-royal/menu/moss-pearl.jpg' THEN 360000
        WHEN 'assets/img/le-royal/menu/passion-fruit-fizz.jpg' THEN 260000
        WHEN 'assets/img/le-royal/menu/bordeaux-red-wine.jpg' THEN 1200000
        WHEN 'assets/img/le-royal/menu/sparkling-wine.jpg' THEN 650000
        WHEN 'assets/img/le-royal/menu/smoked-citrus-old-fashioned.jpg' THEN 380000
        WHEN 'assets/img/le-royal/menu/nocturne-reserve.jpg' THEN 1500000
        WHEN 'assets/img/le-royal/menu/sommelier-candle.jpg' THEN 1350000
        ELSE base_price END
WHERE image_url IS NOT NULL;

UPDATE area
SET price_modifier = CASE name
        WHEN N'Main Dining Hall' THEN 0
        WHEN N'Garden Lounge' THEN 150000
        WHEN N'Chef Counter & Cellar' THEN 250000
        WHEN N'Skyline View' THEN 300000
        ELSE price_modifier END;

UPDATE room
SET price_per_session = CASE room_name
        WHEN N'Main Salon' THEN 0
        WHEN N'Rose Garden Salon' THEN 150000
        WHEN N'Chef Counter' THEN 300000
        WHEN N'Golden VIP Room' THEN 600000
        WHEN N'Private Cellar Room' THEN 700000
        WHEN N'Skyline Gallery Room' THEN 700000
        WHEN N'Lotus Banquet Room' THEN 1000000
        WHEN N'Royal VVIP Villa' THEN 1500000
        ELSE price_per_session END;

UPDATE dining_table
SET base_price = CASE
        WHEN table_code LIKE 'A0[1-4]' THEN 100000
        WHEN table_code LIKE 'A0[5-8]' THEN 150000
        WHEN table_code IN ('A09','A10') THEN 250000
        WHEN table_code IN ('A11','A12') THEN 350000
        WHEN table_code IN ('G01','SKY-01','SKY-02') THEN 150000
        WHEN capacity = 4 THEN 220000
        WHEN capacity = 6 THEN 300000
        WHEN capacity = 8 THEN 420000
        WHEN capacity = 10 THEN 550000
        WHEN capacity = 12 THEN 650000
        ELSE base_price END
WHERE is_active = 1;

UPDATE addon_service
SET price = CASE service_name
        WHEN N'Garden Floral Styling' THEN 450000
        WHEN N'Rose Bouquet' THEN 380000
        WHEN N'Tableside Violin' THEN 900000
        WHEN N'Tableside Piano Performance' THEN 1200000
        ELSE price END;

;WITH set_totals AS (
    SELECT msi.menu_set_id, SUM(mi.base_price * msi.quantity) AS total_price
    FROM menu_set_item msi
    JOIN menu_item mi ON mi.id = msi.menu_item_id
    GROUP BY msi.menu_set_id
)
UPDATE ms
SET original_price = st.total_price,
    discounted_price = CASE
        WHEN st.total_price >= 3500000 THEN st.total_price - 250000
        WHEN st.total_price >= 2500000 THEN st.total_price - 150000
        ELSE st.total_price
    END
FROM menu_set ms
JOIN set_totals st ON st.menu_set_id = ms.id;
GO
