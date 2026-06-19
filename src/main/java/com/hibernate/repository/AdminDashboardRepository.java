package com.hibernate.repository;

import java.util.List;

import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.User;

@Repository
public class AdminDashboardRepository {

	
	@Autowired
	private SessionFactory sessionFactory;
	  /**
     * Dashboard counter မှာ ပြသရန် စုစုပေါင်း User အရေအတွက်ကို တွက်ချက်ပေးသည်။
     */
    public long countTotalUsers() {
        String hql = "SELECT COUNT(u.id) FROM User u";
        Query<Long> query = sessionFactory.getCurrentSession().createQuery(hql, Long.class);
        Long result = query.uniqueResult();
        return result != null ? result : 0L;
    }

    /**
     * Admin Dashboard က User Table List မှာ ပြသရန် User အားလုံးကို ဆွဲထုတ်ပေးသည်။
     */
    public List<User> findAllUsers() {
        String hql = "FROM User u ORDER BY u.id DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, User.class).getResultList();
    }
}
