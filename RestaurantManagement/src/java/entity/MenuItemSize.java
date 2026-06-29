package entity;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.*;

@Entity
@Table(name = "menu_item_size")
public class MenuItemSize implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;

    @Column(name = "size_name", nullable = false, columnDefinition = "NVARCHAR(50)")
    private String sizeName;

    @Column(name = "price_modifier", nullable = false)
    private BigDecimal priceModifier = BigDecimal.ZERO;
}
