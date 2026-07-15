package entity;

import enums.TableStatus;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "dining_table")
public class DiningTable implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @Column(name = "table_code", nullable = false, unique = true, length = 20)
    private String tableCode;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "base_price", nullable = false)
    private BigDecimal basePrice = BigDecimal.ZERO;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private TableStatus status = TableStatus.AVAILABLE;

    @Version
    @Column(name = "version", nullable = false)
    private Integer version = 0;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "hold_expiration")
    @Temporal(TemporalType.TIMESTAMP)
    private java.util.Date holdExpiration;

    @Column(name = "hold_user_id")
    private Long holdUserId;

    @OneToMany(mappedBy = "diningTable", fetch = FetchType.LAZY)
    private List<ReservationTable> reservationTables;

    public DiningTable() {
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Room getRoom() { return room; }
    public void setRoom(Room room) { this.room = room; }
    public String getTableCode() { return tableCode; }
    public void setTableCode(String tableCode) { this.tableCode = tableCode; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
    public BigDecimal getBookingFee() {
        BigDecimal total = basePrice != null ? basePrice : BigDecimal.ZERO;
        if (room != null) {
            if (room.getPricePerSession() != null) {
                total = total.add(room.getPricePerSession());
            }
            if (room.getArea() != null && room.getArea().getPriceModifier() != null) {
                total = total.add(room.getArea().getPriceModifier());
            }
        }
        return total;
    }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public TableStatus getStatus() { return status; }
    public void setStatus(TableStatus status) { this.status = status; }
    public Integer getVersion() { return version; }
    public Boolean getIsActive() { return isActive; }
    public boolean isActive() { return Boolean.TRUE.equals(isActive); }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    public java.util.Date getHoldExpiration() { return holdExpiration; }
    public void setHoldExpiration(java.util.Date holdExpiration) { this.holdExpiration = holdExpiration; }
    public Long getHoldUserId() { return holdUserId; }
    public void setHoldUserId(Long holdUserId) { this.holdUserId = holdUserId; }
}
