package com.hibernate.dto;

import com.hibernate.entity.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FollowUserDto {

    private Integer id;
    private String obfuscatedId; // 🌟 ၁။ ဒီ property အသစ်ကို ထည့်ပေးပါ
    private String username;
    private String fullName;
    private String bio;
    private String avatarPath;
    private boolean following;
    private boolean follower;
    private long mutualFollowersCount;

    public static FollowUserDto fromUser(User user, boolean following, boolean follower, long mutualFollowersCount) {
        FollowUserDto dto = new FollowUserDto();
        dto.setId(user.getId());
        
        // 🌟 ၂။ User ထဲက getObfuscatedId() method ကို လှမ်းခေါ်ပြီး DTO ထဲ ထည့်ပေးပါ
        dto.setObfuscatedId(user.getObfuscatedId()); 
        
        dto.setUsername(user.getUsername());
        dto.setFullName(user.getFullName());
        dto.setBio(user.getBio());
        dto.setAvatarPath(user.getAvatarPath());
        dto.setFollowing(following);
        dto.setFollower(follower);
        dto.setMutualFollowersCount(mutualFollowersCount);
        return dto;
    }
}