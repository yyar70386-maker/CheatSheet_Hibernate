package com.hibernate.service;

import java.util.List;
import com.hibernate.dto.NotificationDto;

public interface NotificationService {

    // 🌟 HEAD မှ method များ (ရိုးရှင်းသော system notification ပို့ရန်)
    void send(Integer sheetId, String reason);
    void sendCommentNotification(Integer commentId, String reason);

    // 🌟 main မှ method များ (အသေးစိတ် DTO ပြန်ပေးသော custom notification များ)
    NotificationDto createNotification(Integer userId, Integer senderId, String message, String type, String linkUrl);
    NotificationDto createNotification(Integer userId, Integer senderId, String title, String message, String type, String linkUrl);
    List<NotificationDto> broadcast(Integer senderId, String title, String message, String type, String linkUrl);

    // 🌟 ဘုံတူညီသော method များ (Controller များမှ လှမ်းခေါ်နေသော method များ)
    NotificationDto createFollowNotification(Integer followerId, Integer followingId);
    List<NotificationDto> createAnnouncementNotifications(Integer adminId, Integer announcementId, String title);
    List<NotificationDto> createCheatsheetNotificationsForFollowers(Integer authorId, Integer sheetId, String title);
    List<NotificationDto> findByUserId(Integer userId);
    long countUnreadByUserId(Integer userId);
    List<NotificationDto> findRecentByUserId(Integer userId, int limit);
    void markAsRead(Integer notificationId, Integer userId);
    void markAllAsRead(Integer userId);

    // 🌟 main မှ အသစ်တိုးထားသော management method များ
    void delete(Integer notificationId, Integer userId);
    long countAll();
}