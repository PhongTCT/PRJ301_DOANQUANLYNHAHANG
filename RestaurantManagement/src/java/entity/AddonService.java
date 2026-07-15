package entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "addon_service")
public class AddonService implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "service_name", nullable = false, columnDefinition = "NVARCHAR(150)")
    private String serviceName;

    @Column(name = "service_name_vi", columnDefinition = "NVARCHAR(150)")
    private String serviceNameVi;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Column(name = "description_vi", columnDefinition = "NVARCHAR(MAX)")
    private String descriptionVi;

    @Column(name = "price", nullable = false)
    private BigDecimal price = BigDecimal.ZERO;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable = true;

    @OneToMany(mappedBy = "addonService", fetch = FetchType.LAZY)
    private List<ReservationAddon> reservationAddons;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    public String getServiceNameVi() { return serviceNameVi; }
    public void setServiceNameVi(String serviceNameVi) { this.serviceNameVi = serviceNameVi; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDescriptionVi() { return descriptionVi; }
    public void setDescriptionVi(String descriptionVi) { this.descriptionVi = descriptionVi; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public Boolean getIsAvailable() { return isAvailable; }
    public void setIsAvailable(Boolean isAvailable) { this.isAvailable = isAvailable; }
    public List<ReservationAddon> getReservationAddons() { return reservationAddons; }
    public void setReservationAddons(List<ReservationAddon> reservationAddons) { this.reservationAddons = reservationAddons; }
}
