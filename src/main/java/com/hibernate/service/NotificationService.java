package com.hibernate.service;

import java.util.List;

import com.hibernate.dto.NotificationDto;

public interface NotificationService {

    NotificationDto createNotification(Integer userId, Integer senderId, String message, String type, String linkUrl);

    NotificationDto createFollowNotification(Integer followerId, Integer followingId);

    List<NotificationDto> createAnnouncementNotifications(Integer senderId, Integer announcementId, String title);

    List<NotificationDto> createCheatsheetNotificationsForFollowers(Integer authorId, Integer cheatsheetId, String title);

    List<NotificationDto> findByUserId(Integer userId);

    List<NotificationDto> findRecentByUserId(Integer userId, int limit);

    long countUnreadByUserId(Integer userId);

    void markAsRead(Integer notificationId, Integer userId);

    void markAllAsRead(Integer userId);
}
