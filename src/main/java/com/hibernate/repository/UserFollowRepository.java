package com.hibernate.repository;

import com.hibernate.entity.User;
import java.util.List;

public interface UserFollowRepository {
    void follow(Integer followerId, Integer followingId);
    void unfollow(Integer followerId, Integer followingId);
    boolean isFollowing(Integer followerId, Integer followingId);
    Long countFollowers(Integer userId);
    Long countFollowing(Integer userId);
    
    // 🌟 ဤနေရာတွင် မက်သဒ်နှစ်ခု ဖြည့်စွက်ပါ
    List<User> findFollowersByUserId(Integer userId);
    List<User> findFollowingByUserId(Integer userId);
}