package com.hibernate.dto;

import java.util.List;

import com.hibernate.entity.AuditLogEntity;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.ReportEntity;
import com.hibernate.entity.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DashboardSummaryDto {

    private long totalUsers;
    private long activeUsers;
    private long totalCheatsheets;
    private long totalCategories;
    private long totalTags;
    private long totalComments;
    private long totalFollowers;
    private long totalReports;
    private long pendingReports;
    private long solvedReports;
    private long totalAnnouncements;
    private long totalNotifications;
    private long suspendedUsers;
    private long publishedCheatsheets;
    private long bannedCheatsheets;
    private long bannedComments;
    private List<AuditLogEntity> recentActivities;
    private List<User> latestUsers;
    private List<CheatsheetEntity> latestCheatsheets;
    private List<ReportEntity> latestReports;
}
