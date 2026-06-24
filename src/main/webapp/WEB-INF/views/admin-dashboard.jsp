<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Admin Dashboard</h3>
            <div class="text-muted small">Operational overview and quick actions</div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-4 col-lg-2"><div class="bg-white border rounded-4 p-3 shadow-sm"><div class="text-muted small">Users</div><div class="fs-3 fw-bold">${summary.totalUsers}</div></div></div>
        <div class="col-md-4 col-lg-2"><div class="bg-white border rounded-4 p-3 shadow-sm"><div class="text-muted small">CheatSheets</div><div class="fs-3 fw-bold">${summary.totalCheatsheets}</div></div></div>
        <div class="col-md-4 col-lg-2"><div class="bg-white border rounded-4 p-3 shadow-sm"><div class="text-muted small">Followers</div><div class="fs-3 fw-bold">${summary.totalFollowers}</div></div></div>
        <div class="col-md-4 col-lg-2"><div class="bg-white border rounded-4 p-3 shadow-sm"><div class="text-muted small">Reports</div><div class="fs-3 fw-bold">${summary.totalReports}</div></div></div>
        <div class="col-md-4 col-lg-2"><div class="bg-white border rounded-4 p-3 shadow-sm"><div class="text-muted small">Announcements</div><div class="fs-3 fw-bold">${summary.totalAnnouncements}</div></div></div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="bg-white border rounded-4 p-4 shadow-sm">
                <h5 class="fw-bold mb-3">Recent Activities</h5>
                <div class="list-group list-group-flush">
                    <c:forEach items="${summary.recentActivities}" var="a">
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <div>
                                <div class="fw-semibold">${a.action}</div>
                                <div class="text-muted small">${a.entityName} #${a.entityId}</div>
                            </div>
                            <div class="text-muted small">${a.createdAt}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="bg-white border rounded-4 p-4 shadow-sm mb-4">
                <h5 class="fw-bold mb-3">Quick Actions</h5>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/admin/announcements/add" class="btn btn-primary"><i class="bi bi-megaphone me-1"></i>Create Announcement</a>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-primary">Manage Reports</a>
                    <a href="${pageContext.request.contextPath}/admin/audit-logs" class="btn btn-outline-secondary">View Audit Logs</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">Manage Users</a>
                </div>
            </div>
            <div class="bg-white border rounded-4 p-4 shadow-sm">
                <h5 class="fw-bold mb-3">What’s Active</h5>
                <div class="text-muted small">The dashboard is backed by live counts from Hibernate queries, so it reflects the current state of the system.</div>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
