package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.AnnouncementEntity;

public interface AnnouncementRepository {

    Integer save(AnnouncementEntity announcement);

    void update(AnnouncementEntity announcement);

    void delete(Integer id);

    AnnouncementEntity findById(Integer id);

    List<AnnouncementEntity> findAllActive();

    List<AnnouncementEntity> findLatest(int limit);

    long countAllActive();
}
