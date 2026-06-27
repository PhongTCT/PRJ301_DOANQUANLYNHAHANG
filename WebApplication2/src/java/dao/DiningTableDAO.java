package dao;

import entity.DiningTable;
import util.JPAUtil;
import java.util.ArrayList;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

public class DiningTableDAO extends AbstractDAO<DiningTable, Integer> {

    public DiningTableDAO() {
        super(DiningTable.class);
    }

    @Override
    public ArrayList<DiningTable> ListAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<DiningTable> query = em.createQuery(
                    "SELECT d FROM DiningTable d WHERE d.isActive = true ORDER BY d.room.roomName, d.tableCode",
                    DiningTable.class);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }
}
