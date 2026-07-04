UPDATE addon_service
SET image_url = CASE
    WHEN service_name LIKE '%Rose%' OR service_name LIKE '%Flower%' THEN 'assets/img/le-royal/Signature Red Rose Bouquet.jpg'
    WHEN service_name LIKE '%Violin%' OR service_name LIKE '%Pianist%' OR service_name LIKE '%Music%' THEN 'assets/img/le-royal/Private Live Pianist.jpg'
    WHEN service_name LIKE '%Photo%' THEN 'assets/img/le-royal/Private Celebration Photography.webp'
    WHEN service_name LIKE '%Magician%' THEN 'assets/img/le-royal/Private Tableside Magician.jpg'
    ELSE 'assets/img/le-royal/Champagne Welcome Service.jpg'
END
WHERE image_url IS NULL OR LTRIM(RTRIM(image_url)) = '';
