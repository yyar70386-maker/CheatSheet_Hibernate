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
    public ReportEntity findById(Integer id) {
        return getSession().get(ReportEntity.class, id);
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
    public long countAll() {
        Long count = getSession().createQuery("select count(r) from ReportEntity r", Long.class).uniqueResult();
        return count != null ? count : 0;
    }
}
