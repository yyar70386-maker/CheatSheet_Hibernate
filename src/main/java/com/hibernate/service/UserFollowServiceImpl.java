package com.hibernate.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.User;
import com.hibernate.repository.UserFollowRepository;

@Service
@Transactional
public class UserFollowServiceImpl implements UserFollowService {

    @Autowired
    private UserFollowRepository userFollowRepository;

    @Override
    public void followUser(Integer followerId, Integer followingId) {
        if (!userFollowRepository.isFollowing(followerId, followingId)) {
            userFollowRepository.follow(followerId, followingId);
        }
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
}