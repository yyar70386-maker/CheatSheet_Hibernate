package com.hibernate.service;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hibernate.entity.AdminMetricEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.AdminDashboardRepository;

@Service
@Transactional
public class AdminService {
	
	@Autowired
    private AdminDashboardRepository adminDashboardRepository;

    @Autowired
    private SessionFactory sessionFactory;

    @Transactional(readOnly = true)
    public long getTotalUserCount() {
        return adminDashboardRepository.countTotalUsers();
    }

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return adminDashboardRepository.findAllUsers();
    }

    /**
     * Database (admin_metrics) ထဲက dynamic metric data တွေကို ဆွဲထုတ်ရန်
     */
    @Transactional(readOnly = true)
    public List<AdminMetricEntity> getDashboardMetrics() {
        String hql = "FROM AdminMetricEntity";
        return sessionFactory.getCurrentSession().createQuery(hql, AdminMetricEntity.class).getResultList();
    }
}
