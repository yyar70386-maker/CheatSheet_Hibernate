package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.ReportEntity;

public interface ReportRepository {

    Integer save(ReportEntity report);

    List<ReportEntity> findAll();

    List<ReportEntity> search(String keyword, String status, String targetType, int page, int size);

    long countSearch(String keyword, String status, String targetType);

    ReportEntity findById(Integer id);

    void updateStatus(Integer id, String status);

    void delete(Integer id);

    long countAll();

    long countByStatus(String status);

    List<ReportEntity> findLatest(int limit);

    long countDistinctUsersByTarget(String targetType, Integer targetId);
}
