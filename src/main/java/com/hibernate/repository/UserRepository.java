package com.hibernate.repository;

import com.hibernate.entity.User;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserRepository {

    @Autowired
    private SessionFactory sessionFactory;

    // အကောင့်အသစ်ဆောက်ရန် (Insert)
    public void save(User user) { 
        sessionFactory.getCurrentSession().persist(user); 
    }

    // ✨ ပရိုဖိုင်ပြင်ရန်နှင့် Avatar လမ်းကြောင်း Update လုပ်ရန် (session.update အစား merge ပြောင်းထားပါသည်)
    public void update(User user) { 
        sessionFactory.getCurrentSession().merge(user); 
    }

    // ID ဖြင့် အသုံးပြုသူအား ရှာဖွေရန်
    public User findById(int id) { 
        return sessionFactory.getCurrentSession().get(User.class, id); 
    }

 
    public User findByUsername(String username) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE username = :username", User.class);
        query.setParameter("username", username);
        return query.uniqueResult(); 
    }
    
    
    public User findByEmail(String email) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE email = :email", User.class);
        query.setParameter("email", email);
        return query.uniqueResult();
    }

    
    public User findByResetToken(String token) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE resetToken = :token", User.class);
        query.setParameter("token", token);
        return query.uniqueResult();
    }
}