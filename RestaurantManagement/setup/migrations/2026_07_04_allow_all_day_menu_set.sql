USE RestaurantManagement;
GO

DECLARE @constraintName sysname;

SELECT @constraintName = cc.name
FROM sys.check_constraints cc
JOIN sys.columns col
    ON cc.parent_object_id = col.object_id
    AND cc.parent_column_id = col.column_id
WHERE cc.parent_object_id = OBJECT_ID('menu_set')
  AND col.name = 'meal_time';

IF @constraintName IS NOT NULL
BEGIN
    DECLARE @sql nvarchar(max);
    SET @sql = N'ALTER TABLE menu_set DROP CONSTRAINT ' + QUOTENAME(@constraintName);
    EXEC sp_executesql @sql;
END;

ALTER TABLE menu_set
ADD CONSTRAINT CK_menu_set_meal_time
CHECK (meal_time = 'DINNER');
GO

PRINT 'Updated menu_set meal_time for dinner-only service.';
GO
