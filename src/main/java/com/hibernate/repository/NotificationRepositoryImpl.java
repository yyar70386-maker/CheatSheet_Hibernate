package com.hibernate.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.NotificationEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class NotificationRepositoryImpl implements NotificationRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Integer save(NotificationEntity notification) {
        return (Integer) getSession().save(notification);
    }

    @Override
    public List<NotificationEntity> findByUserId(Integer userId) {
        return getSession()
                .createQuery(
                        "select n from NotificationEntity n "
                      + "left join fetch n.sender "
                      + "where n.user.id = :userId "
                      + "order by n.createdAt desc",
                        NotificationEntity.class)
                .setParameter("userId", userId)
                .list();
    }

    @Override
    public List<NotificationEntity> findRecentByUserId(Integer userId, int limit) {
        return getSession()
                .createQuery(
                        "select n from NotificationEntity n "
                      + "left join fetch n.sender "
                      + "where n.user.id = :userId "
                      + "order by n.createdAt desc",
                        NotificationEntity.class)
                .setParameter("userId", userId)
                .setMaxResults(limit)
                .list();
    }

    @Override
    public long countUnreadByUserId(Integer userId) {
        Long count = getSession()
                .createQuery(
                        "select count(n) from NotificationEntity n "
                      + "where n.user.id = :userId and n.isRead = false",
                        Long.class)
                .setParameter("userId", userId)
                .uniqueResult();

        return count != null ? count : 0;
    }

    @Override
    public NotificationEntity findById(Integer id) {
        return getSession().get(NotificationEntity.class, id);
    }

    @Override
    public void markAsRead(Integer id, Integer userId) {
        getSession()
                .createQuery(
                        "update NotificationEntity n "
                      + "set n.isRead = true "
                      + "where n.id = :id and n.user.id = :userId")
                .setParameter("id", id)
                .setParameter("userId", userId)
                .executeUpdate();
    }

    @Override
    public void markAllAsRead(Integer userId) {
        getSession()
                .createQuery(
                        "update NotificationEntity n "
                      + "set n.isRead = true "
                      + "where n.user.id = :userId and n.isRead = false")
                .setParameter("userId", userId)
                .executeUpdate();
    }
}
