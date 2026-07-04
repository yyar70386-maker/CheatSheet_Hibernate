package com.hibernate.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.DashboardSummaryDto;
import com.hibernate.repository.CommentRepositoryImpl;
import com.hibernate.repository.UserFollowRepository;
import com.hibernate.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final UserRepository userRepository;
    private final UserFollowRepository userFollowRepository;
    private final CheatsheetService cheatsheetService;
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
        return summary;
    }
}
