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

    public SheetReactionEntity getSheetReaction(Integer userId, Integer sheetId) {
        String hql = "FROM SheetReactionEntity r WHERE r.user.id = :uId AND r.cheatSheet.id = :sId";
        return getSession().createQuery(hql, SheetReactionEntity.class)
                .setParameter("uId", userId).setParameter("sId", sheetId).uniqueResult();
    }
    public void saveOrUpdateSheetReaction(SheetReactionEntity obj) { getSession().saveOrUpdate(obj); }
    public void deleteSheetReaction(SheetReactionEntity obj) { getSession().delete(obj); }

    public CommentReactionEntity getCommentReaction(Integer userId, Integer commentId) {
        String hql = "FROM CommentReactionEntity r WHERE r.user.id = :uId AND r.comment.id = :cId";
        return getSession().createQuery(hql, CommentReactionEntity.class)
                .setParameter("uId", userId).setParameter("cId", commentId).uniqueResult();
    }
    public void saveOrUpdateCommentReaction(CommentReactionEntity obj) { getSession().saveOrUpdate(obj); }
    public void deleteCommentReaction(CommentReactionEntity obj) { getSession().delete(obj); }

    // 🌟 CheatSheet အတွက် Like/Dislike ရေတွက်ရန်
    public Long countSheetReactions(Integer sheetId, Boolean isLike) {
        String hql = "SELECT COUNT(r) FROM SheetReactionEntity r WHERE r.cheatSheet.id = :sId AND r.isLike = :isLike";
        return (Long) getSession().createQuery(hql).setParameter("sId", sheetId).setParameter("isLike", isLike).uniqueResult();
    }

    // 🌟 Comment အတွက် Like/Dislike ရေတွက်ရန်
    public Long countCommentReactions(Integer commentId, Boolean isLike) {
        String hql = "SELECT COUNT(r) FROM CommentReactionEntity r WHERE r.comment.id = :cId AND r.isLike = :isLike";
        return (Long) getSession().createQuery(hql).setParameter("cId", commentId).setParameter("isLike", isLike).uniqueResult();
    }
}