package dto;

import entity.Reservation;
import java.io.Serializable;
import java.util.Date;

public class ReservationResponseDTO implements Serializable {
    private Long id;
    private String guestName;
    private String guestPhone;
    private Date reservationDate;
    private String reservationTime;
    private Integer adultsCount;
    private Integer childrenCount;
    private String status;
    
    public ReservationResponseDTO(Reservation r) {
        this.id = r.getId();
        this.guestName = r.getGuestName();
        this.guestPhone = r.getGuestPhone();
        this.reservationDate = r.getReservationDate();
        this.reservationTime = r.getReservationTime() != null ? r.getReservationTime().toString() : null;
        this.adultsCount = r.getAdultsCount();
        this.childrenCount = r.getChildrenCount();
        this.status = r.getStatus() != null ? r.getStatus().name() : null;
    }

    public Long getId() { return id; }
    public String getGuestName() { return guestName; }
    public String getGuestPhone() { return guestPhone; }
    public Date getReservationDate() { return reservationDate; }
    public String getReservationTime() { return reservationTime; }
    public Integer getAdultsCount() { return adultsCount; }
    public Integer getChildrenCount() { return childrenCount; }
    public String getStatus() { return status; }
}
