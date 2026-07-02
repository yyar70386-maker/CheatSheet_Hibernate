package com.hibernate.service;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.dto.NotificationDto;

@Service
@Transactional
public class NotificationServiceImpl implements NotificationService {

    @Override
    public void send(Integer sheetId, String reason) {
        System.out.println("🔔 Notification: Cheatsheet #" + sheetId + " Banned. Reason: " + reason);
    }

    @Override
    public void sendCommentNotification(Integer commentId, String reason) {
        System.out.println("🔔 Notification: Comment #" + commentId + " Deleted. Reason: " + reason);
    }

    @Override
    public NotificationDto createFollowNotification(Integer followerId, Integer followingId) {
        System.out.println("🔔 Notification: User " + followerId + " started following User " + followingId);
        return new NotificationDto(); 
    }

    // 🌟 Controller များအတွက် ဖြည့်စွက်ပေးထားသော Method အသစ်များ
    
    @Override
    public List<NotificationDto> createAnnouncementNotifications(Integer adminId, Integer announcementId, String title) {
        System.out.println("🔔 Announcement Broadcast: " + title);
        return new ArrayList<>(); 
    }

    @Override
    public List<NotificationDto> createCheatsheetNotificationsForFollowers(Integer authorId, Integer sheetId, String title) {
        System.out.println("🔔 Cheatsheet Broadcast to followers: " + title);
        return new ArrayList<>();
    }

    @Override
    public List<NotificationDto> findByUserId(Integer userId) {
        // User တစ်ယောက်ချင်းစီရဲ့ Notification တွေကို Database ကနေ ခေါ်မယ့်နေရာ
        return new ArrayList<>();
    }

    @Override
    public long countUnreadByUserId(Integer userId) {
        // ဖတ်ရန်ကျန်သေးသည့် အရေအတွက်
        return 0; 
    }

    @Override
    public List<NotificationDto> findRecentByUserId(Integer userId, int limit) {
        return new ArrayList<>();
    }

    @Override
    public void markAsRead(Integer notificationId, Integer userId) {
        System.out.println("🔔 Marked notification " + notificationId + " as read for user " + userId);
    }

    @Override
    public void markAllAsRead(Integer userId) {
        System.out.println("🔔 Marked all notifications as read for user " + userId);
    }
}