package com.hibernate.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.ReportEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReportRepositoryImpl implements ReportRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Integer save(ReportEntity report) {
        return (Integer) getSession().save(report);
    }

    @Override
    public List<ReportEntity> findAll() {
        return getSession()
                .createQuery(
                        "select r from ReportEntity r "
                      + "left join fetch r.user "
                      + "order by r.createdAt desc",
                        ReportEntity.class)
                .list();
    }

    @Override
    public List<ReportEntity> search(String keyword, String status, String targetType, int page, int size) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String statusFilter = status == null ? "" : status.trim();
        String typeFilter = targetType == null ? "" : targetType.trim();
        return getSession()
                .createQuery(
                        "select r from ReportEntity r "
                      + "left join fetch r.user "
                      + "where (:status = '' or r.status = :status) "
                      + "and (:targetType = '' or r.targetType = :targetType) "
                      + "and (:keyword = '' "
                      + "or lower(r.reason) like :likeKeyword "
                      + "or lower(r.description) like :likeKeyword "
                      + "or lower(r.user.username) like :likeKeyword) "
                      + "order by r.createdAt desc",
                        ReportEntity.class)
                .setParameter("status", statusFilter)
                .setParameter("targetType", typeFilter)
                .setParameter("keyword", search)
                .setParameter("likeKeyword", "%" + search + "%")
                .setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .list();
    }

    @Override
    public long countSearch(String keyword, String status, String targetType) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String statusFilter = status == null ? "" : status.trim();
        String typeFilter = targetType == null ? "" : targetType.trim();
        Long count = getSession()
                .createQuery(
                        "select count(r) from ReportEntity r "
                      + "left join r.user u "
                      + "where (:status = '' or r.status = :status) "
                      + "and (:targetType = '' or r.targetType = :targetType) "
                      + "and (:keyword = '' "
                      + "or lower(r.reason) like :likeKeyword "
                      + "or lower(r.description) like :likeKeyword "
                      + "or lower(u.username) like :likeKeyword)",
                        Long.class)
                .setParameter("status", statusFilter)
                .setParameter("targetType", typeFilter)
                .setParameter("keyword", search)
                .setParameter("likeKeyword", "%" + search + "%")
                .uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public ReportEntity findById(Integer id) {
        return getSession()
                .createQuery(
                        "select r from ReportEntity r "
                      + "left join fetch r.user "
                      + "where r.id = :id",
                        ReportEntity.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    @Override
    public void updateStatus(Integer id, String status) {
        ReportEntity report = findById(id);
        if (report != null) {
            report.setStatus(status);
            getSession().update(report);
        }
    }

    @Override
    public void delete(Integer id) {
        ReportEntity report = findById(id);
        if (report != null) {
            getSession().delete(report);
        }
    }

    @Override
    public long countAll() {
        Long count = getSession().createQuery("select count(r) from ReportEntity r", Long.class).uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public long countByStatus(String status) {
        Long count = getSession()
                .createQuery("select count(r) from ReportEntity r where r.status = :status", Long.class)
                .setParameter("status", status)
                .uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public List<ReportEntity> findLatest(int limit) {
        return getSession()
                .createQuery(
                        "select r from ReportEntity r "
                      + "left join fetch r.user "
                      + "order by r.createdAt desc",
                        ReportEntity.class)
                .setMaxResults(limit)
                .list();
    }
}
