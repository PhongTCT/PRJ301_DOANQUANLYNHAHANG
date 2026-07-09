USE RestaurantManagement;
GO

IF COL_LENGTH('rank_topup', 'topup_type') IS NULL
BEGIN
    ALTER TABLE rank_topup
    ADD topup_type VARCHAR(20) NOT NULL
        CONSTRAINT DF_rank_topup_topup_type DEFAULT 'RANK';
END;
GO

IF COL_LENGTH('rank_topup', 'voucher_code') IS NULL
BEGIN
    ALTER TABLE rank_topup
    ADD voucher_code VARCHAR(50) NULL;
END;
GO

IF COL_LENGTH('rank_topup', 'original_amount') IS NULL
BEGIN
    ALTER TABLE rank_topup
    ADD original_amount DECIMAL(12,0) NOT NULL
        CONSTRAINT DF_rank_topup_original_amount DEFAULT 0;
END;
GO

IF COL_LENGTH('rank_topup', 'final_amount') IS NULL
BEGIN
    ALTER TABLE rank_topup
    ADD final_amount DECIMAL(12,0) NOT NULL
        CONSTRAINT DF_rank_topup_final_amount DEFAULT 0;
END;
GO

UPDATE rank_topup
SET topup_type = 'RANK',
    original_amount = ISNULL(original_amount, amount),
    final_amount = ISNULL(final_amount, amount)
WHERE topup_type IS NULL
   OR original_amount IS NULL
   OR final_amount IS NULL;
GO

PRINT 'Migration 2026_07_09: Added topup_type, voucher_code, original_amount, final_amount to rank_topup.';
GO
