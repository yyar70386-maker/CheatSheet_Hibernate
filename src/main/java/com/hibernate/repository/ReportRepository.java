package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.ReportEntity;

public interface ReportRepository {

    List<ReportEntity> findAll();

    ReportEntity findById(Integer id);

    void updateStatus(Integer id, String status);

    long countAll();
}
