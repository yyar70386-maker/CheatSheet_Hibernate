package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.NotificationEntity;

public interface NotificationRepository {

    Integer save(NotificationEntity notification);

    List<NotificationEntity> findByUserId(Integer userId);

    List<NotificationEntity> findRecentByUserId(Integer userId, int limit);

    long countUnreadByUserId(Integer userId);

    NotificationEntity findById(Integer id);

    void markAsRead(Integer id, Integer userId);

    void markAllAsRead(Integer userId);

    void markAnnouncementAsRead(Integer userId, Integer announcementId);

    void delete(Integer id, Integer userId);

    long countAll();
}
