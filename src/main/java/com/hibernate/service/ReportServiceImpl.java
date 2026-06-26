package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.ReportEntity;
import com.hibernate.repository.ReportRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final ReportRepository reportRepository;

    @Override
    @Transactional(readOnly = true)
    public List<ReportEntity> findAll() {
        return reportRepository.findAll();
    }

    @Override
    @Transactional
    public void updateStatus(Integer id, String status) {
        reportRepository.updateStatus(id, status);
    }

    @Override
    @Transactional(readOnly = true)
    public long countAll() {
        return reportRepository.countAll();
    }
}
