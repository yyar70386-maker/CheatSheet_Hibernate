package com.hibernate.repository;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CheatsheetRepositoryImpl implements CheatsheetRepository {

    private final SessionFactory sessionFactory;
    
    @Override
    public int getTotalSheetsCount() {
        String hql = "SELECT COUNT(c) FROM CheatsheetEntity c"; 
        Long count = (Long) getSession().createQuery(hql).uniqueResult();
        return count != null ? count.intValue() : 0;
    }

    public Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Integer save(CheatsheetEntity cheatsheet) {
        return (Integer) getSession().save(cheatsheet);
    }

    @Override
    public List<CheatsheetEntity> findAll() {
        return getSession()
                .createQuery(
                        "select distinct c from CheatsheetEntity c "
                      + "left join fetch c.tags "
                      + "left join fetch c.author "
                      + "where c.status='active'",
                        CheatsheetEntity.class)
                .list();
    }

    @Override
    public CheatsheetEntity findById(Integer id) {
        return getSession()
                .createQuery(
                        "select distinct c from CheatsheetEntity c "
                      + "left join fetch c.tags "
                      + "left join fetch c.author "
                      + "where c.id = :id",
                        CheatsheetEntity.class)
                .setParameter("id", id)
                .uniqueResult();
    }

    @Override
    public List<CheatsheetEntity> findByUserId(Integer userId) {
        String hql = "select distinct c from CheatsheetEntity c "
                   + "left join fetch c.tags "
                   + "left join fetch c.author "
                   + "where c.author.id = :userId and c.status='active' "
                   + "order by c.id desc";
                   
        return getSession()
                .createQuery(hql, CheatsheetEntity.class)
                .setParameter("userId", userId)
                .list();
    }
    
    @Override
    public void update(CheatsheetEntity cheatsheet) {
        CheatsheetEntity old = findById(cheatsheet.getId());
        if (old != null) {
            old.setTitle(cheatsheet.getTitle());
            old.setDescription(cheatsheet.getDescription());
            old.setContent(cheatsheet.getContent());
            old.setCategory(cheatsheet.getCategory());
            old.setTags(cheatsheet.getTags());
            old.setViewCount(cheatsheet.getViewCount());
            old.setDownloadCount(cheatsheet.getDownloadCount());
            old.setVisibility(cheatsheet.getVisibility()); 
            
            if (cheatsheet.getAuthor() != null) {
                old.setAuthor(cheatsheet.getAuthor());
            }
            getSession().update(old);
        }
    }

    @Override
    public void delete(Integer id) {
        CheatsheetEntity cheatsheet = findById(id);
        if (cheatsheet != null) {
            cheatsheet.setStatus("inactive");
            getSession().update(cheatsheet);
        }
    }

    @Override
    public List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId) {
        int offset = (page - 1) * size;
        
        String hql = "select distinct c from CheatsheetEntity c "
                   + "left join fetch c.tags "
                   + "left join fetch c.author "
                   + "where c.category.id = :catId and c.status='active' "
                   + "and (c.visibility = 'PUBLIC' "
                   + "     or (c.visibility = 'PRIVATE' and c.author.id = :currentUserId) "
                   + "     or (c.visibility = 'FRIEND-ONLY' and c.author.id = :currentUserId)) " 
                   + "order by c.id desc";
        
        return getSession()
                .createQuery(hql, CheatsheetEntity.class)
                .setParameter("catId", categoryId)
                .setParameter("currentUserId", currentUserId)
                .setFirstResult(offset)
                .setMaxResults(size)
                .list();
    }

    @Override
    public long countByCategoryId(Integer categoryId, Integer currentUserId) {
        String hql = "select count(distinct c) from CheatsheetEntity c "
                   + "where c.category.id = :catId and c.status='active' "
                   + "and (c.visibility = 'PUBLIC' "
                   + "     or (c.visibility = 'PRIVATE' and c.author.id = :currentUserId) "
                   + "     or (c.visibility = 'FRIEND-ONLY' and c.author.id = :currentUserId))";
                   
        return getSession()
                .createQuery(hql, Long.class)
                .setParameter("catId", categoryId)
                .setParameter("currentUserId", currentUserId)
                .uniqueResult();
    }

    @Override
    public List<TagEntity> findTagsByCategoryId(Integer categoryId) {
        return getSession()
                .createQuery(
                        "from TagEntity t "
                      + "where t.category.id = :catId and t.status='active'", 
                        TagEntity.class)
                .setParameter("catId", categoryId)
                .list();
    }

    @Override
    public List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId) {
        return getSession()
                .createQuery(
                        "select t.id, count(c.id) from TagEntity t "
                      + "left join t.cheatsheets c "
                      + "where t.category.id = :catId and t.status = 'active' "
                      + "and (c.id is null or (c.status = 'active' and c.visibility = 'PUBLIC')) "
                      + "group by t.id", Object[].class)
                .setParameter("catId", categoryId)
                .list();
    }

    @Override
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId) {
        return getSession()
                .createQuery(
                        "select distinct c from CheatsheetEntity c "
                      + "join c.tags t "
                      + "left join fetch c.tags "
                      + "left join fetch c.author "
                      + "where t.id = :tagId and c.status = 'active' and c.visibility = 'PUBLIC' "
                      + "order by c.id desc", CheatsheetEntity.class)
                .setParameter("tagId", tagId)
                .list();
    }

    @Override
    public List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String hql = "select distinct c from CheatsheetEntity c "
                   + "left join fetch c.author "
                   + "left join fetch c.category "
                   + "left join fetch c.tags "
                   + "where c.status = 'active' and c.visibility = 'PUBLIC' "
                   + "and (:keyword = '' or lower(c.title) like :likeKeyword "
                   + "or lower(c.description) like :likeKeyword "
                   + "or lower(c.content) like :likeKeyword) "
                   + "order by c.createdAt desc, c.id desc";

        return getSession()
                .createQuery(hql, CheatsheetEntity.class)
                .setParameter("keyword", search)
                .setParameter("likeKeyword", "%" + search + "%")
                .setFirstResult((page - 1) * size)
                .setMaxResults(size)
                .list();
    }

    @Override
    public long countLatestPublic(String keyword) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String hql = "select count(distinct c) from CheatsheetEntity c "
                   + "where c.status = 'active' and c.visibility = 'PUBLIC' "
                   + "and (:keyword = '' or lower(c.title) like :likeKeyword "
                   + "or lower(c.description) like :likeKeyword "
                   + "or lower(c.content) like :likeKeyword)";

        Long count = getSession()
                .createQuery(hql, Long.class)
                .setParameter("keyword", search)
                .setParameter("likeKeyword", "%" + search + "%")
                .uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public long countAllActive() {
        Long count = getSession()
                .createQuery("select count(c) from CheatsheetEntity c where c.status = 'active'", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }

    // 🌟 ADMIN Dashboard အတွက် Sorting Queries
    @Override
    public List<CheatsheetEntity> findAllSortedByLikes() {
        String hql = "SELECT c FROM CheatsheetEntity c " +
                     "LEFT JOIN SheetReactionEntity r ON r.cheatSheet.id = c.id AND r.isLike = true " +
                     "WHERE c.status = 'active' " +
                     "GROUP BY c.id ORDER BY COUNT(r.id) DESC";
        return getSession().createQuery(hql, CheatsheetEntity.class).list();
    }

    @Override
    public List<CheatsheetEntity> findAllSortedByDislikes() {
        String hql = "SELECT c FROM CheatsheetEntity c " +
                     "LEFT JOIN SheetReactionEntity r ON r.cheatSheet.id = c.id AND r.isLike = false " +
                     "WHERE c.status = 'active' " +
                     "GROUP BY c.id ORDER BY COUNT(r.id) DESC";
        return getSession().createQuery(hql, CheatsheetEntity.class).list();
    }
}