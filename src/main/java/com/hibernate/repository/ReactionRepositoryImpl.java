package com.hibernate.repository;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.CommentReactionEntity;
import com.hibernate.entity.SheetReactionEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReactionRepositoryImpl {
    private final SessionFactory sessionFactory;
    
    public Session getSession() { return sessionFactory.getCurrentSession(); }

    // --- Comment Reaction အပိုင်း ---
    public void saveOrUpdateCommentReaction(CommentReactionEntity obj) {
        getSession().saveOrUpdate(obj);
    }

    public CommentReactionEntity getCommentReaction(Integer userId, Integer commentId) {
        String hql = "FROM CommentReactionEntity c WHERE c.user.id = :userId AND c.comment.id = :commentId";
        return getSession().createQuery(hql, CommentReactionEntity.class)
                .setParameter("userId", userId)
                .setParameter("commentId", commentId)
                .uniqueResult();
    }

    // --- Sheet Reaction အပိုင်း ---
    public void saveOrUpdateSheetReaction(SheetReactionEntity obj) {
        getSession().saveOrUpdate(obj);
    }

    public SheetReactionEntity getSheetReaction(Integer userId, Integer sheetId) {
        String hql = "FROM SheetReactionEntity s WHERE s.user.id = :userId AND s.cheatSheet.id = :sheetId";
        return getSession().createQuery(hql, SheetReactionEntity.class)
                .setParameter("userId", userId)
                .setParameter("sheetId", sheetId)
                .uniqueResult();
    }
}