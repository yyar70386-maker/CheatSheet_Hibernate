package com.hibernate.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.FollowUserDto;
import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.User;
import com.hibernate.repository.UserFollowRepository;
import com.hibernate.repository.UserRepository;
import com.hibernate.service.AuditLogService;

@Service
@Transactional
public class UserFollowServiceImpl implements UserFollowService {

    @Autowired
    private UserFollowRepository userFollowRepository;

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private AuditLogService auditLogService;

    @Autowired
    private UserRepository userRepository;

    @Override
    public NotificationDto followUser(Integer followerId, Integer followingId) {
        if (!userFollowRepository.isFollowing(followerId, followingId)) {
            userFollowRepository.follow(followerId, followingId);
            NotificationDto dto = notificationService.createFollowNotification(followerId, followingId);
            auditLogService.log(userRepository.findById(followerId), "User Followed Another User", "UserFollow", followingId);
            return dto;
        }
        return null;
    }

    @Override
    public void unfollowUser(Integer followerId, Integer followingId) {
        userFollowRepository.unfollow(followerId, followingId);
    }

    @Override
    public boolean isFollowing(Integer followerId, Integer followingId) {
        return userFollowRepository.isFollowing(followerId, followingId);
    }

    @Override
    public Long getFollowersCount(Integer userId) {
        return userFollowRepository.countFollowers(userId);
    }

    @Override
    public Long getFollowingCount(Integer userId) {
        return userFollowRepository.countFollowing(userId);
    }

    // 👥 [ADDED] Followers စာရင်းယူခြင်း
    @Override
    public List<User> getFollowersUserList(Integer userId) {
        return userFollowRepository.findFollowersByUserId(userId);
    }

    // 🤝 [ADDED] Following စာရင်းယူခြင်း
    @Override
    public List<User> getFollowingUserList(Integer userId) {
        return userFollowRepository.findFollowingByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<FollowUserDto> getFollowersForView(Integer profileUserId, Integer currentUserId) {
        return userFollowRepository.findFollowersByUserId(profileUserId)
                .stream()
                .map(user -> FollowUserDto.fromUser(
                        user,
                        currentUserId != null && userFollowRepository.isFollowing(currentUserId, user.getId()),
                        userFollowRepository.countMutualFollowers(currentUserId, user.getId())))
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<FollowUserDto> getFollowingForView(Integer profileUserId, Integer currentUserId) {
        return userFollowRepository.findFollowingByUserId(profileUserId)
                .stream()
                .map(user -> FollowUserDto.fromUser(
                        user,
                        currentUserId != null && userFollowRepository.isFollowing(currentUserId, user.getId()),
                        userFollowRepository.countMutualFollowers(currentUserId, user.getId())))
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public long countAll() {
        return userFollowRepository.countAll();
    }

    @Override
    @Transactional(readOnly = true)
    public long countMutualFollowers(Integer currentUserId, Integer targetUserId) {
        return userFollowRepository.countMutualFollowers(currentUserId, targetUserId);
    }
}
