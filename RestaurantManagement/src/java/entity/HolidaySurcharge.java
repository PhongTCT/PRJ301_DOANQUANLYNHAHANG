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

    public String getHolidayNameEn() {
        if (holidayName == null) return "";
        String lower = holidayName.toLowerCase();
        if (lower.contains("tết dương lịch") || lower.contains("tt dng l<ch")) return "New Year's Day";
        if (lower.contains("mùng 1 tết nguyên đán") || lower.contains("mA1ng 1")) return "Lunar New Year (1st Day)";
        if (lower.contains("mùng 2 tết nguyên đán") || lower.contains("mA1ng 2")) return "Lunar New Year (2nd Day)";
        if (lower.contains("mùng 3 tết nguyên đán") || lower.contains("mA1ng 3")) return "Lunar New Year (3rd Day)";
        if (lower.contains("tết nguyên đán") || lower.contains("tt nguyAn")) return "Lunar New Year";
        if (lower.contains("quốc tế phụ nữ") || lower.contains("qu`c t ph n_")) return "International Women's Day";
        if (lower.contains("phụ nữ việt nam") || lower.contains("ph n_ vit nam")) return "Vietnamese Women's Day";
        if (lower.contains("giỗ tổ hùng vương") || lower.contains("gi- t")) return "Hung Kings' Commemoration Day";
        if (lower.contains("giải phóng miền nam") || lower.contains("gii phA3ng")) return "Reunification Day";
        if (lower.contains("quốc tế lao động") || lower.contains("lao `Tng")) return "International Workers' Day";
        if (lower.contains("quốc khánh") || lower.contains("qu`c khAnh")) return "National Day";
        if (lower.contains("giáng sinh") || lower.contains("noel") || lower.contains("giAng sinh")) return "Christmas Day";
        return holidayName;
    }
}
