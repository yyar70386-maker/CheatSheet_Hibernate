package com.hibernate.repository;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.CommentReactionEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CommentReactionRepositoryImpl {
    
    private final SessionFactory sessionFactory;
    
    public Session getSession() { 
        return sessionFactory.getCurrentSession(); 
    }

    public void saveOrUpdateReaction(CommentReactionEntity obj) {
        getSession().saveOrUpdate(obj);
    }

    // User တစ်ယောက်က ဒီ Comment ကို Like ပေးပြီးသားလား စစ်ရန်
    public CommentReactionEntity getReaction(Integer userId, Integer commentId) {
        String hql = "FROM CommentReactionEntity c WHERE c.user.id = :uId AND c.comment.id = :cId";
        return getSession().createQuery(hql, CommentReactionEntity.class)
                .setParameter("uId", userId)
                .setParameter("cId", commentId)
                .uniqueResult();
    }
}