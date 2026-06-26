package com.hibernate.dto;

import java.util.List;

import com.hibernate.entity.AuditLogEntity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DashboardSummaryDto {

    private long totalUsers;
    private long totalCheatsheets;
    private long totalFollowers;
    private long totalReports;
    private long totalAnnouncements;
    private List<AuditLogEntity> recentActivities;
}
