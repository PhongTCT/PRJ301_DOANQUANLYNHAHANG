package service;

import dao.CustomerProfileDAO;
import dao.CustomerRankConfigDAO;
import dao.LoyaltyTransactionDAO;
import dao.RankTopUpDAO;
import entity.CustomerProfile;
import entity.CustomerRankConfig;
import entity.LoyaltyTransaction;
import entity.RankTopUp;
import entity.User;
import enums.LoyaltyTransactionType;
import enums.PaymentMethod;
import enums.RankName;
import enums.TopUpType;
import enums.TransactionStatus;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import javax.persistence.EntityManager;
import javax.servlet.ServletContext;
import util.JPAUtil;

public class TopUpService {

    private static final Map<TopUpType, String> FREE_VOUCHER_CODES = new HashMap<>();
    static {
        FREE_VOUCHER_CODES.put(TopUpType.RANK, "VipFree");
        FREE_VOUCHER_CODES.put(TopUpType.XU, "CoinFree");
    }

    private static final BigDecimal RATE = new BigDecimal("10000");
    private final CustomerRankConfigDAO rankConfigDAO = new CustomerRankConfigDAO();

    private boolean isDevMode(ServletContext ctx) {
        if (ctx == null) return true;
        String env = ctx.getInitParameter("app.env");
        return env == null || "dev".equalsIgnoreCase(env.trim()) || "test".equalsIgnoreCase(env.trim());
    }

    public String applyVoucher(TopUpType type, String voucherCode, ServletContext ctx) {
        if (voucherCode == null || voucherCode.trim().isEmpty()) return null;
        String expected = FREE_VOUCHER_CODES.get(type);
        if (expected == null) return null;
        if (!expected.equalsIgnoreCase(voucherCode.trim())) return null;
        if (!isDevMode(ctx)) return null;
        return expected;
    }

    public BigDecimal calculateFinalAmount(TopUpType type, BigDecimal originalAmount, String voucherCode, ServletContext ctx) {
        if (originalAmount == null || originalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        String applied = applyVoucher(type, voucherCode, ctx);
        return applied != null ? BigDecimal.ZERO : originalAmount;
    }

    public int calculatePointsAndCoins(BigDecimal originalAmount) {
        if (originalAmount == null || originalAmount.compareTo(BigDecimal.ZERO) <= 0) return 0;
        return originalAmount.divide(RATE, RoundingMode.FLOOR).intValue();
    }

    public RankTopUp createTopUp(User user, TopUpType topupType, RankName targetRank,
                                  BigDecimal originalAmount, BigDecimal finalAmount, String voucherCode) {
        RankTopUp topUp = new RankTopUp();
        topUp.setTopupType(topupType);
        topUp.setUser(user);
        topUp.setTargetRank(topupType == TopUpType.RANK ? targetRank : null);
        topUp.setOriginalAmount(originalAmount);
        topUp.setFinalAmount(finalAmount);
        topUp.setAmount(finalAmount);
        topUp.setVoucherCode(voucherCode);
        topUp.setPaymentMethod(PaymentMethod.VNPAY);
        topUp.setStatus(TransactionStatus.PENDING);
        new RankTopUpDAO().insert(topUp);
        return topUp;
    }

    public void completeTopUp(Long topUpId, String transactionRef) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            RankTopUp topUp = em.find(RankTopUp.class, topUpId);
            if (topUp == null || topUp.getStatus() == TransactionStatus.SUCCESS) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
                return;
            }

            topUp.setStatus(TransactionStatus.SUCCESS);
            topUp.setTransactionRef(transactionRef != null ? transactionRef : "FREE_VOUCHER");
            em.merge(topUp);

            User user = topUp.getUser();
            CustomerProfile profile = findProfile(em, user);
            if (profile == null) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
                return;
            }

            BigDecimal originalAmount = topUp.getOriginalAmount();
            int earned = calculatePointsAndCoins(originalAmount);

            profile.setLoyaltyPoints(profile.getLoyaltyPoints() + earned);
            profile.setCoinBalance(profile.getCoinBalance().add(BigDecimal.valueOf(earned)));
            profile.setTotalSpent(profile.getTotalSpent().add(originalAmount));
            profile.setLastActivityAt(new Date());
            em.merge(profile);

            String desc;
            if (topUp.getTopupType() == TopUpType.RANK) {
                desc = "Nap len hang " + topUp.getTargetRank() + ": +" + earned + " diem";
            } else {
                desc = "Nap xu +" + earned + " xu";
            }
            if (topUp.getFinalAmount() != null && topUp.getFinalAmount().compareTo(BigDecimal.ZERO) == 0
                    && topUp.getVoucherCode() != null) {
                desc += " (giao dich mien phi bang ma uu dai)";
            }

            LoyaltyTransaction tx = new LoyaltyTransaction();
            tx.setUser(user);
            tx.setType(LoyaltyTransactionType.TOPUP);
            tx.setPointsDelta(earned);
            tx.setAmountReference(originalAmount);
            tx.setDescription(desc);
            em.persist(tx);

            em.getTransaction().commit();

            if (earned > 0) {
                evaluateRankUpgrade(profile);
            }

            sendNotifications(user, earned, topUp);

        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("completeTopUp failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    private CustomerProfile findProfile(EntityManager em, User user) {
        List<CustomerProfile> results = em.createQuery(
                "SELECT p FROM CustomerProfile p WHERE p.user.id = :uid", CustomerProfile.class)
                .setParameter("uid", user.getId())
                .setMaxResults(1)
                .getResultList();
        if (results.isEmpty()) return null;
        CustomerProfile p = results.get(0);
        if (p.getCurrentRank() != null) p.getCurrentRank().getId();
        return p;
    }

    private void evaluateRankUpgrade(CustomerProfile profile) {
        ArrayList<CustomerRankConfig> ranks = rankConfigDAO.findAllActiveOrderByMinPointThreshold();
        if (ranks == null || ranks.isEmpty()) return;

        int points = profile.getLoyaltyPoints();
        CustomerRankConfig currentRank = profile.getCurrentRank();
        Integer currentThreshold = (currentRank != null) ? currentRank.getMinPointThreshold() : -1;

        CustomerRankConfig newRank = null;
        for (CustomerRankConfig rank : ranks) {
            if (points >= rank.getMinPointThreshold() && rank.getMinPointThreshold() > currentThreshold) {
                newRank = rank;
                currentThreshold = rank.getMinPointThreshold();
            }
        }

        if (newRank != null) {
            EntityManager em = JPAUtil.getEntityManager();
            try {
                em.getTransaction().begin();
                CustomerProfile managed = em.find(CustomerProfile.class, profile.getId());
                managed.setCurrentRank(em.find(CustomerRankConfig.class, newRank.getId()));

                LoyaltyTransaction tx = new LoyaltyTransaction();
                tx.setUser(managed.getUser());
                tx.setType(LoyaltyTransactionType.RANK_UPGRADE);
                tx.setPointsDelta(0);
                tx.setDescription("Upgraded to " + newRank.getRankName());
                em.persist(tx);

                em.getTransaction().commit();
            } catch (Exception e) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
            } finally {
                em.close();
            }
        }
    }

    private void sendNotifications(User user, int earned, RankTopUp topUp) {
        try {
            String label = topUp.getTopupType() == TopUpType.RANK ? "diem" : "xu";
            String title = "Nap " + label + " thanh cong";
            String msg = "Ban da nap +" + earned + " " + label + " thanh cong.";
            if (topUp.getFinalAmount() != null && topUp.getFinalAmount().compareTo(BigDecimal.ZERO) == 0) {
                msg += " (Giao dich mien phi bang ma uu dai)";
            }
            new NotificationService().createNotification(user, title, msg);
        } catch (Exception e) {
            System.err.println("Notification failed: " + e.getMessage());
        }
    }
}
