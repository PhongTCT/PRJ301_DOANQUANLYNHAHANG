package entity;

import enums.RankName;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import javax.persistence.*;

@Entity
@Table(name = "customer_rank_config")
public class CustomerRankConfig implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Enumerated(EnumType.STRING)
    @Column(name = "rank_name", nullable = false, unique = true, length = 20)
    private RankName rankName;

    @Column(name = "min_spend_threshold", nullable = false)
    private BigDecimal minSpendThreshold = BigDecimal.ZERO;

    @Column(name = "discount_percent", nullable = false)
    private BigDecimal discountPercent = BigDecimal.ZERO;

    @Column(name = "points_per_thousand_vnd", nullable = false)
    private Integer pointsPerThousandVnd = 1;

    @Column(name = "can_book_vip", nullable = false)
    private Boolean canBookVip = false;

    @Column(name = "can_book_vvip", nullable = false)
    private Boolean canBookVvip = false;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @OneToMany(mappedBy = "currentRank", fetch = FetchType.LAZY)
    private List<CustomerProfile> profiles;

    public Integer getId() { return id; }
    public RankName getRankName() { return rankName; }
}
