package com.hibernate.repository;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.CategoryEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CategoryRepositoryImpl implements CategoryRepository {

    private final SessionFactory sessionFactory;

    public Session getSession() {
        return sessionFactory.getCurrentSession();
    }
    
    @Override
    public List<CategoryEntity> findAll() {
        // 📌 Database Table ထဲက Category ဒေတာအားလုံး (ACTIVE ကော INACTIVE ကော) ကို ဆွဲထုတ်မည့် HQL Query
        return sessionFactory.getCurrentSession()
                .createQuery("from CategoryEntity", CategoryEntity.class)
                .getResultList();
    }

    @Override
    public Integer save(CategoryEntity category) {
        return (Integer) getSession().save(category);
    }

    @Override
    public List<CategoryEntity> findAllActive() {
        
        return getSession()
                .createQuery("from CategoryEntity where status='ACTIVE'", CategoryEntity.class)
                .getResultList(); 
    }

    @Override
    public CategoryEntity findById(Integer id) {
        return getSession().get(CategoryEntity.class, id);
    }

    @Override
    public CategoryEntity findByName(String name) {
        // 📌 ပြင်ဆင်ချက် (၂): ပြီးခဲ့တဲ့အဆင့်က Interface ထဲမှာ ထည့်သွင်းခဲ့တဲ့ findByName(name) ကို 
        // uniqueResult() သုံးပြီး အခုလို အပြည့်အစုံ Implement လုပ်ပေးလိုက်ပါတယ်ဗျာ။
        try {
            return getSession()
                    .createQuery("from CategoryEntity where name = :name", CategoryEntity.class)
                    .setParameter("name", name)
                    .uniqueResult();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public void update(CategoryEntity category) {
        CategoryEntity oldCategory = findById(category.getId());

        if (oldCategory != null) {
            oldCategory.setName(category.getName());
            oldCategory.setStatus(category.getStatus()); // 📌 Name ရော Status ပါ ပြောင်းလဲနိုင်အောင် ထည့်ပေးထားပါတယ်
            getSession().update(oldCategory);
        }
    }

    @Override
    public void delete(Integer id) {
        CategoryEntity category = findById(id);

        if (category != null) {
            // 📌 ပြင်ဆင်ချက် (၃): UI ဘက်က Badge (INACTIVE) စာလုံးကြီးတွေနဲ့ တိုက်ရိုက် ကိုက်ညီသွားအောင် 
            // "inactive" နေရာမှာ "INACTIVE" (စာလုံးကြီး) သို့ ပြောင်းလဲပေးလိုက်ပါတယ်ဗျာ။
            category.setStatus("INACTIVE");
            getSession().update(category);
            getSession().flush();
        }
    }

    @Override
    public long countAllActive() {
        Long count = getSession()
                .createQuery("select count(c) from CategoryEntity c where c.status = 'ACTIVE'", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }
}
