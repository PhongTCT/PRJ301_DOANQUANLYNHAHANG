USE RestaurantManagement;
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

PRINT 'Updated customer_profile loyalty coin columns.';
GO
