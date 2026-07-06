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
    
    public Session getSession() { return sessionFactory.getCurrentSession(); }

    public Integer insertComment(CommentEntity obj) { return (Integer) getSession().save(obj); }
    public CommentEntity getById(Integer id) { return getSession().get(CommentEntity.class, id); }
    
    // Void type ဖြစ်သည့်အတွက် return မလိုတော့ပါ
    public void update(CommentEntity obj) { 
        getSession().saveOrUpdate(obj); 
    }
    
    public void delete(CommentEntity obj) { getSession().delete(obj); }

    public void deleteRepliesByParentId(Integer parentId) {
        String hql = "DELETE FROM CommentEntity c WHERE c.parentComment.id = :pId";
        getSession().createQuery(hql).setParameter("pId", parentId).executeUpdate();
    }

    public List<CommentEntity> getCommentsBySheetId(Integer sheetId) {
        String hql = "SELECT c FROM CommentEntity c JOIN FETCH c.user LEFT JOIN FETCH c.parentComment WHERE c.cheatSheet.id = :sheetId ORDER BY c.id ASC";
        return getSession().createQuery(hql, CommentEntity.class).setParameter("sheetId", sheetId).getResultList();
    }

    public List<CommentEntity> findAllCommentsForAdmin() {
        String hql = "SELECT c FROM CommentEntity c LEFT JOIN FETCH c.user LEFT JOIN FETCH c.cheatSheet ORDER BY c.id DESC";
        return getSession().createQuery(hql, CommentEntity.class).getResultList();
    }

    public List<CommentEntity> findAllSortedByLikesAdmin() {
        String hql = "SELECT c FROM CommentEntity c LEFT JOIN FETCH c.user LEFT JOIN FETCH c.cheatSheet " +
                     "LEFT JOIN CommentReactionEntity r ON r.comment.id = c.id AND r.isLike = true " +
                     "GROUP BY c.id ORDER BY COUNT(r.id) DESC";
        return getSession().createQuery(hql, CommentEntity.class).getResultList();
    }

    public List<CommentEntity> findAllSortedByDislikesAdmin() {
        String hql = "SELECT c FROM CommentEntity c LEFT JOIN FETCH c.user LEFT JOIN FETCH c.cheatSheet " +
                     "LEFT JOIN CommentReactionEntity r ON r.comment.id = c.id AND r.isLike = false " +
                     "GROUP BY c.id ORDER BY COUNT(r.id) DESC";
        return getSession().createQuery(hql, CommentEntity.class).getResultList();
    }

    public long countAll() {
        Long count = getSession()
                .createQuery("select count(c) from CommentEntity c", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }
}
