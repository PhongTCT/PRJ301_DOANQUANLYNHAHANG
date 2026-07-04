package service;

import dao.*;
import entity.*;
import enums.*;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import javax.persistence.EntityManager;
import util.JPAUtil;

public class LoyaltyService {

    private final CustomerProfileDAO profileDAO = new CustomerProfileDAO();
    private final CustomerRankConfigDAO rankConfigDAO = new CustomerRankConfigDAO();
    private final LoyaltyTransactionDAO transactionDAO = new LoyaltyTransactionDAO();
    private final RankTopUpDAO topUpDAO = new RankTopUpDAO();

    public CustomerProfile getOrCreateProfile(User user) {
        CustomerProfile profile = profileDAO.findByUserId(user.getId());
        if (profile == null) {
            profile = new CustomerProfile();
            profile.setUser(user);
            profile.setTotalSpent(BigDecimal.ZERO);
            profile.setLoyaltyPoints(0);
            profile.setCoinBalance(BigDecimal.ZERO);
            CustomerRankConfig bronze = rankConfigDAO.findByRankName(RankName.BRONZE);
            profile.setCurrentRank(bronze);
            profile.setLastActivityAt(new Date());
            profileDAO.insert(profile);
            profile = profileDAO.findByUserId(user.getId());
        }
        return profile;
    }

    public void processPaidInvoice(Long invoiceId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            Invoice invoice = em.find(Invoice.class, invoiceId);
            if (invoice == null || invoice.getPaymentStatus() != PaymentStatus.PAID) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
                return;
            }

            User user = invoice.getUser();
            CustomerProfile profile = profileDAO.findByUserId(user.getId());
            if (profile == null) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
                return;
            }

            CustomerRankConfig rankConfig = profile.getCurrentRank();
            int ptsPerThousand = (rankConfig != null) ? rankConfig.getPointsPerThousandVnd() : 1;
            BigDecimal totalAmount = invoice.getTotalAmount();

            profile.setTotalSpent(profile.getTotalSpent().add(totalAmount));
            profile.setLastActivityAt(new Date());

            int pointsEarned = calculatePointsFromAmount(totalAmount, true, ptsPerThousand);
            profile.setLoyaltyPoints(profile.getLoyaltyPoints() + pointsEarned);
            profileDAO.update(profile);

            LoyaltyTransaction tx = new LoyaltyTransaction();
            tx.setUser(user);
            tx.setType(LoyaltyTransactionType.EARN);
            tx.setPointsDelta(pointsEarned);
            tx.setAmountReference(totalAmount);
            tx.setDescription("Points from invoice #" + invoiceId);
            transactionDAO.insert(tx);

            evaluateRankUpgrade(profile);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Failed to process paid invoice: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public RankTopUp createTopUpOrder(User user, RankName targetRank, BigDecimal amount, PaymentMethod paymentMethod) {
        RankTopUp topUp = new RankTopUp();
        topUp.setUser(user);
        topUp.setTargetRank(targetRank);
        topUp.setAmount(amount);
        topUp.setPaymentMethod(paymentMethod);
        topUp.setStatus(TransactionStatus.PENDING);
        topUpDAO.insert(topUp);
        return topUp;
    }

    public void confirmTopUp(Long topUpId, String transactionRef) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            RankTopUp topUp = em.find(RankTopUp.class, topUpId);
            if (topUp == null || topUp.getStatus() == TransactionStatus.SUCCESS) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
                return;
            }

            topUp.setStatus(TransactionStatus.SUCCESS);
            topUp.setTransactionRef(transactionRef);
            em.merge(topUp);

            User user = topUp.getUser();
            CustomerProfile profile = profileDAO.findByUserId(user.getId());
            if (profile == null) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
                return;
            }

            BigDecimal amount = topUp.getAmount();
            int pointsEarned = calculatePointsFromAmount(amount, false, 0);
            BigDecimal coinsEarned = BigDecimal.valueOf(pointsEarned);

            profile.setLoyaltyPoints(profile.getLoyaltyPoints() + pointsEarned);
            profile.setCoinBalance(profile.getCoinBalance().add(coinsEarned));
            profile.setTotalSpent(profile.getTotalSpent().add(amount));
            profile.setLastActivityAt(new Date());
            em.merge(profile);

            LoyaltyTransaction tx = new LoyaltyTransaction();
            tx.setUser(user);
            tx.setType(LoyaltyTransactionType.TOPUP);
            tx.setPointsDelta(pointsEarned);
            tx.setAmountReference(amount);
            tx.setDescription("Top-up: +" + pointsEarned + " points, +" + coinsEarned + " coins");
            em.persist(tx);

            evaluateRankUpgrade(profile);

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw new RuntimeException("Failed to confirm top-up: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    public void processPointsDecay() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, -3);
        Date cutoffDate = cal.getTime();

        ArrayList<CustomerProfile> profiles = profileDAO.findProfilesEligibleForDecay(cutoffDate);
        if (profiles == null || profiles.isEmpty()) return;

        for (CustomerProfile profile : profiles) {
            try {
                processSingleDecay(profile);
            } catch (Exception e) {
                System.err.println("Decay failed for profile " + profile.getId() + ": " + e.getMessage());
            }
        }
    }

    private void processSingleDecay(CustomerProfile profile) {
        int currentPoints = profile.getLoyaltyPoints();
        int newPoints = BigDecimal.valueOf(currentPoints)
                .multiply(BigDecimal.valueOf(0.8))
                .setScale(0, RoundingMode.FLOOR)
                .intValue();
        int pointsLost = currentPoints - newPoints;

        if (pointsLost <= 0) return;

        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();

            CustomerProfile managed = em.find(CustomerProfile.class, profile.getId());
            managed.setLoyaltyPoints(newPoints);
            managed.setLastDecayAt(new Date());

            LoyaltyTransaction tx = new LoyaltyTransaction();
            tx.setUser(managed.getUser());
            tx.setType(LoyaltyTransactionType.POINTS_DECAY);
            tx.setPointsDelta(-pointsLost);
            tx.setDescription("20% points decay due to inactivity");
            em.persist(tx);

            em.merge(managed);
            em.getTransaction().commit();

            evaluateRankDowngrade(managed);

        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
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

                try {
                    User userEntity = managed.getUser();
                    String email = userEntity.getEmail();
                    if (email != null && !email.isEmpty()) {
                        String html = util.EmailUtil.buildRankChangeHtml(
                                userEntity.getFullName(),
                                newRank.getRankName().name(),
                                "upgraded",
                                newRank.getDiscountPercent(),
                                newRank.getCanBookVip(),
                                newRank.getCanBookVvip());
                        util.EmailUtil.sendEmailAsync(email,
                                "Chuc mung! Ban da duoc len hang " + newRank.getRankName().name(),
                                html);
                    }
                    NotificationService notifService = new NotificationService();
                    notifService.createNotification(userEntity,
                            "Rank Upgraded",
                            "Congratulations! You've been upgraded to " + newRank.getRankName().name()
                            + " with " + newRank.getDiscountPercent() + "% discount.");
                } catch (Exception e) {
                    System.err.println("Failed to send upgrade notification: " + e.getMessage());
                }

            } catch (Exception e) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
            } finally {
                em.close();
            }
        }
    }

    private void evaluateRankDowngrade(CustomerProfile profile) {
        ArrayList<CustomerRankConfig> ranks = rankConfigDAO.findAllActiveOrderByMinPointThreshold();
        if (ranks == null || ranks.isEmpty()) return;

        int points = profile.getLoyaltyPoints();
        CustomerRankConfig currentRank = profile.getCurrentRank();
        if (currentRank == null) return;

        CustomerRankConfig appropriateRank = null;
        for (CustomerRankConfig rank : ranks) {
            if (points >= rank.getMinPointThreshold()) {
                appropriateRank = rank;
            }
        }

        if (appropriateRank == null) {
            appropriateRank = rankConfigDAO.findByRankName(RankName.BRONZE);
        }

        if (appropriateRank.getId().intValue() != currentRank.getId().intValue()
                && appropriateRank.getMinPointThreshold() < currentRank.getMinPointThreshold()) {

            EntityManager em = JPAUtil.getEntityManager();
            try {
                em.getTransaction().begin();
                CustomerProfile managed = em.find(CustomerProfile.class, profile.getId());
                managed.setCurrentRank(em.find(CustomerRankConfig.class, appropriateRank.getId()));

                LoyaltyTransaction tx = new LoyaltyTransaction();
                tx.setUser(managed.getUser());
                tx.setType(LoyaltyTransactionType.RANK_DOWNGRADE);
                tx.setPointsDelta(0);
                tx.setDescription("Downgraded to " + appropriateRank.getRankName());
                em.persist(tx);

                em.getTransaction().commit();

                try {
                    User userEntity = managed.getUser();
                    String email = userEntity.getEmail();
                    if (email != null && !email.isEmpty()) {
                        String html = util.EmailUtil.buildRankChangeHtml(
                                userEntity.getFullName(),
                                appropriateRank.getRankName().name(),
                                "downgraded",
                                appropriateRank.getDiscountPercent(),
                                appropriateRank.getCanBookVip(),
                                appropriateRank.getCanBookVvip());
                        util.EmailUtil.sendEmailAsync(email,
                                "Thong bao: hang cua ban da bi giam xuong " + appropriateRank.getRankName().name(),
                                html);
                    }
                    NotificationService notifService = new NotificationService();
                    notifService.createNotification(userEntity,
                            "Rank Downgraded",
                            "Your rank has been adjusted to " + appropriateRank.getRankName().name()
                            + " due to inactivity.");
                } catch (Exception e) {
                    System.err.println("Failed to send downgrade notification: " + e.getMessage());
                }

            } catch (Exception e) {
                if (em.getTransaction().isActive()) em.getTransaction().rollback();
            } finally {
                em.close();
            }
        }
    }

    public Map<String, Object> getRankInfo(User user) {
        Map<String, Object> info = new LinkedHashMap<>();
        CustomerProfile profile = getOrCreateProfile(user);
        info.put("loyaltyPoints", profile.getLoyaltyPoints());
        info.put("coinBalance", profile.getCoinBalance());
        info.put("totalSpent", profile.getTotalSpent());
        info.put("currentRank", profile.getCurrentRank());

        ArrayList<CustomerRankConfig> ranks = rankConfigDAO.findAllActiveOrderByMinPointThreshold();
        info.put("allRanks", ranks);

        CustomerRankConfig nextRank = null;
        if (profile.getCurrentRank() != null) {
            int currentThreshold = profile.getCurrentRank().getMinPointThreshold();
            for (CustomerRankConfig rank : ranks) {
                if (rank.getMinPointThreshold() > currentThreshold) {
                    nextRank = rank;
                    break;
                }
            }
        } else if (!ranks.isEmpty()) {
            nextRank = ranks.get(0);
        }
        info.put("nextRank", nextRank);

        int pointsToNext = 0;
        if (nextRank != null) {
            pointsToNext = Math.max(0, nextRank.getMinPointThreshold() - profile.getLoyaltyPoints());
        }
        info.put("pointsToNext", pointsToNext);

        return info;
    }

    public ArrayList<LoyaltyTransaction> getTransactionHistory(User user) {
        return transactionDAO.findByUserIdOrderByCreatedAtDesc(user.getId());
    }

    public ArrayList<CustomerRankConfig> getAllRanks() {
        return rankConfigDAO.findAllActiveOrderByMinPointThreshold();
    }

    public void updateRankConfig(CustomerRankConfig config) {
        CustomerRankConfig existing = rankConfigDAO.searchById(config.getId());
        if (existing != null) {
            existing.setMinPointThreshold(config.getMinPointThreshold());
            existing.setDiscountPercent(config.getDiscountPercent());
            existing.setPointsPerThousandVnd(config.getPointsPerThousandVnd());
            existing.setCanBookVip(config.getCanBookVip());
            existing.setCanBookVvip(config.getCanBookVvip());
            existing.setIsActive(config.getIsActive());
            rankConfigDAO.update(existing);
        }
    }

    public int calculatePointsFromAmount(BigDecimal amount, boolean isInvoice, int ptsPerThousand) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) return 0;
        if (isInvoice) {
            return amount.divide(BigDecimal.valueOf(1000), RoundingMode.FLOOR)
                    .multiply(BigDecimal.valueOf(ptsPerThousand))
                    .setScale(0, RoundingMode.FLOOR)
                    .intValue();
        } else {
            return amount.divide(BigDecimal.valueOf(10000), RoundingMode.FLOOR).intValue();
        }
    }
}