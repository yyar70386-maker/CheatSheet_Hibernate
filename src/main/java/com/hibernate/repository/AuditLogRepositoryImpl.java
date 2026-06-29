package com.hibernate.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.AuditLogEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AuditLogRepositoryImpl implements AuditLogRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Integer save(AuditLogEntity auditLog) {
        if (auditLog.getCreatedAt() == null) {
            auditLog.setCreatedAt(LocalDateTime.now());
        }
        return (Integer) getSession().save(auditLog);
    }

    @Override
    public List<AuditLogEntity> findRecent(int limit) {
        return getSession()
                .createQuery(
                        "select a from AuditLogEntity a "
                      + "left join fetch a.user "
                      + "order by a.createdAt desc",
                        AuditLogEntity.class)
                .setMaxResults(limit)
                .list();
    }
}
