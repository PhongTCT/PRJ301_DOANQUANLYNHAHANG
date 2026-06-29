package entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "menu_item")
public class MenuItem implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id", nullable = false)
    private MenuCategory category;

    @Column(name = "item_name", nullable = false, columnDefinition = "NVARCHAR(150)")
    private String itemName;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "base_price", nullable = false)
    private BigDecimal basePrice = BigDecimal.ZERO;

    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @OneToMany(mappedBy = "menuItem", fetch = FetchType.LAZY)
    private List<MenuItemSize> sizes;

    @OneToMany(mappedBy = "menuItem", fetch = FetchType.LAZY)
    private List<MenuSetItem> menuSetItems;

    public MenuItem() {
    }

    @PrePersist
    protected void onCreate() {
        createdAt = new Date();
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public MenuCategory getCategory() { return category; }
    public void setCategory(MenuCategory category) { this.category = category; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
    public Boolean getIsAvailable() { return isAvailable; }
    public boolean isAvailable() { return Boolean.TRUE.equals(isAvailable); }
    public void setIsAvailable(Boolean isAvailable) { this.isAvailable = isAvailable; }
    public Date getCreatedAt() { return createdAt; }

    public String getItemNameEn() {
        if (itemName == null) return "";
        if (itemName.contains("Gỏi Ngó Sen") || itemName.contains("Lotus")) return "Lotus Stem Salad with Shrimp & Pork";
        if (itemName.contains("Súp Măng Tây") || itemName.contains("Crab")) return "Crab & Green Asparagus Soup";
        if (itemName.contains("Bò Úc Nướng") || itemName.contains("Beef")) return "Grilled Australian Beef Tenderloin";
        if (itemName.contains("Cá Hồi") || itemName.contains("Salmon")) return "Pan Seared Salmon with Passion Fruit";
        if (itemName.contains("Nước Cam") || itemName.contains("Orange")) return "Fresh Squeezed Orange Juice";
        if (itemName.contains("Rượu Vang") || itemName.contains("Wine")) return "Imported Bordeaux Red Wine";
        return itemName;
    }

    public String getDescriptionEn() {
        if (description == null) return "";
        if (itemName != null) {
            if (itemName.contains("Gỏi Ngó Sen") || itemName.contains("Lotus")) return "Crunchy lotus stem salad tossed with fresh tiger shrimp and savory pork belly";
            if (itemName.contains("Súp Măng Tây") || itemName.contains("Crab")) return "Hot rich soup served with shredded fresh crab meat and tender green asparagus";
            if (itemName.contains("Bò Úc Nướng") || itemName.contains("Beef")) return "Premium Australian beef tenderloin grilled to perfection with rich black pepper sauce";
            if (itemName.contains("Cá Hồi") || itemName.contains("Salmon")) return "Fresh Atlantic salmon seared with golden butter and tangy passion fruit sauce";
            if (itemName.contains("Nước Cam") || itemName.contains("Orange")) return "100% fresh squeezed sweet orange juice served chilled";
            if (itemName.contains("Rượu Vang") || itemName.contains("Wine")) return "Premium French red wine with deep berry aroma and smooth finish";
        }
        return description;
    }
}
