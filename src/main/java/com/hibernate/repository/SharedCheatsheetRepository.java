package com.hibernate.repository;

import java.util.List;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.SharedCheatsheetEntity;

@Repository
public class SharedCheatsheetRepository {

    @Autowired
    private SessionFactory sessionFactory;

    // 1. Share ဒေတာ အသစ်သိမ်းရန်
    public void save(SharedCheatsheetEntity shared) {
        sessionFactory.getCurrentSession().save(shared);
    }
    
    public void update(CheatsheetEntity cheatsheet) {
        sessionFactory.getCurrentSession().update(cheatsheet); // သို့မဟုတ် .merge(cheatsheet);
    }
    
    

    // 2. User တစ်ယောက်တည်းက တစ်ခုတည်းကို နှစ်ခါ Share တားဆီးရန် စစ်ဆေးခြင်း
    public boolean isAlreadyShared(Integer userId, Integer cheatsheetId) {
        // HQL Query တွင် string row များကို တစ်ကြောင်းတည်းဖြစ်အောင် Space သေချာချန်ထားပေးပါသည်
        Long count = (Long) sessionFactory.getCurrentSession()
                .createQuery("SELECT count(s) FROM SharedCheatsheetEntity s " +
                             "WHERE s.user.id = :userId AND s.cheatsheet.id = :cheatsheetId")
                .setParameter("userId", userId)
                .setParameter("cheatsheetId", cheatsheetId)
                .uniqueResult();
        return count != null && count > 0;
    }

 // 🌟 ၄။ လက်ရှိ Login ဝင်ထားသူ (မိမိ) Share ထားသော ဒေတာများကိုသာ သီးသန့်ဆွဲထုတ်ခြင်း
    @SuppressWarnings("unchecked")
    public List<SharedCheatsheetEntity> findMySharedWithDetails(Integer userId) {
        return sessionFactory.getCurrentSession()
                .createQuery("SELECT s FROM SharedCheatsheetEntity s " +
                             "JOIN FETCH s.user " +
                             "JOIN FETCH s.cheatsheet " +
                             "WHERE s.user.id = :userId " +  // မိမိ ID နှင့် ကိုက်ညီရမည်
                             "ORDER BY s.id DESC")
                .setParameter("userId", userId)
                .list();
    }

    
    public List<SharedCheatsheetEntity> findAllSharedWithDetails() {
        return sessionFactory.getCurrentSession()
            .createQuery("SELECT distinct s FROM SharedCheatsheetEntity s " +
                         "LEFT JOIN FETCH s.cheatsheet c " +
                         "LEFT JOIN FETCH s.user u " +
                         "LEFT JOIN FETCH c.category", SharedCheatsheetEntity.class)
            .getResultList();
    }
}