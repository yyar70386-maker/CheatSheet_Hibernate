package com.hibernate.repository.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.AppealEntity;
import com.hibernate.repository.AppealRepository;

@Repository
public class AppealRepositoryImpl implements AppealRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public Integer save(AppealEntity appeal) {
        Session session = sessionFactory.getCurrentSession();
        return (Integer) session.save(appeal);
    }

    @Override
    public AppealEntity findById(Integer id) {
        Session session = sessionFactory.getCurrentSession();
        return session.get(AppealEntity.class, id);
    }

    @Override
    public void update(AppealEntity appeal) {
        Session session = sessionFactory.getCurrentSession();
        session.update(appeal);
    }

    @Override
    public List<AppealEntity> findAllPending() {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("FROM AppealEntity WHERE status = 'PENDING' ORDER BY createdAt DESC", AppealEntity.class).getResultList();
    }

    @Override
    public List<AppealEntity> findByUserId(Integer userId) {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("FROM AppealEntity WHERE user.id = :userId ORDER BY createdAt DESC", AppealEntity.class)
                      .setParameter("userId", userId)
                      .getResultList();
    }

    @Override
    public List<AppealEntity> findByTarget(String targetType, Integer targetId) {
        Session session = sessionFactory.getCurrentSession();
        return session.createQuery("FROM AppealEntity WHERE targetType = :targetType AND targetId = :targetId ORDER BY createdAt DESC", AppealEntity.class)
                      .setParameter("targetType", targetType)
                      .setParameter("targetId", targetId)
                      .getResultList();
    }
}
