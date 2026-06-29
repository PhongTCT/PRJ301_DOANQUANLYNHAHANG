package entity;

import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name = "reservation_table")
public class ReservationTable implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "reservation_id", nullable = false)
    private Reservation reservation;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "dining_table_id", nullable = false)
    private DiningTable diningTable;

    public Long getId() { return id; }
    public Reservation getReservation() { return reservation; }
    public void setReservation(Reservation reservation) { this.reservation = reservation; }
    public DiningTable getDiningTable() { return diningTable; }
    public void setDiningTable(DiningTable diningTable) { this.diningTable = diningTable; }
}
