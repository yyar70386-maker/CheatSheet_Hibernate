package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.NotificationDto;
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
    private final com.hibernate.repository.CheatsheetRepository cheatsheetRepository;
    private final com.hibernate.repository.CommentRepositoryImpl commentRepository;

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

        // Auto-ban/delete logic
        long distinctReporters = reportRepository.countDistinctUsersByTarget(report.getTargetType(), report.getTargetId());
        if (distinctReporters >= 10) {
            if ("CHEATSHEET".equalsIgnoreCase(report.getTargetType())) {
                com.hibernate.entity.CheatsheetEntity sheet = cheatsheetRepository.findById(report.getTargetId());
                if (sheet != null && !sheet.isBanned()) {
                    sheet.setBanned(true);
                    sheet.setBannedReason("Auto-banned due to 10 or more reports.");
                    sheet.setBannedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                    cheatsheetRepository.update(sheet);
                }
            } else if ("COMMENT".equalsIgnoreCase(report.getTargetType())) {
                com.hibernate.entity.CommentEntity comment = commentRepository.getById(report.getTargetId());
                if (comment != null && comment.getDeletedAt() == null) {
                    comment.setDeletedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                    comment.setBanned(true);
                    comment.setBannedReason("Auto-deleted due to 10 or more reports.");
                    comment.setBannedAt(new java.sql.Timestamp(System.currentTimeMillis()));
                    commentRepository.updateComment(comment);
                }
            }
        }

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
    public NotificationDto updateStatus(Integer id, String status, User admin) {
        reportRepository.updateStatus(id, status);
        ReportEntity report = reportRepository.findById(id);
        if (report != null) {
            auditLogService.log(admin, "Report Status Changed", "Report", id,
                    "Status changed to " + status + ".", null);
            
            // Notify the reporter
            if (report.getUser() != null) {
                notificationService.createNotification(
                        report.getUser().getId(),
                        admin != null ? admin.getId() : null,
                        "Report status changed to " + status + ".",
                        "REPORT",
                        "/notifications");
            }
            
            // Notify the reported user if status is "Resolved"
            if ("Resolved".equalsIgnoreCase(status)) {
                Integer reportedUserId = null;
                String msg = "";
                String linkUrl = "/notifications";
                
                if ("CHEATSHEET".equalsIgnoreCase(report.getTargetType())) {
                    if (report.getTargetId() != null) {
                        com.hibernate.entity.CheatsheetEntity sheet = cheatsheetRepository.findById(report.getTargetId());
                        if (sheet != null && sheet.getAuthor() != null) {
                            reportedUserId = sheet.getAuthor().getId();
                            msg = "A report against your cheatsheet '" + sheet.getTitle() + "' has been resolved by the admin.";
                            linkUrl = "/cheatsheet/detail/" + sheet.getObfuscatedId();
                        }
                    }
                } else if ("COMMENT".equalsIgnoreCase(report.getTargetType())) {
                    if (report.getTargetId() != null) {
                        com.hibernate.entity.CommentEntity comment = commentRepository.getById(report.getTargetId());
                        if (comment != null && comment.getUser() != null) {
                            reportedUserId = comment.getUser().getId();
                            msg = "A report against your comment has been resolved by the admin.";
                            if (comment.getCheatSheet() != null) {
                                linkUrl = "/cheatsheet/detail/" + comment.getCheatSheet().getObfuscatedId();
                            }
                        }
                    }
                } else if ("USER".equalsIgnoreCase(report.getTargetType())) {
                    if (report.getTargetId() != null) {
                        reportedUserId = report.getTargetId();
                        msg = "A report against your profile has been resolved by the admin.";
                    }
                }
                
                if (reportedUserId != null) {
                    return notificationService.createNotification(
                            reportedUserId,
                            admin != null ? admin.getId() : null,
                            msg,
                            "REPORT_RESOLVED",
                            linkUrl
                    );
                }
            }
        }
        return null;
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
