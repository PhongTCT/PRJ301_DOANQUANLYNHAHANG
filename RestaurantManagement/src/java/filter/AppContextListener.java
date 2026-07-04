package filter;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import util.EmailUtil;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import dao.ReservationDAO;
import dao.DiningTableDAO;
import entity.Reservation;
import entity.ReservationTable;
import enums.ReservationStatus;
import enums.TableStatus;

public class AppContextListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        EmailUtil.init(sce.getServletContext());
        
        // Start the Auto-cancellation job every 5 minutes
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            try {
                ReservationDAO resDao = new ReservationDAO();
                DiningTableDAO tableDao = new DiningTableDAO();
                java.util.List<Reservation> noShows = resDao.findNoShowCandidates();
                
                if (!noShows.isEmpty()) {
                    for (Reservation r : noShows) {
                        r.setStatus(ReservationStatus.NO_SHOW);
                        resDao.update(r);
                        
                        // Free the tables
                        for (ReservationTable rt : r.getReservationTables()) {
                            if (rt.getDiningTable() != null) {
                                rt.getDiningTable().setStatus(TableStatus.AVAILABLE);
                                tableDao.update(rt.getDiningTable());
                            }
                        }
                    }
                    System.out.println("[Auto-Cancellation] Marked " + noShows.size() + " reservations as NO_SHOW.");
                }
            } catch (Exception e) {
                System.err.println("[Auto-Cancellation] Error executing task: " + e.getMessage());
            }
        }, 10, 30, TimeUnit.SECONDS);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
    }
}
