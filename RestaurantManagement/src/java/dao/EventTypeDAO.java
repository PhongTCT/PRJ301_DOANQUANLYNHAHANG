package dao;

import entity.EventType;

public class EventTypeDAO extends AbstractDAO<EventType, Integer> {
    public EventTypeDAO() { super(EventType.class); }

    public java.util.List<EventType> findActiveEventTypes() {
        javax.persistence.EntityManager em = util.JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT e FROM EventType e WHERE e.isActive = true", EventType.class).getResultList();
        } finally {
            em.close();
        }
    }
}
