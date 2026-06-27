package entity;

import enums.MealTime;
import enums.MenuCategoryType;
import java.io.Serializable;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "menu_category")
public class MenuCategory implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "category_name", nullable = false, columnDefinition = "NVARCHAR(100)")
    private String categoryName;

    @Enumerated(EnumType.STRING)
    @Column(name = "meal_time", nullable = false, length = 20)
    private MealTime mealTime = MealTime.ALL_DAY;

    @Enumerated(EnumType.STRING)
    @Column(name = "category_type", nullable = false, length = 20)
    private MenuCategoryType categoryType;

    @Column(name = "sort_order", nullable = false)
    private Integer sortOrder = 1;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<MenuItem> menuItems;

    public Integer getId() { return id; }
    public String getCategoryName() { return categoryName; }
    public MealTime getMealTime() { return mealTime; }
    public MenuCategoryType getCategoryType() { return categoryType; }

    public String getCategoryNameEn() {
        if (categoryName == null) return "";
        if (categoryName.contains("Khai Vị") || categoryName.contains("Appetizer")) return "Appetizer";
        if (categoryName.contains("Chính") || categoryName.contains("Main")) return "Main Course";
        if (categoryName.contains("Tráng Miệng") || categoryName.contains("Dessert")) return "Dessert";
        if (categoryName.contains("Uống") || categoryName.contains("Drink")) return "Drink";
        return categoryName;
    }
}
