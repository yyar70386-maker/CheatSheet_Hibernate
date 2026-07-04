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

    // 🌟 ဖြည့်စွက်ထားသော Method (၁) - အားလုံးကို ပြန်ထုတ်ပေးရန်
    @Override
    public List<User> findAll() {
        return getAllUsers(); // getAllUsers() ရှိပြီးသားမို့လို့ ပြန်သုံးထားပါတယ်
    }

    // 🌟 ဖြည့်စွက်ထားသော Method (၂) - Total အရေအတွက်ကို ရေတွက်ရန်
    @Override
    public long countAll() {
        String hql = "SELECT COUNT(u) FROM User u";
        Query<Long> query = sessionFactory.getCurrentSession().createQuery(hql, Long.class);
        return query.uniqueResult();
    }

    @Override
    public List<User> findLatest(int limit) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM User u ORDER BY u.id DESC", User.class)
                .setMaxResults(limit)
                .getResultList();
    }

    @Override
    public List<User> search(String keyword, String role, String status, int page, int size) {
        StringBuilder hql = new StringBuilder("FROM User u WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (u.username LIKE :keyword OR u.email LIKE :keyword OR u.fullName LIKE :keyword)");
        }
        if (role != null && !role.isEmpty()) {
            hql.append(" AND u.role = :role");
        }
        if (status != null && !status.isEmpty()) {
            if ("suspended".equalsIgnoreCase(status)) {
                hql.append(" AND u.suspended = true");
            } else if ("locked".equalsIgnoreCase(status)) {
                hql.append(" AND u.accountLocked = true");
            } else if ("active".equalsIgnoreCase(status)) {
                hql.append(" AND u.suspended = false AND u.accountLocked = false");
            }
        }
        hql.append(" ORDER BY u.id DESC");
        
        Query<User> query = sessionFactory.getCurrentSession().createQuery(hql.toString(), User.class);
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim() + "%");
        }
        if (role != null && !role.isEmpty()) {
            query.setParameter("role", Integer.parseInt(role));
        }
        
        query.setFirstResult((page - 1) * size);
        query.setMaxResults(size);
        return query.getResultList();
    }

    @Override
    public long countSearch(String keyword, String role, String status) {
        StringBuilder hql = new StringBuilder("SELECT COUNT(u) FROM User u WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (u.username LIKE :keyword OR u.email LIKE :keyword OR u.fullName LIKE :keyword)");
        }
        if (role != null && !role.isEmpty()) {
            hql.append(" AND u.role = :role");
        }
        if (status != null && !status.isEmpty()) {
            if ("suspended".equalsIgnoreCase(status)) {
                hql.append(" AND u.suspended = true");
            } else if ("locked".equalsIgnoreCase(status)) {
                hql.append(" AND u.accountLocked = true");
            } else if ("active".equalsIgnoreCase(status)) {
                hql.append(" AND u.suspended = false AND u.accountLocked = false");
            }
        }
        
        Query<Long> query = sessionFactory.getCurrentSession().createQuery(hql.toString(), Long.class);
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim() + "%");
        }
        if (role != null && !role.isEmpty()) {
            query.setParameter("role", Integer.parseInt(role));
        }
        
        Long count = query.uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public long countSuspended() {
        return sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM User u WHERE u.suspended = true", Long.class)
                .uniqueResult();
    }

    @Override
    public long countLocked() {
        return sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(u) FROM User u WHERE u.accountLocked = true", Long.class)
                .uniqueResult();
    }
}
