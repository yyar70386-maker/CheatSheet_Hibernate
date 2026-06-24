package com.hibernate.service;

import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.dto.FollowUserDto;
import java.util.List;

public interface UserFollowService {

    NotificationDto followUser(Integer followerId, Integer followingId);

    void unfollowUser(Integer followerId, Integer followingId);

    boolean isFollowing(Integer followerId, Integer followingId);

    Long getFollowersCount(Integer userId);

    Long getFollowingCount(Integer userId);

    // 👥 [ADDED] မိမိအား Follow လုပ်ထားသည့် လူစာရင်းကို ဆွဲယူရန်
    List<User> getFollowersUserList(Integer userId);

    // 🤝 [ADDED] မိမိမှ Follow လုပ်ထားသည့် လူစာရင်းကို ဆွဲယူရန်
    List<User> getFollowingUserList(Integer userId);
    List<FollowUserDto> getFollowersForView(Integer profileUserId, Integer currentUserId);
    List<FollowUserDto> getFollowingForView(Integer profileUserId, Integer currentUserId);
    long countAll();
    long countMutualFollowers(Integer currentUserId, Integer targetUserId);
}
