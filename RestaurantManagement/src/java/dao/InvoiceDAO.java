package dao;

import entity.Invoice;
import enums.PaymentStatus;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class InvoiceDAO extends AbstractDAO<Invoice, Long> {
    public InvoiceDAO() { super(Invoice.class); }

    public List<Invoice> findByUser(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<Invoice> results = em.createQuery("SELECT i FROM Invoice i WHERE i.user.id = :userId ORDER BY i.createdAt DESC", Invoice.class)
                    .setParameter("userId", userId)
                    .getResultList();
            initialize(results);
            return results;
        } finally {
            em.close();
        }
    }

    public List<Invoice> search(String keyword, Date fromDate, Date toDate, boolean paidOnly) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT i FROM Invoice i LEFT JOIN i.user u WHERE 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql.append(" AND (LOWER(i.guestName) LIKE :kw OR LOWER(u.fullName) LIKE :kw OR LOWER(u.email) LIKE :kw OR i.transactionRef LIKE :rawKw)");
            }
            if (fromDate != null) {
                jpql.append(" AND i.createdAt >= :fromDate");
            }
            if (toDate != null) {
                jpql.append(" AND i.createdAt < :toDate");
            }
            if (paidOnly) {
                jpql.append(" AND i.paymentStatus = :paidStatus");
            }
            jpql.append(" ORDER BY i.createdAt DESC");

            javax.persistence.TypedQuery<Invoice> query = em.createQuery(jpql.toString(), Invoice.class);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
                query.setParameter("rawKw", "%" + keyword.trim() + "%");
            }
            if (fromDate != null) {
                query.setParameter("fromDate", fromDate);
            }
            if (toDate != null) {
                query.setParameter("toDate", toDate);
            }
            if (paidOnly) {
                query.setParameter("paidStatus", PaymentStatus.PAID);
            }
            List<Invoice> results = query.getResultList();
            initialize(results);
            return results;
        } finally {
            em.close();
        }
    }

    public Object[] getRevenueSummary() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Object[] result = (Object[]) em.createQuery("SELECT COALESCE(SUM(i.totalAmount), 0), COUNT(i), COALESCE(SUM(i.voucherDiscount), 0), COALESCE(SUM(i.pointsDiscount), 0) FROM Invoice i WHERE i.paymentStatus = :paidStatus")
                    .setParameter("paidStatus", PaymentStatus.PAID)
                    .getSingleResult();
            return result;
        } finally {
            em.close();
        }
    }

    public List<Object[]> getRevenueByDay(Date fromDate, Date toDate) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createNativeQuery("SELECT CAST(paid_at AS date) AS revenue_day, SUM(total_amount) AS revenue, COUNT(*) AS invoice_count FROM invoice WHERE payment_status = 'PAID' AND paid_at IS NOT NULL AND paid_at >= ? AND paid_at < ? GROUP BY CAST(paid_at AS date) ORDER BY CAST(paid_at AS date)")
                    .setParameter(1, fromDate)
                    .setParameter(2, toDate)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    private void initialize(List<Invoice> invoices) {
        for (Invoice invoice : invoices) {
            if (invoice.getUser() != null) {
                invoice.getUser().getFullName();
            }
            if (invoice.getReservation() != null) {
                invoice.getReservation().getId();
            }
            if (invoice.getIssuedByStaff() != null) {
                invoice.getIssuedByStaff().getFullName();
            }
            if (invoice.getVoucherRedemptions() != null) {
                invoice.getVoucherRedemptions().size();
                for (entity.VoucherRedemption redemption : invoice.getVoucherRedemptions()) {
                    redemption.getVoucher().getVoucherCode();
                }
            }
        }
    }
}
