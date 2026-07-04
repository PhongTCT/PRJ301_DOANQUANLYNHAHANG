package service;

import dao.NotificationDAO;
import entity.Notification;
import entity.User;
import java.util.ArrayList;

public class NotificationService {

    private final NotificationDAO notificationDAO = new NotificationDAO();

    public void createNotification(User user, String title, String message) {
        Notification n = new Notification();
        n.setUser(user);
        n.setTitle(title);
        n.setMessage(message);
        n.setIsRead(false);
        notificationDAO.insert(n);
    }

    public ArrayList<Notification> getRecentNotifications(User user, int max) {
        if (user == null || user.getId() == null) return new ArrayList<>();
        return notificationDAO.findByUserId(user.getId(), max);
    }

    public long getUnreadCount(User user) {
        if (user == null || user.getId() == null) return 0;
        return notificationDAO.countUnread(user.getId());
    }

    public void markAsRead(Long notificationId, User user) {
        if (user == null || user.getId() == null) return;
        notificationDAO.markAsRead(notificationId, user.getId());
    }

    public void markAllAsRead(User user) {
        if (user == null || user.getId() == null) return;
        notificationDAO.markAllAsRead(user.getId());
    }
}
