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
    
 // 🌟 စုစုပေါင်း Cheatsheets အရေအတွက်ကို ဒေတာဘေ့စ်ကနေ HQL နဲ့ လှမ်းရေတွက်မည့် မက်သတ်
    @Override
    public int getTotalSheetsCount() {
        // 💡 မှတ်ချက်။ ။ CheatsheetEntity နေရာတွင် မိမိဆောက်ထားသော Entity Class နာမည်အတိုင်း ဖြစ်ရပါမည်
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
            
            // 🌟 Visibility ပြောင်းလဲမှုကိုပါ Database တွင် Update ဖြစ်စေရန် ဖြည့်စွက်ခြင်း
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

    // ==================== 🌟 VISIBILITY & PAGINATION SQL LOGIC ====================

    @Override
    public List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId) {
        int offset = (page - 1) * size;
        
        // 🌟 FollowEntity ပါဝင်သော FRIEND-ONLY စစ်ဆေးချက်ကို ခေတ္တဖယ်ရှားထားသော Query
        String hql = "select distinct c from CheatsheetEntity c "
                   + "left join fetch c.tags "
                   + "left join fetch c.author "
                   + "where c.category.id = :catId and c.status='active' "
                   + "and (c.visibility = 'PUBLIC' "
                   + "     or (c.visibility = 'PRIVATE' and c.author.id = :currentUserId) "
                   + "     or (c.visibility = 'FRIEND-ONLY' and c.author.id = :currentUserId)) " // 👈 ရောဂါကင်းအောင် မိမိကိုယ်တိုင်ဆိုရင် မြင်ရအောင်ပဲ ခေတ္တပြင်ထားပါသည်
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
        // 🌟 Count အတွက် Query ကိုပါ လိုက်လံညှိနှိုင်းပေးခြင်း
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
        // 🌟 Visibility 'PUBLIC' ဖြစ်ပြီး active ဖြစ်နေသည့် cheatsheet ထဲက tag အရေအတွက်ကိုပဲ စစ်ထုတ်ရေတွက်ခြင်း
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
        // 🌟 Tag ID အလိုက် ချိတ်ဆက်ထားပြီး Visibility PUBLIC ဖြစ်သော စာရင်းကိုပဲ ယူခြင်း
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
}