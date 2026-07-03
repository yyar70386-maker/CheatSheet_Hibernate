package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.AnnouncementEntity;
import com.hibernate.entity.User;

public interface AnnouncementService {

    Integer save(AnnouncementEntity announcement, User createdBy);

    void update(AnnouncementEntity announcement);

    void delete(Integer id);

    AnnouncementEntity findById(Integer id);

    List<AnnouncementEntity> findAllActive();

    List<AnnouncementEntity> findAll();

    List<AnnouncementEntity> findLatest(int limit);

    long countAllActive();

    void updateStatus(Integer id, String status, User admin);
}
