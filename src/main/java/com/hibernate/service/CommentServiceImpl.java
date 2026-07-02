package com.hibernate.service;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.CommentEntity;
import com.hibernate.entity.CommentReactionEntity;
import com.hibernate.entity.User;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.repository.CommentRepositoryImpl;
import com.hibernate.repository.CommentReactionRepositoryImpl;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentServiceImpl {

    private final CommentRepositoryImpl commentRepo;
    private final CommentReactionRepositoryImpl reactionRepo;

    @Transactional
    public String addComment(Integer userId, Integer cheatSheetId, String content, Integer parentCommentId) {
        CommentEntity comment = new CommentEntity();
        comment.setContent(content);
        
        User user = new User(); user.setId(userId);
        CheatsheetEntity sheet = new CheatsheetEntity(); sheet.setId(cheatSheetId);
        
        comment.setUser(user);
        comment.setCheatSheet(sheet);
        
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

    @Transactional
    public String reactToComment(Integer userId, Integer commentId, Boolean isLike) {
        CommentReactionEntity existing = reactionRepo.getReaction(userId, commentId);
        
        if (existing != null) {
            existing.setIsLike(isLike);
            reactionRepo.saveOrUpdateReaction(existing);
            return "Comment reaction updated.";
        } else {
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
}