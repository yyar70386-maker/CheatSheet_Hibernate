package com.hibernate.repository;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.CommentEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CommentRepositoryImpl {
    
    private final SessionFactory sessionFactory;
    
    public Session getSession() { 
        return sessionFactory.getCurrentSession(); 
    }

    public Integer insertComment(CommentEntity obj) {
        return (Integer) getSession().save(obj);
    }

    public CommentEntity getById(Integer id) {
        return getSession().get(CommentEntity.class, id);
    }

    // 🌟 ဤနေရာတွင် JOIN FETCH ထည့်သွင်း၍ LazyInitializationException အား ဖြေရှင်းထားသည်
    public List<CommentEntity> getCommentsBySheetId(Integer sheetId) {
        String hql = "SELECT c FROM CommentEntity c " +
                     "JOIN FETCH c.user " +                 // User Data ကို တစ်ခါတည်း ဆွဲထုတ်ရန်
                     "LEFT JOIN FETCH c.parentComment " +   // Reply (Parent Comment) ကိုပါ တစ်ခါတည်း ဆွဲထုတ်ရန်
                     "WHERE c.cheatSheet.id = :sheetId ORDER BY c.id ASC";
                     
        return getSession().createQuery(hql, CommentEntity.class)
                .setParameter("sheetId", sheetId)
                .getResultList();
    }
}