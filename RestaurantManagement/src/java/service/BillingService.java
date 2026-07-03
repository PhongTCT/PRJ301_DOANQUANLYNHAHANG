package service;

import dto.BookingDraft;
import entity.AddonService;
import entity.CustomerProfile;
import entity.DiningTable;
import entity.Invoice;
import entity.MenuItem;
import entity.MenuSet;
import entity.Reservation;
import entity.ReservationAddon;
import entity.ReservationMenuItem;
import entity.ReservationTable;
import entity.User;
import entity.Voucher;
import entity.VoucherRedemption;
import enums.PaymentMethod;
import enums.PaymentStatus;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Date;
import javax.persistence.EntityManager;
import javax.persistence.LockModeType;

public class BillingService {
    public static final BigDecimal POINT_VALUE = new BigDecimal("1000");

    public BigDecimal calculateDraftSubtotal(EntityManager em, BookingDraft draft) {
        BigDecimal subtotal = BigDecimal.ZERO;
        if (draft == null) {
            return subtotal;
        }

        if (draft.getSelectedTableIds() != null) {
            for (Integer tableId : draft.getSelectedTableIds()) {
                DiningTable table = em.find(DiningTable.class, tableId);
                if (table != null && table.getBasePrice() != null) {
                    subtotal = subtotal.add(table.getBasePrice());
                }
            }
        }

        if (draft.getMenuItems() != null) {
            for (BookingDraft.CartItemDTO itemDto : draft.getMenuItems()) {
                MenuItem item = em.find(MenuItem.class, itemDto.getMenuItemId());
                if (item != null && item.getBasePrice() != null) {
                    subtotal = subtotal.add(item.getBasePrice().multiply(BigDecimal.valueOf(safeQty(itemDto.getQuantity()))));
                }
            }
        }

        if (draft.getMenuSets() != null) {
            for (BookingDraft.CartSetDTO setDto : draft.getMenuSets()) {
                MenuSet set = em.find(MenuSet.class, setDto.getMenuSetId());
                if (set != null) {
                    BigDecimal price = set.getDiscountedPrice() != null ? set.getDiscountedPrice() : set.getOriginalPrice();
                    if (price != null) {
                        subtotal = subtotal.add(price.multiply(BigDecimal.valueOf(safeQty(setDto.getQuantity()))));
                    }
                }
            }
        }

        if (draft.getAddons() != null) {
            for (BookingDraft.CartAddonDTO addonDto : draft.getAddons()) {
                AddonService addon = em.find(AddonService.class, addonDto.getAddonId());
                if (addon != null && addon.getPrice() != null) {
                    subtotal = subtotal.add(addon.getPrice().multiply(BigDecimal.valueOf(safeQty(addonDto.getQuantity()))));
                }
            }
        }

        return subtotal;
    }

    public BigDecimal calculateReservationSubtotal(Reservation reservation) {
        BigDecimal subtotal = BigDecimal.ZERO;
        if (reservation == null) {
            return subtotal;
        }
        if (reservation.getReservationTables() != null) {
            for (ReservationTable rt : reservation.getReservationTables()) {
                if (rt.getDiningTable() != null && rt.getDiningTable().getBasePrice() != null) {
                    subtotal = subtotal.add(rt.getDiningTable().getBasePrice());
                }
            }
        }
        if (reservation.getReservationMenuItems() != null) {
            for (ReservationMenuItem item : reservation.getReservationMenuItems()) {
                subtotal = subtotal.add(nullToZero(item.getUnitPrice()).multiply(BigDecimal.valueOf(safeQty(item.getQuantity()))));
            }
        }
        if (reservation.getReservationAddons() != null) {
            for (ReservationAddon addon : reservation.getReservationAddons()) {
                subtotal = subtotal.add(nullToZero(addon.getUnitPrice()).multiply(BigDecimal.valueOf(safeQty(addon.getQuantity()))));
            }
        }
        return subtotal;
    }

    public BigDecimal calculateSurcharge(BigDecimal subtotal, BookingDraft draft) {
        if (draft == null || !Boolean.TRUE.equals(draft.getHasSurcharge()) || draft.getSurchargePercent() == null) {
            return BigDecimal.ZERO;
        }
        return nullToZero(subtotal)
                .multiply(draft.getSurchargePercent())
                .divide(new BigDecimal("100"), 0, RoundingMode.HALF_UP);
    }

    public BigDecimal calculateVoucherDiscount(Voucher voucher, BigDecimal orderValue) {
        if (voucher == null || orderValue == null) {
            return BigDecimal.ZERO;
        }
        if (voucher.getMinOrderValue() != null && orderValue.compareTo(voucher.getMinOrderValue()) < 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal discount = BigDecimal.ZERO;
        if (voucher.getDiscountPercent() != null && voucher.getDiscountPercent().compareTo(BigDecimal.ZERO) > 0) {
            discount = orderValue.multiply(voucher.getDiscountPercent()).divide(new BigDecimal("100"), 0, RoundingMode.HALF_UP);
            if (voucher.getMaxDiscount() != null && voucher.getMaxDiscount().compareTo(BigDecimal.ZERO) > 0) {
                discount = discount.min(voucher.getMaxDiscount());
            }
        } else if (voucher.getDiscountAmount() != null) {
            discount = voucher.getDiscountAmount();
        }

        if (discount.compareTo(orderValue) > 0) {
            discount = orderValue;
        }
        return discount.max(BigDecimal.ZERO);
    }

    public Voucher validateVoucher(EntityManager em, String code, User user, BigDecimal orderValue) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }
        Voucher voucher = findVoucherByCode(em, code);
        if (voucher == null) {
            throw new IllegalArgumentException("Voucher không tồn tại.");
        }
        em.lock(voucher, LockModeType.PESSIMISTIC_WRITE);
        Date now = new Date();
        if (!Boolean.TRUE.equals(voucher.getIsActive()) || voucher.getValidFrom().after(now) || voucher.getValidTo().before(now)) {
            throw new IllegalArgumentException("Voucher không còn hiệu lực.");
        }
        int limit = voucher.getUsageLimit() == null ? 0 : voucher.getUsageLimit();
        int used = voucher.getUsedCount() == null ? 0 : voucher.getUsedCount();
        if (limit <= 0 || used >= limit) {
            throw new IllegalArgumentException("Voucher đã hết số lượng.");
        }
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("Bạn cần đăng nhập để dùng voucher.");
        }
        Long redeemed = em.createQuery("SELECT COUNT(r) FROM VoucherRedemption r WHERE r.user.id = :userId AND r.voucher.id = :voucherId", Long.class)
                .setParameter("userId", user.getId())
                .setParameter("voucherId", voucher.getId())
                .getSingleResult();
        if (redeemed != null && redeemed > 0) {
            throw new IllegalArgumentException("Voucher này đã được dùng cho tài khoản của bạn.");
        }
        if (voucher.getMinOrderValue() != null && orderValue.compareTo(voucher.getMinOrderValue()) < 0) {
            throw new IllegalArgumentException("Hóa đơn chưa đạt giá trị tối thiểu để dùng voucher.");
        }
        return voucher;
    }

    public Invoice createInvoiceForReservation(EntityManager em, Reservation reservation, User user, User staff,
            BigDecimal subtotal, BigDecimal surcharge, Voucher voucher, int requestedPoints, PaymentMethod method,
            boolean paidNow) {
        BigDecimal gross = nullToZero(subtotal).add(nullToZero(surcharge));
        BigDecimal voucherDiscount = calculateVoucherDiscount(voucher, gross);

        CustomerProfile profile = user == null ? null : findProfile(em, user.getId());
        int currentPoints = profile == null || profile.getLoyaltyPoints() == null ? 0 : profile.getLoyaltyPoints();
        BigDecimal payableAfterVoucher = gross.subtract(voucherDiscount).max(BigDecimal.ZERO);
        int maxPointsByAmount = payableAfterVoucher.divide(POINT_VALUE, 0, RoundingMode.DOWN).intValue();
        int actualPointsUsed = Math.max(0, Math.min(Math.min(requestedPoints, currentPoints), maxPointsByAmount));
        BigDecimal pointsDiscount = POINT_VALUE.multiply(BigDecimal.valueOf(actualPointsUsed));

        Invoice invoice = new Invoice();
        invoice.setReservation(reservation);
        invoice.setUser(user);
        invoice.setGuestName(reservation == null ? null : reservation.getGuestName());
        invoice.setSubtotal(nullToZero(subtotal));
        invoice.setSurchargeAmount(nullToZero(surcharge));
        invoice.setVoucherDiscount(voucherDiscount);
        invoice.setPointsDiscount(pointsDiscount);
        invoice.setTotalAmount(gross.subtract(voucherDiscount).subtract(pointsDiscount).max(BigDecimal.ZERO));
        invoice.setPaymentMethod(method == null ? PaymentMethod.CASH : method);
        invoice.setPaymentStatus(paidNow ? PaymentStatus.PAID : PaymentStatus.PENDING);
        invoice.setPaidAt(paidNow ? new Date() : null);
        invoice.setIssuedByStaff(staff);
        invoice.setTransactionRef("INV-" + System.currentTimeMillis());
        em.persist(invoice);

        if (profile != null && actualPointsUsed > 0) {
            profile.setLoyaltyPoints(currentPoints - actualPointsUsed);
            em.merge(profile);
        }

        if (voucher != null && voucherDiscount.compareTo(BigDecimal.ZERO) > 0) {
            voucher.setUsedCount((voucher.getUsedCount() == null ? 0 : voucher.getUsedCount()) + 1);
            em.merge(voucher);

            VoucherRedemption redemption = new VoucherRedemption();
            redemption.setVoucher(voucher);
            redemption.setUser(user);
            redemption.setInvoice(invoice);
            em.persist(redemption);
        }

        return invoice;
    }

    public PaymentMethod parsePaymentMethod(String value) {
        try {
            return value == null || value.trim().isEmpty() ? PaymentMethod.CASH : PaymentMethod.valueOf(value.trim());
        } catch (IllegalArgumentException e) {
            return PaymentMethod.CASH;
        }
    }

    public CustomerProfile findProfile(EntityManager em, Long userId) {
        java.util.List<CustomerProfile> profiles = em.createQuery("SELECT p FROM CustomerProfile p WHERE p.user.id = :userId", CustomerProfile.class)
                .setParameter("userId", userId)
                .setMaxResults(1)
                .getResultList();
        return profiles.isEmpty() ? null : profiles.get(0);
    }

    private Voucher findVoucherByCode(EntityManager em, String code) {
        java.util.List<Voucher> vouchers = em.createQuery("SELECT v FROM Voucher v WHERE UPPER(v.voucherCode) = :code", Voucher.class)
                .setParameter("code", code.trim().toUpperCase())
                .setMaxResults(1)
                .getResultList();
        return vouchers.isEmpty() ? null : vouchers.get(0);
    }

    private int safeQty(Integer value) {
        return value == null || value < 1 ? 1 : value;
    }

    private BigDecimal nullToZero(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
