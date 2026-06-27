package dao;

import entity.User;
import enums.UserStatus;
import util.JPAUtil;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

public class UserDAO extends AbstractDAO<User, Long> {

    public UserDAO() {
        super(User.class);
    }

    public boolean remove(User t) {
        if (t == null || t.getId() == null || t.getId() <= 0) return false;
        return executeInTransaction(em -> {
            User user = em.find(User.class, t.getId());
            if (user != null) {
                user.setStatus(UserStatus.BANNED);
                em.merge(user);
            }
        });
    }

    @Override
    public ArrayList<User> ListAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u", User.class);
            return new ArrayList<>(query.getResultList());
        } finally {
            em.close();
        }
    }

    public User searchByEmail(String email) {
        if (email == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }
}
