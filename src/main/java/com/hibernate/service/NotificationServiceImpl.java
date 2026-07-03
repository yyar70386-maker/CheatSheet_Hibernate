package com.hibernate.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.NotificationEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.NotificationRepository;
import com.hibernate.repository.UserFollowRepository;
import com.hibernate.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@Transactional
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    // 🌟 Repository dependency များကို constructor injection (lombok @RequiredArgsConstructor) ဖြင့် ထည့်သွင်းထားသည်
    private final UserRepository userRepository;
    private final NotificationRepository notificationRepository;
    private final UserFollowRepository userFollowRepository;

    // ==========================================
    // 🌟 HEAD မှ System Notification Methods များ
    // ==========================================
    @Override
    public void send(Integer sheetId, String reason) {
        System.out.println("🔔 Notification: Cheatsheet #" + sheetId + " Banned. Reason: " + reason);
    }

    @Override
    public void sendCommentNotification(Integer commentId, String reason) {
        System.out.println("🔔 Notification: Comment #" + commentId + " Deleted. Reason: " + reason);
    }

    // ==========================================
    // 🌟 MAIN မှ Notification Creation & Broadcast Logic များ
    // ==========================================
    @Override
    public NotificationDto createNotification(Integer userId, Integer senderId, String message, String type, String linkUrl) {
        return createNotification(userId, senderId, type, message, type, linkUrl);
    }

    @Override
    public NotificationDto createNotification(Integer userId, Integer senderId, String title, String message, String type, String linkUrl) {
        User user = userRepository.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("Notification recipient not found.");
        }

        NotificationEntity notification = new NotificationEntity();
        notification.setUser(user);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setNotificationType(type);
        notification.setLinkUrl(linkUrl);
        notification.setIsRead(false);

        if (senderId != null) {
            notification.setSender(userRepository.findById(senderId));
        }

        notificationRepository.save(notification);
        return NotificationDto.fromEntity(notification);
    }

    @Override
    public List<NotificationDto> broadcast(Integer senderId, String title, String message, String type, String linkUrl) {
        return userRepository.findAll()
                .stream()
                .filter(user -> senderId == null || !user.getId().equals(senderId))
                .map(user -> createNotification(user.getId(), senderId, title, message, type, linkUrl))
                .collect(Collectors.toList());
    }

    @Override
    public NotificationDto createFollowNotification(Integer followerId, Integer followingId) {
        User follower = userRepository.findById(followerId);
        if (follower == null) {
            return null;
        }

        String followerName = follower.getFullName() != null ? follower.getFullName() : follower.getUsername();
        String message = followerName + " followed you.";

        return createNotification(
                followingId,
                followerId,
                "New follower",
                message,
                "FOLLOW",
                "/profile/" + followerId);
    }

    @Override
    public List<NotificationDto> createAnnouncementNotifications(Integer senderId, Integer announcementId, String title) {
        return broadcast(senderId, "New announcement", "New announcement posted: " + title, "ANNOUNCEMENT", "/announcements");
    }

    @Override
    public List<NotificationDto> createCheatsheetNotificationsForFollowers(Integer authorId, Integer cheatsheetId, String title) {
        User author = userRepository.findById(authorId);
        String authorName = author != null && author.getFullName() != null ? author.getFullName() : "A user";

        return userFollowRepository.findFollowersByUserId(authorId)
                .stream()
                .map(user -> createNotification(
                        user.getId(),
                        authorId,
                        "New cheat sheet",
                        authorName + " created a new cheat sheet: " + title,
                        "CHEATSHEET",
                        "/cheatsheet/detail/" + cheatsheetId))
                .collect(Collectors.toList());
    }

    // ==========================================
    // 🌟 User Queries & Management Methods
    // ==========================================
    @Override
    @Transactional(readOnly = true)
    public List<NotificationDto> findByUserId(Integer userId) {
        // Notification Repository တွင် method ရှိပါက အောက်ပါအတိုင်း ပြောင်းသုံးနိုင်သည်
        // return notificationRepository.findByUserId(userId).stream().map(NotificationDto::fromEntity).collect(Collectors.toList());
        return new ArrayList<>();
    }

    @Override
    @Transactional(readOnly = true)
    public long countUnreadByUserId(Integer userId) {
        // Notification Repository တွင် method ရှိပါက အောက်ပါအတိုင်း ပြောင်းသုံးနိုင်သည်
        // return notificationRepository.countUnreadByUserId(userId);
        return 0; 
    }

    @Override
    @Transactional(readOnly = true)
    public List<NotificationDto> findRecentByUserId(Integer userId, int limit) {
        return new ArrayList<>();
    }

    @Override
    public void markAsRead(Integer notificationId, Integer userId) {
        System.out.println("🔔 Marked notification " + notificationId + " as read for user " + userId);
        // notificationRepository.markAsRead(notificationId, userId);
    }

    @Override
    public void markAllAsRead(Integer userId) {
        System.out.println("🔔 Marked all notifications as read for user " + userId);
        // notificationRepository.markAllAsRead(userId);
    }

    @Override
    public void delete(Integer notificationId, Integer userId) {
        notificationRepository.delete(notificationId, userId);
    }

    @Override
    @Transactional(readOnly = true)
    public long countAll() {
        return notificationRepository.countAll();
    }
}