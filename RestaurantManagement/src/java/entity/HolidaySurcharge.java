package entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "holiday_surcharge")
public class HolidaySurcharge implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "holiday_name", nullable = false, columnDefinition = "NVARCHAR(100)")
    private String holidayName;

    @Column(name = "surcharge_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date surchargeDate;

    @Column(name = "surcharge_percent", nullable = false)
    private BigDecimal surchargePercent = BigDecimal.ZERO;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getHolidayName() { return holidayName; }
    public void setHolidayName(String holidayName) { this.holidayName = holidayName; }
    public Date getSurchargeDate() { return surchargeDate; }
    public void setSurchargeDate(Date surchargeDate) { this.surchargeDate = surchargeDate; }
    public BigDecimal getSurchargePercent() { return surchargePercent; }
    public void setSurchargePercent(BigDecimal surchargePercent) { this.surchargePercent = surchargePercent; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }
}
