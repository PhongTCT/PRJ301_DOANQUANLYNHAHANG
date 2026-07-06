package entity;

import enums.MealTime;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "menu_set")
public class MenuSet implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "set_name", nullable = false, columnDefinition = "NVARCHAR(150)")
    private String setName;

    @Column(name = "set_name_vi", columnDefinition = "NVARCHAR(150)")
    private String setNameVi;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX)")
    private String description;

    @Column(name = "description_vi", columnDefinition = "NVARCHAR(MAX)")
    private String descriptionVi;

    @Enumerated(EnumType.STRING)
    @Column(name = "meal_time", nullable = false, length = 20)
    private MealTime mealTime;

    @Column(name = "original_price", nullable = false)
    private BigDecimal originalPrice = BigDecimal.ZERO;

    @Column(name = "discounted_price", nullable = false)
    private BigDecimal discountedPrice = BigDecimal.ZERO;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "is_available", nullable = false)
    private Boolean isAvailable = true;

    @OneToMany(mappedBy = "menuSet", fetch = FetchType.LAZY)
    private List<MenuSetItem> menuSetItems;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getSetName() { return setName; }
    public void setSetName(String setName) { this.setName = setName; }
    public String getSetNameVi() { return setNameVi; }
    public void setSetNameVi(String setNameVi) { this.setNameVi = setNameVi; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDescriptionVi() { return descriptionVi; }
    public void setDescriptionVi(String descriptionVi) { this.descriptionVi = descriptionVi; }
    public MealTime getMealTime() { return mealTime; }
    public void setMealTime(MealTime mealTime) { this.mealTime = mealTime; }
    public BigDecimal getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(BigDecimal originalPrice) { this.originalPrice = originalPrice; }
    public BigDecimal getDiscountedPrice() { return discountedPrice; }
    public void setDiscountedPrice(BigDecimal discountedPrice) { this.discountedPrice = discountedPrice; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public Boolean getIsAvailable() { return isAvailable; }
    public void setIsAvailable(Boolean isAvailable) { this.isAvailable = isAvailable; }

    public String getSetNameEn() {
        if (setName == null) return "";
        if (setName.contains("Trăng Về Vĩ Dạ")) return "Moon Over Vi Da Set";
        if (setName.contains("Dữ Dội Và Dịu Êm")) return "Fierce and Gentle Set";
        if (setName.contains("Bếp Lửa Ấp Iu")) return "Cozy Hearth Set";
        if (setName.contains("Đoàn Thuyền")) return "Fishing Fleet at Night Set";
        if (setName.contains("Tắt Nắng Buộc Gió")) return "Sunbeams and Wind Set";
        return setName;
    }

    public String getDescriptionEn() {
        if (description == null) return "";
        if (setName != null) {
            if (setName.contains("Trăng Về Vĩ Dạ")) return "A delicate combination of light and fresh flavors, inspired by the peaceful moonlit nights.";
            if (setName.contains("Dữ Dội Và Dịu Êm")) return "A contrasting yet harmonious pairing of bold spices and soothing textures.";
            if (setName.contains("Bếp Lửa Ấp Iu")) return "Warm, comforting dishes that evoke the feeling of a cozy hearth.";
            if (setName.contains("Đoàn Thuyền")) return "A bountiful selection of the freshest premium seafood.";
            if (setName.contains("Tắt Nắng Buộc Gió")) return "A poetic set menu featuring seasonal ingredients and vibrant flavors.";
        }
        return description;
    }

    public List<MenuSetItem> getMenuSetItems() { return menuSetItems; }
    public void setMenuSetItems(List<MenuSetItem> menuSetItems) { this.menuSetItems = menuSetItems; }
}
