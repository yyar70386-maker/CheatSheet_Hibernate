package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.AuditLogEntity;

public interface AuditLogRepository {

    Integer save(AuditLogEntity auditLog);

    AuditLogEntity findById(Integer id);

    List<AuditLogEntity> findRecent(int limit);

    List<AuditLogEntity> search(String keyword, String entityType, int page, int size);

    long countSearch(String keyword, String entityType);
    List<Object[]> getMonthlyActiveUserCounts(int year);
}
