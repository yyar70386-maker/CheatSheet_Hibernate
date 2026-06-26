package com.hibernate.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.AnnouncementEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class AnnouncementRepositoryImpl implements AnnouncementRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Integer save(AnnouncementEntity announcement) {
        return (Integer) getSession().save(announcement);
    }

    @Override
    public void update(AnnouncementEntity announcement) {
        AnnouncementEntity old = findById(announcement.getId());
        if (old != null) {
            old.setTitle(announcement.getTitle());
            old.setContent(announcement.getContent());
            getSession().update(old);
        }
    }

    @Override
    public void delete(Integer id) {
        AnnouncementEntity announcement = findById(id);
        if (announcement != null) {
            announcement.setStatus("inactive");
            getSession().update(announcement);
        }
    }

    @Override
    public AnnouncementEntity findById(Integer id) {
        return getSession()
                .createQuery(
                        "select a from AnnouncementEntity a "
                      + "left join fetch a.createdBy "
                      + "where a.id = :id",
                        AnnouncementEntity.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    @Override
    public List<AnnouncementEntity> findAllActive() {
        return getSession()
                .createQuery(
                        "select a from AnnouncementEntity a "
                      + "left join fetch a.createdBy "
                      + "where a.status = 'active' "
                      + "order by a.createdAt desc",
                        AnnouncementEntity.class)
                .list();
    }

    @Override
    public List<AnnouncementEntity> findLatest(int limit) {
        return getSession()
                .createQuery(
                        "select a from AnnouncementEntity a "
                      + "left join fetch a.createdBy "
                      + "where a.status = 'active' "
                      + "order by a.createdAt desc",
                        AnnouncementEntity.class)
                .setMaxResults(limit)
                .list();
    }

    @Override
    public long countAllActive() {
        Long count = getSession()
                .createQuery("select count(a) from AnnouncementEntity a where a.status = 'active'", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }
}
