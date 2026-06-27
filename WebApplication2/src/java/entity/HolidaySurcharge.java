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
}
