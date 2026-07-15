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

    @Column(name = "min_point_threshold", nullable = false)
    private Integer minPointThreshold = 0;

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
    public void setId(Integer id) { this.id = id; }
    public RankName getRankName() { return rankName; }
    public void setRankName(RankName rankName) { this.rankName = rankName; }
    public Integer getMinPointThreshold() { return minPointThreshold; }
    public void setMinPointThreshold(Integer minPointThreshold) { this.minPointThreshold = minPointThreshold; }
    public BigDecimal getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
    public Integer getPointsPerThousandVnd() { return pointsPerThousandVnd; }
    public void setPointsPerThousandVnd(Integer pointsPerThousandVnd) { this.pointsPerThousandVnd = pointsPerThousandVnd; }
    public Boolean getCanBookVip() { return canBookVip; }
    public void setCanBookVip(Boolean canBookVip) { this.canBookVip = canBookVip; }
    public Boolean getCanBookVvip() { return canBookVvip; }
    public void setCanBookVvip(Boolean canBookVvip) { this.canBookVvip = canBookVvip; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
    public List<CustomerProfile> getProfiles() { return profiles; }
    public void setProfiles(List<CustomerProfile> profiles) { this.profiles = profiles; }
}
