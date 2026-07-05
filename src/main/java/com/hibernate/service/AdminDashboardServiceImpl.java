package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.DashboardSummaryDto;
import com.hibernate.repository.CommentRepositoryImpl;
import com.hibernate.repository.UserFollowRepository;
import com.hibernate.repository.UserRepository;

import com.hibernate.repository.CheatsheetRepository;
import com.hibernate.repository.AuditLogRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final UserRepository userRepository;
    private final UserFollowRepository userFollowRepository;
    private final CheatsheetService cheatsheetService;
    private final CheatsheetRepository cheatsheetRepository;
    private final AuditLogRepository auditLogRepository;
    private final ReportService reportService;
    private final AnnouncementService announcementService;
    private final AuditLogService auditLogService;
    private final CategoryService categoryService;
    private final TagService tagService;
    private final CommentRepositoryImpl commentRepository;
    private final NotificationService notificationService;

    @Override
    @Transactional(readOnly = true)
    public DashboardSummaryDto getSummary() {
        DashboardSummaryDto summary = new DashboardSummaryDto();
        summary.setTotalUsers(userRepository.countAll());
        summary.setSuspendedUsers(userRepository.countSuspended());
        summary.setActiveUsers(summary.getTotalUsers() - summary.getSuspendedUsers());
        
        summary.setTotalCheatsheets(cheatsheetService.getTotalSheetsCount());
        summary.setPublishedCheatsheets(cheatsheetService.countPublished());
        summary.setBannedCheatsheets(cheatsheetService.countBanned());
        
        summary.setTotalCategories(categoryService.countAllActive());
        summary.setTotalTags(tagService.getTotalTagsCount());
        
        summary.setTotalComments(commentRepository.countAll());
        summary.setBannedComments(commentRepository.countBanned());
        
        summary.setTotalFollowers(userFollowRepository.countAll());
        summary.setTotalReports(reportService.countAll());
        summary.setPendingReports(reportService.countByStatus("Pending"));
        summary.setSolvedReports(reportService.countByStatus("Resolved"));
        
        summary.setTotalAnnouncements(announcementService.countAllActive());
        summary.setTotalNotifications(notificationService.countAll());
        summary.setRecentActivities(auditLogService.findRecent(10));
        summary.setLatestUsers(userRepository.findLatest(5));
        summary.setLatestCheatsheets(cheatsheetService.findLatestPublic("", 1, 5));
        summary.setLatestReports(reportService.findLatest(5));

        List<Long> cheatsheetCounts = new java.util.ArrayList<>(java.util.Collections.nCopies(12, 0L));
        List<Long> activeUserCounts = new java.util.ArrayList<>(java.util.Collections.nCopies(12, 0L));

        int currentYear = java.time.LocalDate.now().getYear();

        List<Object[]> sheetData = cheatsheetRepository.getMonthlyCheatsheetCounts(currentYear);
        for (Object[] row : sheetData) {
            Number monthNum = (Number) row[0];
            Number count = (Number) row[1];
            if (monthNum != null && count != null) {
                int idx = monthNum.intValue() - 1;
                if (idx >= 0 && idx < 12) {
                    cheatsheetCounts.set(idx, count.longValue());
                }
            }
        }

        List<Object[]> userData = auditLogRepository.getMonthlyActiveUserCounts(currentYear);
        for (Object[] row : userData) {
            Number monthNum = (Number) row[0];
            Number count = (Number) row[1];
            if (monthNum != null && count != null) {
                int idx = monthNum.intValue() - 1;
                if (idx >= 0 && idx < 12) {
                    activeUserCounts.set(idx, count.longValue());
                }
            }
        }

        summary.setMonthlyCheatsheetCounts(cheatsheetCounts);
        summary.setMonthlyActiveUserCounts(activeUserCounts);

        return summary;
    }
}
