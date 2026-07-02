package com.hibernate.service;

import java.util.List;
import com.hibernate.dto.NotificationDto;

public interface NotificationService {
    void send(Integer sheetId, String reason);
    void sendCommentNotification(Integer commentId, String reason);
    NotificationDto createFollowNotification(Integer followerId, Integer followingId);
    
    // 🌟 Controller များမှ လှမ်းခေါ်နေသော Method အသစ်များ
    List<NotificationDto> createAnnouncementNotifications(Integer adminId, Integer announcementId, String title);
    List<NotificationDto> createCheatsheetNotificationsForFollowers(Integer authorId, Integer sheetId, String title);
    List<NotificationDto> findByUserId(Integer userId);
    long countUnreadByUserId(Integer userId);
    List<NotificationDto> findRecentByUserId(Integer userId, int limit);
    void markAsRead(Integer notificationId, Integer userId);
    void markAllAsRead(Integer userId);
}