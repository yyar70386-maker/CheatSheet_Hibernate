package com.hibernate.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.TagEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class TagRepositoryImpl implements TagRepository {

    private final SessionFactory sessionFactory;

    public Session getSession() {
        return sessionFactory.getCurrentSession();
    }
 // 🌟 စုစုပေါင်း Tags အရေအတွက်ကို ဒေတာဘေ့စ်ကနေ HQL နဲ့ လှမ်းရေတွက်မည့် မက်သတ်
    @Override
    public int getTotalTagsCount() {
        // 💡 မှတ်ချက်။ ။ တကယ်လို့ မိမိရဲ့ Tag Entity Class နာမည်က TagEntity မဟုတ်ဘဲ Tag ဖြစ်နေရင် အောက်ကစာသားမှာ လိုက်ပြင်ပေးပါ
        String hql = "SELECT COUNT(t) FROM TagEntity t";
        
        Long count = (Long) getSession().createQuery(hql).uniqueResult();
        
        return count != null ? count.intValue() : 0;
    }

    @Override
    public Integer save(TagEntity tag) {
        return (Integer) getSession().save(tag);
    }

    @Override
    public List<TagEntity> findAll() {

        return getSession()
                .createQuery(
                        "from TagEntity where status='active'",
                        TagEntity.class)
                .list();
    }

    @Override
    public TagEntity findById(Integer id) {
        return getSession().get(TagEntity.class, id);
    }

    @Override
    public void update(TagEntity tag) {

        TagEntity oldTag = findById(tag.getId());

        if (oldTag != null) {

            oldTag.setName(tag.getName());
            oldTag.setCategory(tag.getCategory());

            getSession().update(oldTag);
        }
    }

    @Override
    public void delete(Integer id) {

        TagEntity tag = findById(id);

        if (tag != null) {

            tag.setStatus("inactive");

            getSession().update(tag);
        }
    }
    
    @Override
    public List<TagEntity> findByCategoryId(Integer categoryId) {
        return getSession()
                .createQuery(
                    "from TagEntity t where t.category.id=:categoryId and t.status='active'",
                    TagEntity.class)
                .setParameter("categoryId", categoryId)
                .list();
    }

    @Override
    public List<TagEntity> findByIds(List<Integer> ids) {
        return getSession()
                .createQuery("from TagEntity t where t.id in (:ids)", TagEntity.class)
                .setParameterList("ids", ids)
                .list();
    }
}