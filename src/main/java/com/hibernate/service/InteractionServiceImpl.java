package com.hibernate.service;

import java.util.List;
import org.springframework.transaction.annotation.Transactional; 
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

    @Transactional
    public Integer addComment(Integer userId, Integer cheatSheetId, String content, Integer parentCommentId) {
        CommentEntity comment = new CommentEntity();
        comment.setContent(content);
        User user = new User(); user.setId(userId);
        CheatsheetEntity sheet = new CheatsheetEntity(); sheet.setId(cheatSheetId);
        comment.setUser(user); comment.setCheatSheet(sheet);
        if (parentCommentId != null) {
            CommentEntity parent = new CommentEntity(); parent.setId(parentCommentId);
            comment.setParentComment(parent);
        }
        return commentRepo.insertComment(comment);
    }

    @Transactional(readOnly = true)
    public List<CommentEntity> findAllAdmin(String filter) {
        if ("mostLikes".equals(filter)) {
            return commentRepo.findAllSortedByLikesAdmin();
        } else if ("mostDislikes".equals(filter)) {
            return commentRepo.findAllSortedByDislikesAdmin();
        }
        return commentRepo.findAllCommentsForAdmin(); 
    }

    @Transactional
    public void deleteCommentAdmin(Integer commentId) {
        CommentEntity comment = commentRepo.getById(commentId);
        if (comment != null) {
            commentRepo.deleteRepliesByParentId(commentId);
            commentRepo.delete(comment);
        }
    }

    @Transactional
    public boolean editComment(Integer commentId, Integer userId, String newContent) {
        CommentEntity comment = commentRepo.getById(commentId);
        if (comment != null && comment.getUser().getId().equals(userId)) {
            comment.setContent(newContent);
            commentRepo.update(comment);
            return true;
        }
        return false;
    }

    @Transactional
    public boolean deleteComment(Integer commentId, Integer userId) {
        CommentEntity comment = commentRepo.getById(commentId);
        if (comment != null && comment.getUser().getId().equals(userId)) {
            commentRepo.deleteRepliesByParentId(commentId);
            commentRepo.delete(comment);
            return true;
        }
        return false;
    }

    @Transactional
    public String likeCheatSheet(Integer userId, Integer cheatSheetId, Boolean isLike) {
        SheetReactionEntity existing = reactionRepo.getSheetReaction(userId, cheatSheetId);
        if (existing != null) {
            if (existing.getIsLike().equals(isLike)) {
                reactionRepo.deleteSheetReaction(existing); return "removed";
            } else {
                existing.setIsLike(isLike); reactionRepo.saveOrUpdateSheetReaction(existing); return "updated";
            }
        } else {
            SheetReactionEntity newReaction = new SheetReactionEntity();
            User user = new User(); user.setId(userId);
            CheatsheetEntity sheet = new CheatsheetEntity(); sheet.setId(cheatSheetId);
            newReaction.setUser(user); newReaction.setCheatSheet(sheet); newReaction.setIsLike(isLike);
            reactionRepo.saveOrUpdateSheetReaction(newReaction); return "added";
        }
    }

    @Transactional
    public String likeComment(Integer userId, Integer commentId, Boolean isLike) {
        CommentReactionEntity existing = reactionRepo.getCommentReaction(userId, commentId);
        if (existing != null) {
            if (existing.getIsLike().equals(isLike)) {
                reactionRepo.deleteCommentReaction(existing); return "removed";
            } else {
                existing.setIsLike(isLike); reactionRepo.saveOrUpdateCommentReaction(existing); return "updated";
            }
        } else {
            CommentReactionEntity newReaction = new CommentReactionEntity();
            User user = new User(); user.setId(userId);
            CommentEntity comment = new CommentEntity(); comment.setId(commentId);
            newReaction.setUser(user); newReaction.setComment(comment); newReaction.setIsLike(isLike);
            reactionRepo.saveOrUpdateCommentReaction(newReaction); return "added";
        }
    }

    @Transactional(readOnly = true)
    public List<CommentEntity> getCommentsBySheetId(Integer sheetId, Integer currentUserId) {
        List<CommentEntity> comments = commentRepo.getCommentsBySheetId(sheetId);
        for (CommentEntity c : comments) {
            c.setLikeCount(reactionRepo.countCommentReactions(c.getId(), true));
            c.setDislikeCount(reactionRepo.countCommentReactions(c.getId(), false));
            if (currentUserId != null && currentUserId != 0) {
                CommentReactionEntity userReact = reactionRepo.getCommentReaction(currentUserId, c.getId());
                if (userReact != null) c.setCurrentUserReaction(userReact.getIsLike());
            }
        }
        return comments;
    }

    @Transactional(readOnly = true)
    public SheetReactionEntity getSheetReaction(Integer userId, Integer sheetId) { 
        return reactionRepo.getSheetReaction(userId, sheetId); 
    }

    @Transactional(readOnly = true)
    public Long countSheetReactions(Integer sheetId, Boolean isLike) { 
        return reactionRepo.countSheetReactions(sheetId, isLike); 
    }

    @Transactional(readOnly = true)
    public Long countCommentReactions(Integer commentId, Boolean isLike) { 
        return reactionRepo.countCommentReactions(commentId, isLike); 
    }
}