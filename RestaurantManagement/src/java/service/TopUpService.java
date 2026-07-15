package service;

import dao.CustomerRankConfigDAO;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.persistence.EntityManager;
import javax.servlet.ServletContext;
import util.JPAUtil;

public class TopUpService {

    public static final BigDecimal VND_PER_XU = new BigDecimal("1000");
    public static final BigDecimal XU_BONUS_RATE = new BigDecimal("0.10");
    private static final Map<TopUpType, String> FREE_VOUCHER_CODES = new HashMap<>();

    static {
        FREE_VOUCHER_CODES.put(TopUpType.XU, "CoinFree");
    }

    private final CustomerRankConfigDAO rankConfigDAO = new CustomerRankConfigDAO();

    private boolean isDevMode(ServletContext ctx) {
        if (ctx == null) return false;
        String env = ctx.getInitParameter("app.env");
        return "dev".equalsIgnoreCase(env) || "test".equalsIgnoreCase(env);
    }

    public String applyVoucher(TopUpType type, String voucherCode, ServletContext ctx) {
        if (voucherCode == null || voucherCode.trim().isEmpty()) return null;
        String expected = FREE_VOUCHER_CODES.get(type);
        if (expected == null || !expected.equalsIgnoreCase(voucherCode.trim()) || !isDevMode(ctx)) return null;
        return expected;
    }

    public BigDecimal calculateFinalAmount(TopUpType type, BigDecimal originalAmount, String voucherCode, ServletContext ctx) {
        if (originalAmount == null || originalAmount.compareTo(BigDecimal.ZERO) <= 0) return BigDecimal.ZERO;
        return applyVoucher(type, voucherCode, ctx) != null ? BigDecimal.ZERO : originalAmount;
    }

    public int calculateRankPoints(BigDecimal paidAmount) {
        if (paidAmount == null || paidAmount.compareTo(BigDecimal.ZERO) <= 0) return 0;
        return paidAmount.divide(VND_PER_XU, 0, RoundingMode.FLOOR).intValue();
    }

    public BigDecimal calculateXuCredit(BigDecimal paidAmount) {
        if (paidAmount == null || paidAmount.compareTo(BigDecimal.ZERO) <= 0) return BigDecimal.ZERO;
        BigDecimal purchasedXu = paidAmount.divide(VND_PER_XU, 0, RoundingMode.FLOOR);
        return purchasedXu.multiply(BigDecimal.ONE.add(XU_BONUS_RATE)).setScale(0, RoundingMode.FLOOR);
    }

    public RankTopUp createTopUp(User user, TopUpType topupType, RankName ignoredTargetRank,
            BigDecimal originalAmount, BigDecimal finalAmount, String voucherCode) {
        if (topupType != TopUpType.XU) {
            throw new IllegalArgumentException("Rank cannot be purchased directly. Please top up Xu instead.");
        }
        if (originalAmount == null || originalAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Top-up amount must be positive.");
        }

        RankTopUp topUp = new RankTopUp();
        topUp.setTopupType(TopUpType.XU);
        topUp.setUser(user);
        topUp.setTargetRank(null);
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
            if (topUp.getTopupType() != TopUpType.XU) {
                throw new IllegalStateException("Only Xu top-ups can be completed.");
            }

            topUp.setStatus(TransactionStatus.SUCCESS);
            topUp.setTransactionRef(transactionRef != null ? transactionRef : "FREE_VOUCHER");
            em.merge(topUp);

            CustomerProfile profile = findProfile(em, topUp.getUser());
            if (profile == null) {
                throw new IllegalStateException("Customer profile was not found.");
            }

            BigDecimal paidAmount = topUp.getFinalAmount() == null ? BigDecimal.ZERO : topUp.getFinalAmount();
            int rankPoints = calculateRankPoints(paidAmount);
            BigDecimal xuCredit = calculateXuCredit(paidAmount);

            profile.setLoyaltyPoints(profile.getLoyaltyPoints() + rankPoints);
            profile.setCoinBalance(profile.getCoinBalance().add(xuCredit));
            profile.setLastActivityAt(new Date());
            em.merge(profile);

            LoyaltyTransaction tx = new LoyaltyTransaction();
            tx.setUser(topUp.getUser());
            tx.setType(LoyaltyTransactionType.TOPUP);
            tx.setPointsDelta(rankPoints);
            tx.setAmountReference(paidAmount);
            tx.setDescription("Xu top-up: +" + xuCredit + " Xu, +" + rankPoints + " rank points");
            em.persist(tx);
            em.getTransaction().commit();

            if (rankPoints > 0) evaluateRankUpgrade(profile);
            sendNotifications(topUp.getUser(), xuCredit, rankPoints);
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
                .setParameter("uid", user.getId()).setMaxResults(1).getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    private void evaluateRankUpgrade(CustomerProfile profile) {
        ArrayList<CustomerRankConfig> ranks = rankConfigDAO.findAllActiveOrderByMinPointThreshold();
        if (ranks == null || ranks.isEmpty()) return;

        int points = profile.getLoyaltyPoints();
        CustomerRankConfig currentRank = profile.getCurrentRank();
        int currentThreshold = currentRank == null ? -1 : currentRank.getMinPointThreshold();
        CustomerRankConfig newRank = null;
        for (CustomerRankConfig rank : ranks) {
            if (points >= rank.getMinPointThreshold() && rank.getMinPointThreshold() > currentThreshold) {
                newRank = rank;
                currentThreshold = rank.getMinPointThreshold();
            }
        }
        if (newRank == null) return;

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

    private void sendNotifications(User user, BigDecimal xuCredit, int rankPoints) {
        try {
            new NotificationService().createNotification(user, "Nap Xu thanh cong",
                    "Ban nhan duoc +" + xuCredit + " Xu (da bao gom 10% uu dai) va +" + rankPoints + " diem Rank.");
        } catch (Exception e) {
            System.err.println("Notification failed: " + e.getMessage());
        }
    }
}