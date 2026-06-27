package dao;

import entity.AuditLog;

public class AuditLogDAO extends AbstractDAO<AuditLog, Long> {
    public AuditLogDAO() { super(AuditLog.class); }
}
