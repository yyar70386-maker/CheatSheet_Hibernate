package com.hibernate.entity;

import javax.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(unique = true, nullable = false)
    private String email;
    
    @OneToMany(mappedBy = "follower")
    private List<UserFollowEntity> followingList;

    @OneToMany(mappedBy = "following")
    private List<UserFollowEntity> followerList;
    

    private String fullName;
    private int role; // 0 = User, 1 = Admin
    private String avatarPath; 
    private String resetToken;
    private LocalDateTime tokenExpiry;
    private String bio;

    @Column(name = "failed_login_attempts", nullable = false)
    private int failedLoginAttempts = 0;

    @Column(name = "account_locked", nullable = false)
    private boolean accountLocked = false;

    @Column(name = "suspended", nullable = false)
    private boolean suspended = false;

    @Column(name = "suspended_at")
    private LocalDateTime suspendedAt;

    @Column(name = "suspend_reason")
    private String suspendReason;

    @javax.persistence.Transient
    public String getObfuscatedId() {
        return com.hibernate.util.IdObfuscator.encode(this.id);
    }
}