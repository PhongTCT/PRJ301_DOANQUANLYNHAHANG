package dto;

import java.io.Serializable;
import java.util.Date;

public class BookingDraft implements Serializable {
    private Date reservationDate;
    private String reservationTime;
    private Integer adultsCount;
    private Integer childrenCount;
    private Integer eventTypeId;

    public Date getReservationDate() { return reservationDate; }
    public void setReservationDate(Date reservationDate) { this.reservationDate = reservationDate; }
    public String getReservationTime() { return reservationTime; }
    public void setReservationTime(String reservationTime) { this.reservationTime = reservationTime; }
    public Integer getAdultsCount() { return adultsCount; }
    public void setAdultsCount(Integer adultsCount) { this.adultsCount = adultsCount; }
    public Integer getChildrenCount() { return childrenCount; }
    public void setChildrenCount(Integer childrenCount) { this.childrenCount = childrenCount; }
    public Integer getEventTypeId() { return eventTypeId; }
    public void setEventTypeId(Integer eventTypeId) { this.eventTypeId = eventTypeId; }
}
