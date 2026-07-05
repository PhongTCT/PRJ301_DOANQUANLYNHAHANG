package entity;

import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name = "menu_set_item")
public class MenuSetItem implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_set_id", nullable = false)
    private MenuSet menuSet;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;

    @Column(name = "quantity", nullable = false)
    private Integer quantity = 1;

    @Column(name = "course_name", columnDefinition = "NVARCHAR(150)")
    private String courseName;

    @Column(name = "course_name_vi", columnDefinition = "NVARCHAR(150)")
    private String courseNameVi;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "default_size_id")
    private MenuItemSize defaultSize;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public MenuSet getMenuSet() { return menuSet; }
    public void setMenuSet(MenuSet menuSet) { this.menuSet = menuSet; }
    public MenuItem getMenuItem() { return menuItem; }
    public void setMenuItem(MenuItem menuItem) { this.menuItem = menuItem; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public String getCourseNameVi() { return courseNameVi; }
    public void setCourseNameVi(String courseNameVi) { this.courseNameVi = courseNameVi; }
    public MenuItemSize getDefaultSize() { return defaultSize; }
    public void setDefaultSize(MenuItemSize defaultSize) { this.defaultSize = defaultSize; }
}
