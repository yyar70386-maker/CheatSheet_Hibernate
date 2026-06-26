package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.AuditLogEntity;

public interface AuditLogRepository {

    Integer save(AuditLogEntity auditLog);

    List<AuditLogEntity> findRecent(int limit);
}
