package entity;

import enums.ReservationStatus;
import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Time;
import java.util.Date;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "reservation")
public class Reservation implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "guest_name", columnDefinition = "NVARCHAR(100)")
    private String guestName;

    @Column(name = "guest_phone", length = 20)
    private String guestPhone;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "event_type_id", nullable = false)
    private EventType eventType;

    @Column(name = "reservation_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date reservationDate;

    @Column(name = "reservation_time", nullable = false)
    private Time reservationTime;

    @Column(name = "adults_count", nullable = false)
    private Integer adultsCount = 1;

    @Column(name = "children_count", nullable = false)
    private Integer childrenCount = 0;

    @Column(name = "has_children", nullable = false)
    private Boolean hasChildren = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private ReservationStatus status = ReservationStatus.PENDING;

    @Column(name = "deposit_amount", nullable = false)
    private BigDecimal depositAmount = BigDecimal.ZERO;

    @Column(name = "deposit_paid", nullable = false)
    private Boolean depositPaid = false;

    @Column(name = "is_online", nullable = false)
    private Boolean isOnline = true;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by_staff_id")
    private User createdByStaff;

    @Column(name = "checkin_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date checkinAt;

    @Column(name = "has_surcharge", nullable = false)
    private Boolean hasSurcharge = false;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Column(name = "updated_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedAt;

    @OneToMany(mappedBy = "reservation", fetch = FetchType.LAZY)
    private List<ReservationTable> reservationTables;

    @OneToMany(mappedBy = "reservation", fetch = FetchType.LAZY)
    private List<ReservationMenuItem> reservationMenuItems;

    @OneToMany(mappedBy = "reservation", fetch = FetchType.LAZY)
    private List<ReservationAddon> reservationAddons;

    @OneToOne(mappedBy = "reservation", fetch = FetchType.LAZY)
    private Invoice invoice;

    @PrePersist
    protected void onCreate() { Date now = new Date(); createdAt = now; updatedAt = now; }

    @PreUpdate
    protected void onUpdate() { updatedAt = new Date(); }

    public Long getId() { return id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    public String getGuestPhone() { return guestPhone; }
    public void setGuestPhone(String guestPhone) { this.guestPhone = guestPhone; }
    public EventType getEventType() { return eventType; }
    public void setEventType(EventType eventType) { this.eventType = eventType; }
    public Date getReservationDate() { return reservationDate; }
    public void setReservationDate(Date reservationDate) { this.reservationDate = reservationDate; }
    public Time getReservationTime() { return reservationTime; }
    public void setReservationTime(Time reservationTime) { this.reservationTime = reservationTime; }
    public Integer getAdultsCount() { return adultsCount; }
    public void setAdultsCount(Integer adultsCount) { this.adultsCount = adultsCount; }
    public Integer getChildrenCount() { return childrenCount; }
    public void setChildrenCount(Integer childrenCount) { this.childrenCount = childrenCount; }
    public Boolean getHasChildren() { return hasChildren; }
    public void setHasChildren(Boolean hasChildren) { this.hasChildren = hasChildren; }
    public ReservationStatus getStatus() { return status; }
    public void setStatus(ReservationStatus status) { this.status = status; }
    public BigDecimal getDepositAmount() { return depositAmount; }
    public void setDepositAmount(BigDecimal depositAmount) { this.depositAmount = depositAmount; }
    public Boolean getDepositPaid() { return depositPaid; }
    public void setDepositPaid(Boolean depositPaid) { this.depositPaid = depositPaid; }
    public Boolean getIsOnline() { return isOnline; }
    public void setIsOnline(Boolean isOnline) { this.isOnline = isOnline; }
    public User getCreatedByStaff() { return createdByStaff; }
    public void setCreatedByStaff(User createdByStaff) { this.createdByStaff = createdByStaff; }
    public Date getCheckinAt() { return checkinAt; }
    public void setCheckinAt(Date checkinAt) { this.checkinAt = checkinAt; }
    public Boolean getHasSurcharge() { return hasSurcharge; }
    public void setHasSurcharge(Boolean hasSurcharge) { this.hasSurcharge = hasSurcharge; }
    public Date getCreatedAt() { return createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
}
