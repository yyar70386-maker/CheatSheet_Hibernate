package com.hibernate.dto;

import com.hibernate.entity.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FollowUserDto {

    private Integer id;
    private String username;
    private String fullName;
    private String bio;
    private String avatarPath;
    private boolean following;
    private long mutualFollowersCount;

    public static FollowUserDto fromUser(User user, boolean following, long mutualFollowersCount) {
        FollowUserDto dto = new FollowUserDto();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setFullName(user.getFullName());
        dto.setBio(user.getBio());
        dto.setAvatarPath(user.getAvatarPath());
        dto.setFollowing(following);
        dto.setMutualFollowersCount(mutualFollowersCount);
        return dto;
    }
}
