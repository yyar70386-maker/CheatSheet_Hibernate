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

    public long countAll() {
        Long count = getSession()
                .createQuery("select count(c) from CommentEntity c", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }

    public List<CommentEntity> searchComments(String keyword, String status, int page, int size) {
        StringBuilder hql = new StringBuilder("SELECT c FROM CommentEntity c JOIN FETCH c.user JOIN FETCH c.cheatSheet WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (lower(c.content) LIKE :keyword OR lower(c.user.username) LIKE :keyword)");
        }
        if (status != null && !status.isEmpty()) {
            if ("banned".equalsIgnoreCase(status)) {
                hql.append(" AND c.banned = true");
            } else if ("active".equalsIgnoreCase(status)) {
                hql.append(" AND c.banned = false");
            }
        }
        hql.append(" ORDER BY c.id DESC");
        
        var query = getSession().createQuery(hql.toString(), CommentEntity.class);
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }
        
        query.setFirstResult((page - 1) * size);
        query.setMaxResults(size);
        return query.list();
    }

    public long countSearchComments(String keyword, String status) {
        StringBuilder hql = new StringBuilder("SELECT count(c) FROM CommentEntity c WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (lower(c.content) LIKE :keyword OR lower(c.user.username) LIKE :keyword)");
        }
        if (status != null && !status.isEmpty()) {
            if ("banned".equalsIgnoreCase(status)) {
                hql.append(" AND c.banned = true");
            } else if ("active".equalsIgnoreCase(status)) {
                hql.append(" AND c.banned = false");
            }
        }
        
        var query = getSession().createQuery(hql.toString(), Long.class);
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }
        
        Long count = query.uniqueResult();
        return count != null ? count : 0;
    }

    public void updateComment(CommentEntity comment) {
        getSession().merge(comment);
    }

    public void deleteComment(Integer id) {
        CommentEntity comment = getById(id);
        if (comment != null) {
            getSession().delete(comment);
        }
    }

    public long countBanned() {
        Long count = getSession()
                .createQuery("select count(c) from CommentEntity c where c.banned = true", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }
}
