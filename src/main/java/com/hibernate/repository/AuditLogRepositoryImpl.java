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
        if (auditLog.getEntityType() == null) {
            auditLog.setEntityType(auditLog.getEntityName());
        }
        return (Integer) getSession().save(auditLog);
    }

    @Override
    public AuditLogEntity findById(Integer id) {
        return getSession()
                .createQuery(
                        "select a from AuditLogEntity a "
                      + "left join fetch a.user "
                      + "where a.id = :id",
                        AuditLogEntity.class)
                .setParameter("id", id)
                .uniqueResult();
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

    @Override
    public List<AuditLogEntity> search(String keyword, String entityType, int page, int size) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String type = entityType == null ? "" : entityType.trim();
        return getSession()
                .createQuery(
                        "select a from AuditLogEntity a "
                      + "left join fetch a.user "
                      + "where (:type = '' or a.entityType = :type or a.entityName = :type) "
                      + "and (:keyword = '' "
                      + "or lower(a.action) like :likeKeyword "
                      + "or lower(a.description) like :likeKeyword "
                      + "or lower(a.entityName) like :likeKeyword "
                      + "or lower(a.ipAddress) like :likeKeyword "
                      + "or lower(a.user.username) like :likeKeyword) "
                      + "order by a.createdAt desc",
                        AuditLogEntity.class)
                .setParameter("type", type)
                .setParameter("keyword", search)
                .setParameter("likeKeyword", "%" + search + "%")
                .setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .list();
    }

    @Override
    public long countSearch(String keyword, String entityType) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String type = entityType == null ? "" : entityType.trim();
        Long count = getSession()
                .createQuery(
                        "select count(a) from AuditLogEntity a "
                      + "left join a.user u "
                      + "where (:type = '' or a.entityType = :type or a.entityName = :type) "
                      + "and (:keyword = '' "
                      + "or lower(a.action) like :likeKeyword "
                      + "or lower(a.description) like :likeKeyword "
                      + "or lower(a.entityName) like :likeKeyword "
                      + "or lower(a.ipAddress) like :likeKeyword "
                      + "or lower(u.username) like :likeKeyword)",
                        Long.class)
                .setParameter("type", type)
                .setParameter("keyword", search)
                .setParameter("likeKeyword", "%" + search + "%")
                .uniqueResult();
        return count != null ? count : 0;
    }
}
