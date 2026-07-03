import dao.ReservationDAO;
import entity.Reservation;
import java.util.List;

public class TestJPA {
    public static void main(String[] args) {
        try {
            ReservationDAO dao = new ReservationDAO();
            List<Reservation> list = dao.findByUserId(3L);
            System.out.println("Found " + list.size() + " reservations.");
            for (Reservation r : list) {
                System.out.println("Reservation ID: " + r.getId());
                System.out.println("Tables count: " + r.getReservationTables().size());
                System.out.println("Menu Items count: " + r.getReservationMenuItems().size());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
