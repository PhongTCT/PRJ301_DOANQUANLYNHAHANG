IF COL_LENGTH('dining_table', 'image_url') IS NULL
BEGIN
    ALTER TABLE dining_table ADD image_url VARCHAR(500) NULL;
END;
GO

UPDATE dining_table
SET image_url = CASE
    WHEN table_code IN ('A01', 'A03') THEN 'assets/img/le-royal/seating/dining-room.jpg'
    WHEN table_code IN ('A02', 'VIP-01') THEN 'assets/img/le-royal/seating/private-table.jpg'
    WHEN table_code = 'A04' THEN 'assets/img/le-royal/seating/counter-seat.jpg'
    ELSE 'assets/img/le-royal/seating/salon-table.jpg'
END
WHERE image_url IS NULL OR LTRIM(RTRIM(image_url)) = '';
