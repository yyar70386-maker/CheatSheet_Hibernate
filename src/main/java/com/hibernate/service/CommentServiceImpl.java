package com.hibernate.service;

import java.util.List;
import java.sql.Timestamp;
import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.CommentEntity;
import com.hibernate.entity.CommentReactionEntity;
import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.repository.CommentRepositoryImpl;
import com.hibernate.repository.CommentReactionRepositoryImpl;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl {

    private final CommentRepositoryImpl commentRepo;
    private final CommentReactionRepositoryImpl reactionRepo;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;

    // 🌟 ၁။ Comment ရေးရန် (သို့မဟုတ်) Reply ပြန်ရန်
    @Transactional
    public String addComment(Integer userId, Integer cheatSheetId, String content, Integer parentCommentId) {
        CommentEntity comment = new CommentEntity();
        comment.setContent(content);
        
        User user = new User(); user.setId(userId);
        CheatsheetEntity sheet = new CheatsheetEntity(); sheet.setId(cheatSheetId);
        
        comment.setUser(user);
        comment.setCheatSheet(sheet);
        
        // Parent ID ပါလာရင် Reply အဖြစ် သတ်မှတ်ပြီး ချိတ်ဆက်ပေးမယ်
        if (parentCommentId != null) {
            CommentEntity parent = commentRepo.getById(parentCommentId);
            if (parent != null) {
                comment.setParentComment(parent);
            } else {
                return "Error: Parent comment not found!";
            }
        }
        
        commentRepo.insertComment(comment);
        return parentCommentId != null ? "Reply posted successfully." : "Comment posted successfully.";
    }

    // 🌟 ၂။ Comment ကို Like / Dislike လုပ်ရန်
    @Transactional
    public String reactToComment(Integer userId, Integer commentId, Boolean isLike) {
        CommentReactionEntity existing = reactionRepo.getReaction(userId, commentId);
        
        if (existing != null) {
            // ရှိပြီးသားဆို Update ပဲလုပ်မယ်
            existing.setIsLike(isLike);
            reactionRepo.saveOrUpdateReaction(existing);
            return "Comment reaction updated.";
        } else {
            // မရှိသေးရင် အသစ်ထည့်မယ်
            CommentReactionEntity newReaction = new CommentReactionEntity();
            
            User user = new User(); user.setId(userId);
            CommentEntity comment = new CommentEntity(); comment.setId(commentId);
            
            newReaction.setUser(user);
            newReaction.setComment(comment);
            newReaction.setIsLike(isLike);
            
            reactionRepo.saveOrUpdateReaction(newReaction);
            return "Comment liked successfully.";
        }
    }

    @Transactional
    public List<CommentEntity> searchComments(String keyword, String status, int page, int size) {
        return commentRepo.searchComments(keyword, status, page, size);
    }

    @Transactional
    public long countSearchComments(String keyword, String status) {
        return commentRepo.countSearchComments(keyword, status);
    }

    @Transactional
    public void deleteComment(Integer id, User admin, String ipAddress) {
        CommentEntity comment = commentRepo.getById(id);
        if (comment != null) {
            commentRepo.deleteComment(id);
            auditLogService.log(admin, "Comment Deleted", "Comment", id, "Deleted comment by " + (comment.getUser() != null ? comment.getUser().getUsername() : "Unknown"), ipAddress);
        }
    }

    @Transactional
    public NotificationDto banComment(Integer id, String reason, User admin, String ipAddress) {
        CommentEntity comment = commentRepo.getById(id);
        if (comment != null) {
            comment.setBanned(true);
            comment.setBannedReason(reason);
            comment.setBannedBy(admin);
            comment.setBannedAt(new Timestamp(System.currentTimeMillis()));
            commentRepo.updateComment(comment);
            auditLogService.log(admin, "Comment Banned", "Comment", id, "Banned comment by " + (comment.getUser() != null ? comment.getUser().getUsername() : "Unknown") + " (Reason: " + reason + ")", ipAddress);

            // Notify comment author
            if (comment.getUser() != null) {
                return notificationService.createNotification(
                        comment.getUser().getId(),
                        admin != null ? admin.getId() : null,
                        "Your comment in CheatSheet '" + (comment.getCheatSheet() != null ? comment.getCheatSheet().getTitle() : "") + "' has been banned. Reason: " + reason,
                        "COMMENT_BAN",
                        (comment.getCheatSheet() != null ? "/cheatsheet/detail/" + comment.getCheatSheet().getObfuscatedId() : "/notifications")
                );
            }
        }
        return null;
    }

    @Transactional
    public NotificationDto restoreComment(Integer id, User admin, String ipAddress) {
        CommentEntity comment = commentRepo.getById(id);
        if (comment != null) {
            comment.setBanned(false);
            comment.setBannedReason(null);
            comment.setBannedBy(null);
            comment.setBannedAt(null);
            commentRepo.updateComment(comment);
            auditLogService.log(admin, "Comment Restored", "Comment", id, "Restored comment by " + (comment.getUser() != null ? comment.getUser().getUsername() : "Unknown"), ipAddress);

            // Notify comment author
            if (comment.getUser() != null) {
                return notificationService.createNotification(
                        comment.getUser().getId(),
                        admin != null ? admin.getId() : null,
                        "Your comment has been restored.",
                        "COMMENT_RESTORE",
                        (comment.getCheatSheet() != null ? "/cheatsheet/detail/" + comment.getCheatSheet().getObfuscatedId() : "/notifications")
                );
            }
        }
        return null;
    }

    @Transactional
    public long countBanned() {
        return commentRepo.countBanned();
    }

    @Transactional
    public long countAll() {
        return commentRepo.countAll();
    }

    @Transactional
    public CommentEntity getCommentById(Integer id) {
        return commentRepo.getById(id);
    }
}