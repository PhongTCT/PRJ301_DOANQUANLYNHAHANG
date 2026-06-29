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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "default_size_id")
    private MenuItemSize defaultSize;
}
