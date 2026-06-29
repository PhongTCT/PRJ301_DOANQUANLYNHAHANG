package dao;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import util.JPAUtil;

public abstract class AbstractDAO<T, K> {
    private final Class<T> entityClass;

    protected AbstractDAO(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    protected boolean executeInTransaction(Consumer<EntityManager> action) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            action.accept(em);
            tx.commit();
            return true;
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public boolean insert(T entity) {
        if (entity == null) {
            return false;
        }
        return executeInTransaction(em -> em.persist(entity));
    }

    public boolean update(T entity) {
        if (entity == null) {
            return false;
        }
        return executeInTransaction(em -> em.merge(entity));
    }

    public T searchById(K id) {
        if (id == null) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(entityClass, id);
        } finally {
            em.close();
        }
    }

    public ArrayList<T> ListAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<T> result = em.createQuery("SELECT e FROM " + entityClass.getSimpleName() + " e", entityClass)
                    .getResultList();
            return new ArrayList<>(result);
        } finally {
            em.close();
        }
    }
}
