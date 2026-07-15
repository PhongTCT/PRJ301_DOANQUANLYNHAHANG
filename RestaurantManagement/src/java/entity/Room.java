package entity;

import enums.RoomType;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "room")
public class Room implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "area_id", nullable = false)
    private Area area;

    @Column(name = "room_name", nullable = false, columnDefinition = "NVARCHAR(100)")
    private String roomName;

    @Enumerated(EnumType.STRING)
    @Column(name = "room_type", nullable = false, length = 20)
    private RoomType roomType;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "price_per_session", nullable = false)
    private BigDecimal pricePerSession = BigDecimal.ZERO;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @OneToMany(mappedBy = "room", fetch = FetchType.LAZY)
    private List<DiningTable> diningTables;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Area getArea() { return area; }
    public void setArea(Area area) { this.area = area; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    public BigDecimal getPricePerSession() { return pricePerSession; }
    public void setPricePerSession(BigDecimal pricePerSession) { this.pricePerSession = pricePerSession; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    public List<DiningTable> getDiningTables() { return diningTables; }
    public void setDiningTables(List<DiningTable> diningTables) { this.diningTables = diningTables; }

    public String getRoomNameEn() {
        if (roomName == null) return "";
        if (roomName.contains("Khu chung") || roomName.contains("Standard")) return "Standard Dining Area";
        if (roomName.contains("VIP") || roomName.contains("Vàng") || roomName.contains("Golden")) return "Golden VIP Room";
        if (roomName.contains("Sân Vườn") || roomName.contains("Garden")) return "Rose Garden Patio";
        if (roomName.contains("Biệt Thự") || roomName.contains("Villa")) return "Royal VVIP Villa";
        return roomName;
    }
}
