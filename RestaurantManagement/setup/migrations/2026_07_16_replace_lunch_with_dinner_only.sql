USE RestaurantManagement;
GO

DECLARE @sql nvarchar(max) = N'';

SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id))
    + N'.' + QUOTENAME(OBJECT_NAME(cc.parent_object_id))
    + N' DROP CONSTRAINT ' + QUOTENAME(cc.name) + N';' + CHAR(13)
FROM sys.check_constraints cc
JOIN sys.columns col
    ON cc.parent_object_id = col.object_id
   AND cc.parent_column_id = col.column_id
WHERE OBJECT_NAME(cc.parent_object_id) IN ('menu_category', 'menu_set', 'voucher')
  AND col.name IN ('meal_time', 'voucher_type');

IF @sql <> N''
BEGIN
    EXEC sp_executesql @sql;
END;
GO

UPDATE menu_category
SET meal_time = 'DINNER'
WHERE meal_time <> 'DINNER';

UPDATE menu_set
SET meal_time = 'DINNER'
WHERE meal_time <> 'DINNER';

UPDATE voucher
SET voucher_code = 'VIPDINNER',
    voucher_type = 'DINNER'
WHERE voucher_code = 'VIP' + 'LU' + 'NCH'
   OR voucher_type = 'LU' + 'NCH';
GO

ALTER TABLE menu_category
ADD CONSTRAINT CK_menu_category_meal_time_dinner
CHECK (meal_time = 'DINNER');

ALTER TABLE menu_set
ADD CONSTRAINT CK_menu_set_meal_time_dinner
CHECK (meal_time = 'DINNER');

ALTER TABLE voucher
ADD CONSTRAINT CK_voucher_type_dinner
CHECK (voucher_type IN ('FIRST_ORDER','WEEKDAY','DINNER','BIRTHDAY_MONTH','RANK_BENEFIT','MANUAL'));
GO
