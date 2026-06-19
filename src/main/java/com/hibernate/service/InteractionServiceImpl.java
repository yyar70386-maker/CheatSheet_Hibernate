package com.hibernate.service;

import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.*;
import com.hibernate.repository.CommentRepositoryImpl;
import com.hibernate.repository.ReactionRepositoryImpl;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InteractionServiceImpl {

    private final CommentRepositoryImpl commentRepo;
    private final ReactionRepositoryImpl reactionRepo;

    // 1. Comment ရေးရန်
    @Transactional
    public String addComment(Integer userId, Integer cheatSheetId, String content) {
        CommentEntity comment = new CommentEntity();
        comment.setContent(content);
        
        User user = new User(); user.setId(userId);
        CheatSheetEntity sheet = new CheatSheetEntity(); sheet.setId(cheatSheetId);
        
        comment.setUser(user);
        comment.setCheatSheet(sheet);
        
        commentRepo.insertComment(comment);
        return "Comment added successfully.";
    }

    // 2. Like CheatSheet
    @Transactional
    public String likeCheatSheet(Integer userId, Integer cheatSheetId, Boolean isLike) {
        SheetReactionEntity existing = reactionRepo.getSheetReaction(userId, cheatSheetId);
        
        if (existing != null) {
            existing.setIsLike(isLike);
            reactionRepo.saveOrUpdateSheetReaction(existing);
            return "Sheet reaction updated.";
        } else {
            SheetReactionEntity newReaction = new SheetReactionEntity();
            User user = new User(); user.setId(userId);
            CheatSheetEntity sheet = new CheatSheetEntity(); sheet.setId(cheatSheetId);
            
            newReaction.setUser(user);
            newReaction.setCheatSheet(sheet);
            newReaction.setIsLike(isLike);
            
            reactionRepo.saveOrUpdateSheetReaction(newReaction);
            return "Sheet liked/disliked successfully.";
        }
    }
    

    // 3. Like Comment
    @Transactional
    public String likeComment(Integer userId, Integer commentId, Boolean isLike) {
        CommentReactionEntity existing = reactionRepo.getCommentReaction(userId, commentId);
        
        if (existing != null) {
            existing.setIsLike(isLike);
            reactionRepo.saveOrUpdateCommentReaction(existing);
            return "Comment reaction updated.";
        } else {
            CommentReactionEntity newReaction = new CommentReactionEntity();
            User user = new User(); user.setId(userId);
            CommentEntity comment = new CommentEntity(); comment.setId(commentId);
            
            newReaction.setUser(user);
            newReaction.setComment(comment);
            newReaction.setIsLike(isLike);
            
            reactionRepo.saveOrUpdateCommentReaction(newReaction);
            return "Comment liked/disliked successfully.";
        }
    }
}