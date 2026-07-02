package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.AuditLogEntity;
import com.hibernate.entity.User;

public interface AuditLogService {

    void log(User user, String action, String entityName, Integer entityId);

    void log(User user, String action, String entityName, Integer entityId, String description, String ipAddress);

    AuditLogEntity findById(Integer id);

    List<AuditLogEntity> findRecent(int limit);

    List<AuditLogEntity> search(String keyword, String entityType, int page, int size);

    long countSearch(String keyword, String entityType);
}
