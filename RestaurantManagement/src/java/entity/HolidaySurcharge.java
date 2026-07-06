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
        if (holidayName.contains("Tết Dương Lịch")) return "New Year's Day";
        if (holidayName.contains("Mùng 1 Tết Nguyên Đán")) return "Lunar New Year (1st Day)";
        if (holidayName.contains("Mùng 2 Tết Nguyên Đán")) return "Lunar New Year (2nd Day)";
        if (holidayName.contains("Mùng 3 Tết Nguyên Đán")) return "Lunar New Year (3rd Day)";
        if (holidayName.contains("Tết Nguyên Đán")) return "Lunar New Year";
        if (holidayName.contains("Quốc tế Phụ nữ")) return "International Women's Day";
        if (holidayName.contains("Giỗ Tổ Hùng Vương")) return "Hung Kings' Commemoration Day";
        if (holidayName.contains("Giải phóng Miền Nam")) return "Reunification Day";
        if (holidayName.contains("Quốc tế Lao động")) return "International Workers' Day";
        if (holidayName.contains("Quốc khánh Việt Nam") || holidayName.contains("Quốc khánh")) return "National Day";
        return holidayName;
    }
}
