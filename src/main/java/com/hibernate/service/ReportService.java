package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.ReportEntity;
import com.hibernate.entity.User;

public interface ReportService {

    Integer create(ReportEntity report, Integer reporterId);

    List<ReportEntity> findAll();

    List<ReportEntity> search(String keyword, String status, String targetType, int page, int size);

    long countSearch(String keyword, String status, String targetType);

    ReportEntity findById(Integer id);

    void updateStatus(Integer id, String status, User admin);

    void delete(Integer id, User admin);

    long countAll();

    long countByStatus(String status);

    List<ReportEntity> findLatest(int limit);
}
