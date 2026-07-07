package com.hibernate.service;

import java.util.List;
import java.util.stream.Collectors;


import org.springframework.messaging.simp.SimpMessagingTemplate;
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

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;
    private final UserFollowRepository userFollowRepository;
    private final SimpMessagingTemplate messagingTemplate;

    @Override
    public void save(NotificationEntity notification) {
        // Repository မှတစ်ဆင့် Database ထဲ သိမ်းပါ
        notificationRepository.save(notification);
    }
    
 // NotificationServiceImpl.java ထဲတွင်
    public void createShareNotification(Integer targetUserId, Integer sharerId, String sharerName, String cheatsheetTitle, Integer cheatsheetId) {
        String message = sharerName + " shared your cheatsheet: " + cheatsheetTitle;
        
        // 📌 linkUrl ကို sharerId (AyeAye ရဲ့ ID) ရဲ့ Profile သို့ လမ်းကြောင်းပေးပါ
        String linkUrl = "/profile/" + sharerId; 

        createNotification(targetUserId, sharerId, message, "SHARE", linkUrl);
    }
    
    
    
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
        NotificationDto dto = NotificationDto.fromEntity(notification);
        
        messagingTemplate.convertAndSend("/topic/notifications/" + userId, dto);

        return dto;
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
        if (followerId == null || followingId == null || followerId.equals(followingId)) {
            return null;
        }

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
        return broadcast(senderId, "New announcement", "New announcement posted: " + title, "ANNOUNCEMENT", "/announcements?id=" + announcementId);
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

    @Override
    @Transactional(readOnly = true)
    public List<NotificationDto> findByUserId(Integer userId) {
        return notificationRepository.findByUserId(userId)
                .stream()
                .map(NotificationDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<NotificationDto> findRecentByUserId(Integer userId, int limit) {
        return notificationRepository.findRecentByUserId(userId, limit)
                .stream()
                .map(NotificationDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public long countUnreadByUserId(Integer userId) {
        return notificationRepository.countUnreadByUserId(userId);
    }

    @Override
    public void markAsRead(Integer notificationId, Integer userId) {
        notificationRepository.markAsRead(notificationId, userId);
    }

    @Override
    public void markAllAsRead(Integer userId) {
        notificationRepository.markAllAsRead(userId);
    }

    @Override
    public void markAnnouncementAsRead(Integer userId, Integer announcementId) {
        notificationRepository.markAnnouncementAsRead(userId, announcementId);
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
