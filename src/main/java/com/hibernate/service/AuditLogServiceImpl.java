package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.AuditLogEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.AuditLogRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuditLogServiceImpl implements AuditLogService {

    private final AuditLogRepository auditLogRepository;

    @Override
    @Transactional
    public void log(User user, String action, String entityName, Integer entityId) {
        log(user, action, entityName, entityId, null, null);
    }

    @Override
    @Transactional
    public void log(User user, String action, String entityName, Integer entityId, String description, String ipAddress) {
        AuditLogEntity auditLog = new AuditLogEntity();
        auditLog.setUser(user);
        auditLog.setAction(action);
        auditLog.setEntityName(entityName);
        auditLog.setEntityType(entityName);
        auditLog.setEntityId(entityId);
        auditLog.setDescription(description);
        auditLog.setIpAddress(ipAddress);
        auditLogRepository.save(auditLog);
    }

    @Override
    @Transactional(readOnly = true)
    public AuditLogEntity findById(Integer id) {
        return auditLogRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<AuditLogEntity> findRecent(int limit) {
        return auditLogRepository.findRecent(limit);
    }

    @Override
    @Transactional(readOnly = true)
    public List<AuditLogEntity> search(String keyword, String entityType, int page, int size) {
        return auditLogRepository.search(keyword, entityType, page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public long countSearch(String keyword, String entityType) {
        return auditLogRepository.countSearch(keyword, entityType);
    }
}
