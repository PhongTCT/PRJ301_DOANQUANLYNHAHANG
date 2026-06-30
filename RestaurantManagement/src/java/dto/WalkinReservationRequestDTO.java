package dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class WalkinReservationRequestDTO implements Serializable {
    private String guestName;
    private String guestPhone;
    private Date reservationDate;
    private String reservationTime;
    private Integer adultsCount;
    private Integer childrenCount;
    private Boolean hasChildren;
    private Integer eventTypeId;
    private List<Integer> tableIds;

    // Getters and Setters
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    
    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }
    
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
    
    public List<Integer> getTableIds() { return tableIds; }
    public void setTableIds(List<Integer> tableIds) { this.tableIds = tableIds; }
}
