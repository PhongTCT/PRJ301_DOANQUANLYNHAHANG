DELETE FROM menu_set;
DBCC CHECKIDENT ('menu_set', RESEED, 0);

INSERT INTO menu_set (set_name, description, original_price, discounted_price, image_url, is_available, meal_time) VALUES 
('Seafood Indulgence Set', 'A lavish seafood collection featuring the freshest catch of the day, carefully prepared to perfection.', 4500000, 3999000, 'assets/img/le-royal/Seafood Indulgence Set.jpg', 1, 'DINNER'),
('Seasonal Tasting Set', 'Experience the best seasonal ingredients through a delicate and refreshing 4-course menu.', 2800000, 2499000, 'assets/img/le-royal/Seasonal Tasting Set.jpg', 1, 'DINNER'),
('Signature Set', 'The classic Le Royal experience with our most celebrated dishes, designed for true connoisseurs.', 3500000, 3199000, 'assets/img/le-royal/Signature Set.webp', 1, 'DINNER'),
('Essence Set', 'A curated selection that captures the essential and elegant flavors of French fine dining.', 1800000, 1599000, 'assets/img/le-royal/Essence Set.webp', 1, 'DINNER'),
('Grand Degustation Set', 'The ultimate 8-course gastronomic journey, presenting our chef''s finest creations.', 6000000, 5499000, 'assets/img/le-royal/Grand Degustation Set.webp', 1, 'DINNER');
