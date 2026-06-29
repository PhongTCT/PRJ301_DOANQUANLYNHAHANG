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
}
