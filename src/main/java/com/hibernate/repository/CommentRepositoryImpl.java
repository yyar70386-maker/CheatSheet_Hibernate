package com.hibernate.repository;

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

    // Reply ပြန်တဲ့အခါ Parent Comment ကို ရှာရန်
    public CommentEntity getById(Integer id) {
        return getSession().get(CommentEntity.class, id);
    }
}