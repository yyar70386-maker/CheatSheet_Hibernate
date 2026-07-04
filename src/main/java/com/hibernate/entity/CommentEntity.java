package com.hibernate.entity;

import javax.persistence.*;
import lombok.Data;
import java.sql.Timestamp;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Table(name = "comments")
@Data
public class CommentEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String content;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cheatsheet_id", nullable = false)
    private CheatsheetEntity cheatSheet;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_comment_id")
    private CommentEntity parentComment; 

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private Timestamp createdAt;

    // 🌟 View သို့ Data များသယ်သွားရန် (Database တွင် Column အသစ်ဆောက်စရာမလိုပါ)
    @Transient
    private Long likeCount = 0L;
    
    @Transient
    private Long dislikeCount = 0L;

    @Transient
    private Boolean currentUserReaction = null; // true = Like, false = Dislike, null = မပေးရသေး

    @Column(name = "banned", nullable = false)
    private boolean banned = false;

    @Column(name = "banned_reason", length = 500)
    private String bannedReason;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "banned_by")
    private User bannedBy;

    @Column(name = "banned_at")
    private Timestamp bannedAt;

    @Column(name = "deleted_at")
    private Timestamp deletedAt;
}