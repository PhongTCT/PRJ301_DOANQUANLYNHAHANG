USE RestaurantManagement;
GO

IF COL_LENGTH('users', 'username') IS NULL
BEGIN
    ALTER TABLE users ADD username NVARCHAR(50) NULL;
END;
GO

UPDATE users
SET username = CASE
    WHEN role = 'ADMIN' THEN 'admin'
    WHEN phone IS NOT NULL AND LTRIM(RTRIM(phone)) <> '' THEN LTRIM(RTRIM(phone))
    ELSE CONCAT('user', id)
END
WHERE username IS NULL OR LTRIM(RTRIM(username)) = '';
GO

IF EXISTS (
    SELECT username
    FROM users
    GROUP BY username
    HAVING COUNT(*) > 1
)
BEGIN
    ;WITH numbered AS (
        SELECT id,
               username,
               ROW_NUMBER() OVER (PARTITION BY username ORDER BY id) AS row_num
        FROM users
    )
    UPDATE u
    SET username = CONCAT(LEFT(u.username, 40), '_', n.id)
    FROM users u
    JOIN numbered n ON u.id = n.id
    WHERE n.row_num > 1;
END;
GO

IF EXISTS (
    SELECT 1
    FROM sys.columns
    WHERE object_id = OBJECT_ID('users')
      AND name = 'username'
      AND is_nullable = 1
)
BEGIN
    ALTER TABLE users ALTER COLUMN username NVARCHAR(50) NOT NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'UX_users_username'
      AND object_id = OBJECT_ID('users')
)
BEGIN
    CREATE UNIQUE INDEX UX_users_username ON users(username);
END;
GO

IF COL_LENGTH('customer_profile', 'coin_balance') IS NULL
BEGIN
    ALTER TABLE customer_profile
    ADD coin_balance DECIMAL(12,0) NOT NULL
        CONSTRAINT DF_customer_profile_coin_balance DEFAULT 0;
END;
GO

IF COL_LENGTH('customer_profile', 'last_activity_at') IS NULL
BEGIN
    ALTER TABLE customer_profile ADD last_activity_at DATETIME2 NULL;
END;
GO

IF COL_LENGTH('customer_profile', 'last_decay_at') IS NULL
BEGIN
    ALTER TABLE customer_profile ADD last_decay_at DATETIME2 NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_customer_profile_coin_balance'
      AND parent_object_id = OBJECT_ID('customer_profile')
)
BEGIN
    ALTER TABLE customer_profile
    ADD CONSTRAINT CK_customer_profile_coin_balance CHECK (coin_balance >= 0);
END;
GO

IF COL_LENGTH('customer_rank_config', 'min_point_threshold') IS NULL
BEGIN
    ALTER TABLE customer_rank_config
    ADD min_point_threshold INT NOT NULL
        CONSTRAINT DF_customer_rank_config_min_point_threshold DEFAULT 0;
END;
GO

UPDATE customer_rank_config
SET min_point_threshold = CASE rank_name
    WHEN 'BRONZE' THEN 0
    WHEN 'SILVER' THEN 5000
    WHEN 'GOLD' THEN 20000
    WHEN 'PLATINUM' THEN 50000
    WHEN 'DIAMOND' THEN 100000
    ELSE min_point_threshold
END
WHERE min_point_threshold = 0
   OR min_point_threshold IS NULL;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_customer_rank_config_min_point_threshold'
      AND parent_object_id = OBJECT_ID('customer_rank_config')
)
BEGIN
    ALTER TABLE customer_rank_config
    ADD CONSTRAINT CK_customer_rank_config_min_point_threshold CHECK (min_point_threshold >= 0);
END;
GO

IF COL_LENGTH('dining_table', 'image_url') IS NULL
BEGIN
    ALTER TABLE dining_table ADD image_url VARCHAR(500) NULL;
END;
GO

DECLARE @menuSetMealTimeConstraint sysname;

SELECT @menuSetMealTimeConstraint = cc.name
FROM sys.check_constraints cc
JOIN sys.columns col
    ON cc.parent_object_id = col.object_id
    AND cc.parent_column_id = col.column_id
WHERE cc.parent_object_id = OBJECT_ID('menu_set')
  AND col.name = 'meal_time';

IF @menuSetMealTimeConstraint IS NOT NULL
BEGIN
    DECLARE @dropMenuSetMealTimeSql nvarchar(max);
    SET @dropMenuSetMealTimeSql = N'ALTER TABLE menu_set DROP CONSTRAINT ' + QUOTENAME(@menuSetMealTimeConstraint);
    EXEC sp_executesql @dropMenuSetMealTimeSql;
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = 'CK_menu_set_meal_time'
      AND parent_object_id = OBJECT_ID('menu_set')
)
BEGIN
    ALTER TABLE menu_set
    ADD CONSTRAINT CK_menu_set_meal_time
    CHECK (meal_time IN ('BREAKFAST','LUNCH','DINNER','ALL_DAY'));
END;
GO

PRINT 'Schema synchronized with current JPA entity columns.';
GO
