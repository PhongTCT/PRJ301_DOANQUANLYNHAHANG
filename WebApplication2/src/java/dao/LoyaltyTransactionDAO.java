package dao;

import entity.LoyaltyTransaction;

public class LoyaltyTransactionDAO extends AbstractDAO<LoyaltyTransaction, Long> {
    public LoyaltyTransactionDAO() { super(LoyaltyTransaction.class); }
}
