package dao;

import entity.Invoice;

public class InvoiceDAO extends AbstractDAO<Invoice, Long> {
    public InvoiceDAO() { super(Invoice.class); }
}
