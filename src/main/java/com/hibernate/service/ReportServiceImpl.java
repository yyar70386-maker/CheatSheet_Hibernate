package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.ReportEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.ReportRepository;
import com.hibernate.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportServiceImpl implements ReportService {

    private final ReportRepository reportRepository;
    private final UserRepository userRepository;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;

    @Override
    @Transactional
    public Integer create(ReportEntity report, Integer reporterId) {
        User reporter = userRepository.findById(reporterId);
        if (reporter == null) {
            throw new IllegalArgumentException("Reporter not found.");
        }
        if (report.getTargetType() == null || report.getTargetType().trim().isEmpty()) {
            report.setTargetType(report.getSheetId() != null ? "CHEATSHEET" : "USER");
        }
        if (report.getTargetId() == null) {
            report.setTargetId(report.getSheetId());
        }
        report.setUser(reporter);
        report.setStatus("Pending");
        Integer id = reportRepository.save(report);
        auditLogService.log(reporter, "Report Created", "Report", id,
                report.getTargetType() + " #" + report.getTargetId() + " reported.", null);
        return id;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReportEntity> findAll() {
        return reportRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReportEntity> search(String keyword, String status, String targetType, int page, int size) {
        return reportRepository.search(keyword, status, targetType, page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public long countSearch(String keyword, String status, String targetType) {
        return reportRepository.countSearch(keyword, status, targetType);
    }

    @Override
    @Transactional(readOnly = true)
    public ReportEntity findById(Integer id) {
        return reportRepository.findById(id);
    }

    @Override
    @Transactional
    public void updateStatus(Integer id, String status, User admin) {
        reportRepository.updateStatus(id, status);
        ReportEntity report = reportRepository.findById(id);
        if (report != null) {
            auditLogService.log(admin, "Report Status Changed", "Report", id,
                    "Status changed to " + status + ".", null);
            if (report.getUser() != null) {
                notificationService.createNotification(
                        report.getUser().getId(),
                        admin != null ? admin.getId() : null,
                        "Report status changed to " + status + ".",
                        "REPORT",
                        "/notifications");
            }
        }
    }

    @Override
    @Transactional
    public void delete(Integer id, User admin) {
        reportRepository.delete(id);
        auditLogService.log(admin, "Report Deleted", "Report", id, "Report removed by admin.", null);
    }

    @Override
    @Transactional(readOnly = true)
    public long countAll() {
        return reportRepository.countAll();
    }

    @Override
    @Transactional(readOnly = true)
    public long countByStatus(String status) {
        return reportRepository.countByStatus(status);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReportEntity> findLatest(int limit) {
        return reportRepository.findLatest(limit);
    }
}
