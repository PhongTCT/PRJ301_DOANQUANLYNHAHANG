package dao;

import entity.User;
import enums.UserRole;
import enums.UserStatus;
import util.JPAUtil;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
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

    public User searchByUsername(String username) {
        if (username == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.username = :username", User.class);
            query.setParameter("username", username);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public User searchByGoogleId(String googleId) {
        if (googleId == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.googleId = :googleId", User.class);
            query.setParameter("googleId", googleId);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public User searchByPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.phone = :phone", User.class);
            query.setParameter("phone", phone.trim());
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public User findOrCreateGoogleUser(String googleId, String email, String fullName, String avatarUrl) {
        return findOrCreateGoogleUser(googleId, email, fullName, avatarUrl, null, null);
    }

    public User findOrCreateGoogleUser(String googleId, String email, String fullName,
            String avatarUrl, String phone, Date dateOfBirth) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            User user = findByGoogleId(em, googleId);
            if (user == null) {
                user = findByEmail(em, email);
            }

            if (user == null) {
                user = new User();
                user.setUsername(email.substring(0, email.indexOf('@')));
                user.setEmail(email);
                user.setFullName(fullName == null || fullName.trim().isEmpty() ? email : fullName.trim());
                user.setRole(UserRole.CUSTOMER);
                user.setStatus(UserStatus.ACTIVE);
                user.setEmailVerified(true);
                user.setGoogleId(googleId);
                user.setAvatarUrl(avatarUrl);
                user.setPhone(phone);
                user.setDateOfBirth(dateOfBirth);
                em.persist(user);
            } else {
                user.setGoogleId(googleId);
                if (fullName != null && !fullName.trim().isEmpty()) {
                    user.setFullName(fullName.trim());
                }
                if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
                    user.setAvatarUrl(avatarUrl.trim());
                }
                if (phone != null && !phone.trim().isEmpty()) {
                    user.setPhone(phone.trim());
                }
                if (dateOfBirth != null) {
                    user.setDateOfBirth(dateOfBirth);
                }
                user.setEmailVerified(true);
                if (user.getStatus() != UserStatus.BANNED) {
                    user.setStatus(UserStatus.ACTIVE);
                }
                user = em.merge(user);
            }

            tx.commit();
            return user;
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public User findOrCreateFacebookUser(String facebookId, String email, String fullName,
            String avatarUrl, String phone, Date dateOfBirth) {
        String facebookKey = "facebook:" + facebookId;
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            User user = findByGoogleId(em, facebookKey);
            if (user == null) {
                user = findByEmail(em, email);
            }

            if (user == null) {
                user = new User();
                user.setUsername(email.substring(0, email.indexOf('@')));
                user.setEmail(email);
                user.setFullName(fullName == null || fullName.trim().isEmpty() ? email : fullName.trim());
                user.setRole(UserRole.CUSTOMER);
                user.setStatus(UserStatus.ACTIVE);
                user.setEmailVerified(true);
                user.setGoogleId(facebookKey);
                user.setAvatarUrl(avatarUrl);
                user.setPhone(phone);
                user.setDateOfBirth(dateOfBirth);
                em.persist(user);
            } else {
                if (user.getGoogleId() == null || user.getGoogleId().trim().isEmpty()) {
                    user.setGoogleId(facebookKey);
                }
                if (fullName != null && !fullName.trim().isEmpty()) {
                    user.setFullName(fullName.trim());
                }
                if (avatarUrl != null && !avatarUrl.trim().isEmpty()) {
                    user.setAvatarUrl(avatarUrl.trim());
                }
                if (phone != null && !phone.trim().isEmpty()) {
                    user.setPhone(phone.trim());
                }
                if (dateOfBirth != null) {
                    user.setDateOfBirth(dateOfBirth);
                }
                user.setEmailVerified(true);
                if (user.getStatus() != UserStatus.BANNED) {
                    user.setStatus(UserStatus.ACTIVE);
                }
                user = em.merge(user);
            }

            tx.commit();
            return user;
        } catch (RuntimeException e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public User searchByUsernameOrEmail(String usernameOrEmail) {
        if (usernameOrEmail == null) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.username = :value OR u.email = :value", User.class);
            query.setParameter("value", usernameOrEmail);
            List<User> list = query.getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    private User findByGoogleId(EntityManager em, String googleId) {
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.googleId = :googleId", User.class);
        query.setParameter("googleId", googleId);
        List<User> list = query.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }

    private User findByEmail(EntityManager em, String email) {
        TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
        query.setParameter("email", email);
        List<User> list = query.getResultList();
        return list.isEmpty() ? null : list.get(0);
    }
}
