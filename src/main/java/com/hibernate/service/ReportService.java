package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.ReportEntity;

public interface ReportService {

    List<ReportEntity> findAll();

    void updateStatus(Integer id, String status);

    long countAll();
}
