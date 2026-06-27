package dao;

import entity.RefundTransaction;

public class RefundTransactionDAO extends AbstractDAO<RefundTransaction, Long> {
    public RefundTransactionDAO() { super(RefundTransaction.class); }
}
