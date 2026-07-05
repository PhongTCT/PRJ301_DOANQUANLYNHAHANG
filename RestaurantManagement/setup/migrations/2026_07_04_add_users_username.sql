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

PRINT 'Added users.username and populated existing accounts.';
GO
