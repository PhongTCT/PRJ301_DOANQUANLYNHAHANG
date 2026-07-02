package dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class BookingDraft implements Serializable {
    // Step 1: Info
    private Date reservationDate;
    private String reservationTime;
    private Integer adultsCount;
    private Integer childrenCount;
    private Boolean hasChildren;
    private Integer eventTypeId;
    private Boolean hasSurcharge;
    private java.math.BigDecimal surchargePercent;

    // Step 2: Tables
    private List<Integer> selectedTableIds = new ArrayList<>();

    // Step 3: Menus and Addons
    private List<CartItemDTO> menuItems = new ArrayList<>();
    private List<CartAddonDTO> addons = new ArrayList<>();

    // Getters and Setters
    public Date getReservationDate() { return reservationDate; }
    public void setReservationDate(Date reservationDate) { this.reservationDate = reservationDate; }
    public String getReservationTime() { return reservationTime; }
    public void setReservationTime(String reservationTime) { this.reservationTime = reservationTime; }
    public Integer getAdultsCount() { return adultsCount; }
    public void setAdultsCount(Integer adultsCount) { this.adultsCount = adultsCount; }
    public Integer getChildrenCount() { return childrenCount; }
    public void setChildrenCount(Integer childrenCount) { this.childrenCount = childrenCount; }
    public Boolean getHasChildren() { return hasChildren; }
    public void setHasChildren(Boolean hasChildren) { this.hasChildren = hasChildren; }
    public Integer getEventTypeId() { return eventTypeId; }
    public void setEventTypeId(Integer eventTypeId) { this.eventTypeId = eventTypeId; }
    public Boolean getHasSurcharge() { return hasSurcharge; }
    public void setHasSurcharge(Boolean hasSurcharge) { this.hasSurcharge = hasSurcharge; }
    public java.math.BigDecimal getSurchargePercent() { return surchargePercent; }
    public void setSurchargePercent(java.math.BigDecimal surchargePercent) { this.surchargePercent = surchargePercent; }
    public List<Integer> getSelectedTableIds() { return selectedTableIds; }
    public void setSelectedTableIds(List<Integer> selectedTableIds) { this.selectedTableIds = selectedTableIds; }
    public List<CartItemDTO> getMenuItems() { return menuItems; }
    public void setMenuItems(List<CartItemDTO> menuItems) { this.menuItems = menuItems; }
    public List<CartAddonDTO> getAddons() { return addons; }
    public void setAddons(List<CartAddonDTO> addons) { this.addons = addons; }

    public static class CartItemDTO implements Serializable {
        private Integer menuItemId;
        private Integer quantity;
        private String note;
        public Integer getMenuItemId() { return menuItemId; }
        public void setMenuItemId(Integer menuItemId) { this.menuItemId = menuItemId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
        public String getNote() { return note; }
        public void setNote(String note) { this.note = note; }
    }

    public static class CartAddonDTO implements Serializable {
        private Integer addonId;
        private Integer quantity;
        public Integer getAddonId() { return addonId; }
        public void setAddonId(Integer addonId) { this.addonId = addonId; }
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }
}
