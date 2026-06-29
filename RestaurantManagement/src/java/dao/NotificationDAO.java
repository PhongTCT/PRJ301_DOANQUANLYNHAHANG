package dao;

import entity.Notification;

public class NotificationDAO extends AbstractDAO<Notification, Long> {
    public NotificationDAO() { super(Notification.class); }
}
