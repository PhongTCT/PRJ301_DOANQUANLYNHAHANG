USE RestaurantManagement;
GO

UPDATE menu_category
SET meal_time = 'DINNER'
WHERE meal_time <> 'DINNER';

UPDATE menu_set
SET meal_time = 'DINNER'
WHERE meal_time <> 'DINNER';
GO
