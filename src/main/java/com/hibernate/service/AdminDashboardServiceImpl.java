package com.hibernate.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.dto.DashboardSummaryDto;
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

    @Override
    @Transactional(readOnly = true)
    public DashboardSummaryDto getSummary() {
        DashboardSummaryDto summary = new DashboardSummaryDto();
        summary.setTotalUsers(userRepository.countAll());
        summary.setTotalCheatsheets(cheatsheetService.countAllActive());
        summary.setTotalFollowers(userFollowRepository.countAll());
        summary.setTotalReports(reportService.countAll());
        summary.setTotalAnnouncements(announcementService.countAllActive());
        summary.setRecentActivities(auditLogService.findRecent(10));
        return summary;
    }
}
