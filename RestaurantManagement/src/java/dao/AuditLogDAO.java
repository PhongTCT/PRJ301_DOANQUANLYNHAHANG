package dao;

import entity.AuditLog;

import entity.User;

public class AuditLogDAO extends AbstractDAO<AuditLog, Long> {
    public AuditLogDAO() { super(AuditLog.class); }

    public void logAction(User user, String action, String entityType, Long entityId, String oldValue, String newValue, String ipAddress) {
        AuditLog log = new AuditLog();
        log.setUser(user);
        log.setAction(action);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setOldValue(oldValue);
        log.setNewValue(newValue);
        log.setIpAddress(ipAddress);
        this.insert(log);
    }
}
