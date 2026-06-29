package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.AuditLogEntity;
import com.hibernate.entity.User;

public interface AuditLogService {

    void log(User user, String action, String entityName, Integer entityId);

    List<AuditLogEntity> findRecent(int limit);
}
