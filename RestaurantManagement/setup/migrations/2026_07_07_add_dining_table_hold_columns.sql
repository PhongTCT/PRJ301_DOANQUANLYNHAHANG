USE RestaurantManagement;
GO

-- Add hold_expiration column if missing
IF COL_LENGTH('dining_table', 'hold_expiration') IS NULL
BEGIN
    ALTER TABLE dining_table ADD hold_expiration DATETIME2 NULL;
    PRINT 'Added hold_expiration column to dining_table.';
END
GO

-- Add hold_user_id column if missing
IF COL_LENGTH('dining_table', 'hold_user_id') IS NULL
BEGIN
    ALTER TABLE dining_table ADD hold_user_id BIGINT NULL;
    PRINT 'Added hold_user_id column to dining_table.';
END
GO

-- Drop old CHECK constraint on status and recreate with HOLD included
DECLARE @constraintName NVARCHAR(128);
SELECT @constraintName = name
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID('dining_table')
  AND COL_NAME(parent_object_id, parent_column_id) = 'status';

IF @constraintName IS NOT NULL
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'ALTER TABLE dining_table DROP CONSTRAINT ' + QUOTENAME(@constraintName);
    EXEC sp_executesql @sql;
    PRINT 'Dropped old status CHECK constraint.';
END
GO

ALTER TABLE dining_table
ADD CONSTRAINT CK_dining_table_status
CHECK (status IN ('AVAILABLE', 'RESERVED', 'OCCUPIED', 'HOLD'));
PRINT 'Added new status CHECK constraint with HOLD.';
GO
