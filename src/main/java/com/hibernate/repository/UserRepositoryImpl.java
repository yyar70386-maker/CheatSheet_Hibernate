package com.hibernate.repository;

import com.hibernate.entity.User;
import java.util.List;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UserRepositoryImpl implements UserRepository { 

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public List<User> getAllUsers() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM User", User.class)
                .getResultList();
    }

    @Override
    public void deleteUser(int id) {
        User user = findById(id);
        if (user != null) {
            sessionFactory.getCurrentSession().delete(user);
        }
    }

    @Override
    public void save(User user) { 
        sessionFactory.getCurrentSession().persist(user); 
    }

    @Override
    public void update(User user) { 
        sessionFactory.getCurrentSession().merge(user); 
    }

    @Override
    public User findById(int id) { 
        return sessionFactory.getCurrentSession().get(User.class, id); 
    }

    @Override
    public User findByUsername(String username) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE username = :username", User.class);
        query.setParameter("username", username);
        return query.uniqueResult(); 
    }
    
    @Override
    public User findByEmail(String email) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE email = :email", User.class);
        query.setParameter("email", email);
        return query.uniqueResult();
    }

    @Override
    public User findByResetToken(String token) {
        Query<User> query = sessionFactory.getCurrentSession()
                .createQuery("FROM User WHERE resetToken = :token", User.class);
        query.setParameter("token", token);
        return query.uniqueResult();
    }
}