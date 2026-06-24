package com.hibernate.service;

import com.hibernate.entity.User;
import java.util.List;

public interface UserFollowService {

    void followUser(Integer followerId, Integer followingId);

    void unfollowUser(Integer followerId, Integer followingId);

    boolean isFollowing(Integer followerId, Integer followingId);

    Long getFollowersCount(Integer userId);

    Long getFollowingCount(Integer userId);

    // 👥 [ADDED] မိမိအား Follow လုပ်ထားသည့် လူစာရင်းကို ဆွဲယူရန်
    List<User> getFollowersUserList(Integer userId);

    // 🤝 [ADDED] မိမိမှ Follow လုပ်ထားသည့် လူစာရင်းကို ဆွဲယူရန်
    List<User> getFollowingUserList(Integer userId);
}