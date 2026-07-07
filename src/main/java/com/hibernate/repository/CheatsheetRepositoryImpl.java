package com.hibernate.repository;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.ResultTransformer;
import org.hibernate.type.IntegerType;
import org.hibernate.type.LongType;
import org.hibernate.type.StringType;
import org.hibernate.type.TimestampType;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.CheatSheetReportEntity;
import com.hibernate.entity.TagEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CheatsheetRepositoryImpl implements CheatsheetRepository {

    private final SessionFactory sessionFactory;
    
    public Session getSession() { 
        return sessionFactory.getCurrentSession(); 
    }

    @SuppressWarnings("unchecked")
    @Override
    public List<Object[]> callStoredProcedureForTagCounts(Integer categoryId, Integer currentUserId) {
        return getSession()
                .createNativeQuery("CALL GetActiveTagCountsWithPrivacy(:catId, :userId)")
                .setParameter("catId", categoryId)
                .setParameter("userId", currentUserId != null ? currentUserId : 0)
                .list();
    }

    @Override
    public List<CheatsheetEntity> findByUserIdAndVisibilityList(Integer userId, List<String> visibilities) {
        if (visibilities == null || visibilities.isEmpty()) {
            return new java.util.ArrayList<>();
        }
        
        String hql = "select distinct c from CheatsheetEntity c "
                   + "left join fetch c.tags "
                   + "left join fetch c.author "
                   + "where c.author.id = :userId "
                   + "and c.visibility in (:visibilities) "
                   + "and c.status = 'active' "
                   + "order by c.id desc";
                   
        return getSession().createQuery(hql, CheatsheetEntity.class)
                .setParameter("userId", userId)
                .setParameterList("visibilities", visibilities)
                .list();
    }

    @Override
    public int getTotalSheetsCount() {
        String hql = "SELECT COUNT(c) FROM CheatsheetEntity c"; 
        Long count = (Long) getSession().createQuery(hql).uniqueResult();
        return count != null ? count.intValue() : 0;
    }

    @Override
    public Integer save(CheatsheetEntity cheatsheet) {
        return (Integer) getSession().save(cheatsheet);
    }

    @Override
    public List<CheatsheetEntity> findAll() {
        return getSession().createQuery("select distinct c from CheatsheetEntity c left join fetch c.tags left join fetch c.author where c.status='active'", CheatsheetEntity.class).list();
    }

    @Override
    public CheatsheetEntity findById(Integer id) {
        return getSession().createQuery("select distinct c from CheatsheetEntity c left join fetch c.tags left join fetch c.author where c.id = :id", CheatsheetEntity.class).setParameter("id", id).uniqueResult();
    }

    @Override
    public List<CheatsheetEntity> findByUserId(Integer userId) {
        String hql = "select distinct c from CheatsheetEntity c left join fetch c.tags left join fetch c.author where c.author.id = :userId and c.status in ('active', 'draft', 'banned') order by c.id desc";
        return getSession().createQuery(hql, CheatsheetEntity.class).setParameter("userId", userId).list();
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
            old.setStatus(cheatsheet.getStatus());
            
            // 🌟 [UPDATED] Checkbox ကြောင့် Null သက်ရောက်လာမှုအား Database သို့ တိုက်ရိုက် Overwrite လုပ်ရန် ညှိနှိုင်းခြင်း
            old.setImagePath(cheatsheet.getImagePath());
            if (cheatsheet.getAuthor() != null) old.setAuthor(cheatsheet.getAuthor());
            
            getSession().merge(old);
        }
    }

    @Override
    public void delete(Integer id) {
        CheatsheetEntity cheatsheet = findById(id);
        if (cheatsheet != null) {
            cheatsheet.setStatus("inactive"); 
            getSession().merge(cheatsheet);
        }
    }

    @Override
    public List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId, String filter) {
        int offset = (page - 1) * size;
        StringBuilder hql = new StringBuilder("select distinct c from CheatsheetEntity c left join fetch c.tags left join fetch c.author where c.category.id = :catId and c.status='active' and c.visibility != 'PRIVATE' ");
        if (currentUserId == null || currentUserId == 0) { 
            hql.append("and c.visibility = 'PUBLIC' "); 
        } else { 
            hql.append("and (c.visibility = 'PUBLIC' or c.author.id = :currentUserId or (c.visibility = 'FRIEND-ONLY' and c.author.id in (select f.following.id from UserFollowEntity f where f.follower.id = :currentUserId))) "); 
        }
        if ("PUBLIC".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'PUBLIC' ");
        else if ("FRIEND".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'FRIEND-ONLY' ");
        hql.append("order by c.id desc");
        var query = getSession().createQuery(hql.toString(), CheatsheetEntity.class).setParameter("catId", categoryId);
        if (currentUserId != null && currentUserId > 0) query.setParameter("currentUserId", currentUserId);
        return query.setFirstResult(offset).setMaxResults(size).list();
    }

    @Override
    public long countByCategoryId(Integer categoryId, Integer currentUserId, String filter) {
        StringBuilder hql = new StringBuilder("select count(distinct c) from CheatsheetEntity c where c.category.id = :catId and c.status='active' and c.visibility != 'PRIVATE' ");
        if (currentUserId == null || currentUserId == 0) { 
            hql.append("and c.visibility = 'PUBLIC' "); 
        } else { 
            hql.append("and (c.visibility = 'PUBLIC' or c.author.id = :currentUserId or (c.visibility = 'FRIEND-ONLY' and c.author.id in (select f.following.id from UserFollowEntity f where f.follower.id = :currentUserId))) "); 
        }
        if ("PUBLIC".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'PUBLIC' ");
        else if ("FRIEND".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'FRIEND-ONLY' ");
        var query = getSession().createQuery(hql.toString(), Long.class).setParameter("catId", categoryId);
        if (currentUserId != null && currentUserId > 0) query.setParameter("currentUserId", currentUserId);
        Long count = query.uniqueResult(); 
        return count != null ? count : 0;
    }

    @Override
    public List<TagEntity> findTagsByCategoryId(Integer categoryId) {
        return getSession().createQuery("from TagEntity t where t.category.id = :catId and t.status='active'", TagEntity.class).setParameter("catId", categoryId).list();
    }

    @Override
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter) {
        int offset = (page - 1) * size;
        StringBuilder hql = new StringBuilder("select distinct c from CheatsheetEntity c join c.tags t left join fetch c.tags left join fetch c.author where t.id = :tagId and c.status = 'active' and c.visibility != 'PRIVATE' ");
        if (currentUserId == null || currentUserId == 0) { 
            hql.append("and c.visibility = 'PUBLIC' "); 
        } else { 
            hql.append("and (c.visibility = 'PUBLIC' or c.author.id = :currentUserId or (c.visibility = 'FRIEND-ONLY' and c.author.id in (select f.following.id from UserFollowEntity f where f.follower.id = :currentUserId))) "); 
        }
        if ("PUBLIC".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'PUBLIC' ");
        else if ("FRIEND".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'FRIEND-ONLY' ");
        hql.append("order by c.id desc");
        var query = getSession().createQuery(hql.toString(), CheatsheetEntity.class).setParameter("tagId", tagId);
        if (currentUserId != null && currentUserId > 0) query.setParameter("currentUserId", currentUserId);
        return query.setFirstResult(offset).setMaxResults(size).list();
    }

    @Override
    public long countByTagId(Integer tagId, Integer currentUserId, String filter) {
        StringBuilder hql = new StringBuilder("select count(distinct c) from CheatsheetEntity c join c.tags t where t.id = :tagId and c.status = 'active' and c.visibility != 'PRIVATE' ");
        if (currentUserId == null || currentUserId == 0) { 
            hql.append("and c.visibility = 'PUBLIC' "); 
        } else { 
            hql.append("and (c.visibility = 'PUBLIC' or c.author.id = :currentUserId or (c.visibility = 'FRIEND-ONLY' and c.author.id in (select f.following.id from UserFollowEntity f where f.follower.id = :currentUserId))) "); 
        }
        if ("PUBLIC".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'PUBLIC' ");
        else if ("FRIEND".equalsIgnoreCase(filter)) hql.append("and c.visibility = 'FRIEND-ONLY' ");
        var query = getSession().createQuery(hql.toString(), Long.class).setParameter("tagId", tagId);
        if (currentUserId != null && currentUserId > 0) query.setParameter("currentUserId", currentUserId);
        Long count = query.uniqueResult(); 
        return count != null ? count : 0;
    }

    @Override
    public List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String hql = "select distinct c from CheatsheetEntity c left join fetch c.author left join fetch c.category left join fetch c.tags where c.status = 'active' and c.visibility = 'PUBLIC' and (:keyword = '' or lower(c.title) like :likeKeyword or lower(c.description) like :likeKeyword or lower(c.content) like :likeKeyword) order by c.createdAt desc, c.id desc";
        return getSession().createQuery(hql, CheatsheetEntity.class).setParameter("keyword", search).setParameter("likeKeyword", "%" + search + "%").setFirstResult((page - 1) * size).setMaxResults(size).list();
    }

    @Override
    public List<CheatsheetEntity> findPopularPublic(int size) {
        String hql = "select distinct c from CheatsheetEntity c "
                + "left join fetch c.author left join fetch c.category left join fetch c.tags "
                + "where c.status = 'active' and c.visibility = 'PUBLIC' "
                + "order by "
                + "((select count(sr) from SheetReactionEntity sr where sr.cheatSheet.id = c.id and sr.isLike = true) * 3 "
                + "+ coalesce(c.viewCount, 0) "
                + "+ (select coalesce(avg(r.stars), 0) from RatingEntity r where r.cheatSheet.id = c.id) * 10) desc, "
                + "c.createdAt desc, c.id desc";
        return getSession().createQuery(hql, CheatsheetEntity.class)
                .setMaxResults(size)
                .list();
    }

    @Override
    public List<CheatsheetEntity> findPublicCreatedBetween(java.sql.Timestamp start, java.sql.Timestamp end) {
        String hql = "select distinct c from CheatsheetEntity c "
                + "left join fetch c.author left join fetch c.category left join fetch c.tags "
                + "where c.status = 'active' and c.visibility = 'PUBLIC' "
                + "and c.createdAt >= :start and c.createdAt < :end "
                + "order by c.createdAt desc, c.id desc";
        return getSession().createQuery(hql, CheatsheetEntity.class)
                .setParameter("start", start)
                .setParameter("end", end)
                .list();
    }

    @Override
    public long countLatestPublic(String keyword) {
        String search = keyword == null ? "" : keyword.trim().toLowerCase();
        String hql = "select count(distinct c) from CheatsheetEntity c where c.status = 'active' and c.visibility = 'PUBLIC' and (:keyword = '' or lower(c.title) like :likeKeyword or lower(c.description) like :likeKeyword or lower(c.content) like :likeKeyword)";
        Long count = getSession().createQuery(hql, Long.class).setParameter("keyword", search).setParameter("likeKeyword", "%" + search + "%").uniqueResult(); 
        return count != null ? count : 0;
    }

    @Override
    public long countAllActive() {
        Long count = getSession().createQuery("select count(c) from CheatsheetEntity c where c.status = 'active'", Long.class).uniqueResult(); 
        return count != null ? count : 0;
    }

    @Override
    public List<CheatsheetEntity> searchAll(String keyword, String categoryId, String status, String banned, int page, int size) {
        StringBuilder hql = new StringBuilder("select distinct c from CheatsheetEntity c left join fetch c.author left join fetch c.category WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (lower(c.title) LIKE :keyword OR lower(c.description) LIKE :keyword)");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            hql.append(" AND c.category.id = :categoryId");
        }
        if (status != null && !status.isEmpty()) {
            hql.append(" AND c.status = :status");
        }
        if (banned != null && !banned.isEmpty()) {
            hql.append(" AND c.banned = :banned");
        }
        hql.append(" ORDER BY c.id DESC");
        
        var query = getSession().createQuery(hql.toString(), CheatsheetEntity.class);
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            query.setParameter("categoryId", Integer.parseInt(categoryId));
        }
        if (status != null && !status.isEmpty()) {
            query.setParameter("status", status);
        }
        if (banned != null && !banned.isEmpty()) {
            query.setParameter("banned", Boolean.parseBoolean(banned));
        }
        
        query.setFirstResult((page - 1) * size);
        query.setMaxResults(size);
        return query.list();
    }

    @Override
    public long countSearchAll(String keyword, String categoryId, String status, String banned) {
        StringBuilder hql = new StringBuilder("select count(distinct c) from CheatsheetEntity c WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (lower(c.title) LIKE :keyword OR lower(c.description) LIKE :keyword)");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            hql.append(" AND c.category.id = :categoryId");
        }
        if (status != null && !status.isEmpty()) {
            hql.append(" AND c.status = :status");
        }
        if (banned != null && !banned.isEmpty()) {
            hql.append(" AND c.banned = :banned");
        }
        
        var query = getSession().createQuery(hql.toString(), Long.class);
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }
        if (categoryId != null && !categoryId.isEmpty()) {
            query.setParameter("categoryId", Integer.parseInt(categoryId));
        }
        if (status != null && !status.isEmpty()) {
            query.setParameter("status", status);
        }
        if (banned != null && !banned.isEmpty()) {
            query.setParameter("banned", Boolean.parseBoolean(banned));
        }
        
        Long count = query.uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public long countBanned() {
        Long count = getSession()
                .createQuery("select count(c) from CheatsheetEntity c where c.banned = true", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public long countPublished() {
        Long count = getSession()
                .createQuery("select count(c) from CheatsheetEntity c where c.status = 'active' and c.banned = false", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }

    @SuppressWarnings({ "unchecked", "deprecation" })
    @Override
    public List<CheatSheetReportEntity> findCheatsheetReportData(String startDate, String endDate) {
        String sql = "SELECT c.id, c.title, u.username, c.created_at, " +
                     "(SELECT COUNT(*) FROM sheet_reactions sr WHERE sr.cheatsheet_id = c.id) AS reaction_count " +
                     "FROM cheatsheets c " +
                     "LEFT JOIN users u ON c.author_id = u.id " +
                     "WHERE c.deleted_at IS NULL ";
        
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql += "AND c.created_at >= :startDate ";
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql += "AND c.created_at <= :endDate ";
        }
        
        sql += "ORDER BY c.created_at DESC";
        
        var query = getSession().createNativeQuery(sql)
                .addScalar("id", IntegerType.INSTANCE)
                .addScalar("title", StringType.INSTANCE)
                .addScalar("username", StringType.INSTANCE)
                .addScalar("created_at", TimestampType.INSTANCE)
                .addScalar("reaction_count", LongType.INSTANCE);
                
        if (startDate != null && !startDate.trim().isEmpty()) {
            query.setParameter("startDate", java.sql.Timestamp.valueOf(startDate + " 00:00:00"));
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.setParameter("endDate", java.sql.Timestamp.valueOf(endDate + " 23:59:59"));
        }

        return query.setResultTransformer(new ResultTransformer() {
            @Override
            public Object transformTuple(Object[] tuple, String[] aliases) {
                CheatSheetReportEntity report = new CheatSheetReportEntity();
                report.setNo(((Number) tuple[0]).intValue());
                report.setCheatsheetName((String) tuple[1]);
                report.setCreatedUser((String) tuple[2]);
                java.sql.Timestamp ts = (java.sql.Timestamp) tuple[3];
                if (ts != null) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    report.setCreatedDate(sdf.format(ts));
                } else {
                    report.setCreatedDate("");
                }
                Number rc = (Number) tuple[4];
                report.setReactionCount(rc != null ? rc.longValue() : 0L);
                return report;
            }

            @Override
            public List transformList(List collection) {
                return collection;
            }
        }).list();
    }

    @Override
    public List<Object[]> getMonthlyCheatsheetCounts(int year) {
        String hql = "select month(c.createdAt), count(c) from CheatsheetEntity c " +
                     "where year(c.createdAt) = :year group by month(c.createdAt)";
        return getSession().createQuery(hql, Object[].class)
                .setParameter("year", year)
                .list();
    }
}