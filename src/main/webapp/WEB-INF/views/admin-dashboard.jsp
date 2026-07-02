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
            <div class="text-muted small">Operational overview and moderation queue</div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Users</div><div class="fs-3 fw-bold">${summary.totalUsers}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Active Users</div><div class="fs-3 fw-bold">${summary.activeUsers}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Cheatsheets</div><div class="fs-3 fw-bold">${summary.totalCheatsheets}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Categories</div><div class="fs-3 fw-bold">${summary.totalCategories}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Tags</div><div class="fs-3 fw-bold">${summary.totalTags}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Comments</div><div class="fs-3 fw-bold">${summary.totalComments}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Reports</div><div class="fs-3 fw-bold">${summary.totalReports}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Pending Reports</div><div class="fs-3 fw-bold text-danger">${summary.pendingReports}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Announcements</div><div class="fs-3 fw-bold">${summary.totalAnnouncements}</div></div></div>
        <div class="col-md-3 col-xl-2"><div class="bg-white border rounded-3 p-3 shadow-sm"><div class="text-muted small">Notifications</div><div class="fs-3 fw-bold">${summary.totalNotifications}</div></div></div>
    </div>

    <div class="row g-4">
        <div class="col-lg-7">
            <div class="bg-white border rounded-3 p-4 shadow-sm mb-4">
                <h5 class="fw-bold mb-3">Recent Activities</h5>
                <div class="list-group list-group-flush">
                    <c:forEach items="${summary.recentActivities}" var="a">
                        <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" href="${pageContext.request.contextPath}/admin/audit-logs/${a.id}">
                            <div>
                                <div class="fw-semibold"><c:out value="${a.action}" /></div>
                                <div class="text-muted small"><c:out value="${a.entityName}" /> #${a.entityId}</div>
                            </div>
                            <div class="text-muted small">${a.createdAt}</div>
                        </a>
                    </c:forEach>
                </div>
            </div>
            <div class="bg-white border rounded-3 p-4 shadow-sm">
                <h5 class="fw-bold mb-3">Latest Reports</h5>
                <c:forEach items="${summary.latestReports}" var="r">
                    <div class="d-flex justify-content-between border-bottom py-2">
                        <div><span class="badge text-bg-light border">${r.targetType}</span> <c:out value="${r.reason}" /></div>
                        <a href="${pageContext.request.contextPath}/admin/reports/${r.id}" class="small">View</a>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="bg-white border rounded-3 p-4 shadow-sm mb-4">
                <h5 class="fw-bold mb-3">Quick Actions</h5>
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/admin/announcements/add" class="btn btn-primary"><i class="bi bi-megaphone me-1"></i>Create Announcement</a>
                    <a href="${pageContext.request.contextPath}/admin/notifications" class="btn btn-outline-primary">Send Notification</a>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-primary">Manage Reports</a>
                    <a href="${pageContext.request.contextPath}/admin/audit-logs" class="btn btn-outline-secondary">View Audit Logs</a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">Manage Users</a>
                </div>
            </div>
            <div class="bg-white border rounded-3 p-4 shadow-sm mb-4">
                <h5 class="fw-bold mb-3">Latest Users</h5>
                <c:forEach items="${summary.latestUsers}" var="u">
                    <div class="d-flex justify-content-between border-bottom py-2">
                        <span><c:out value="${u.username}" /></span>
                        <span class="text-muted small">${u.role == 1 ? 'Admin' : 'User'}</span>
                    </div>
                </c:forEach>
            </div>
            <div class="bg-white border rounded-3 p-4 shadow-sm">
                <h5 class="fw-bold mb-3">Latest Cheatsheets</h5>
                <c:forEach items="${summary.latestCheatsheets}" var="s">
                    <div class="border-bottom py-2">
                        <a class="text-decoration-none fw-semibold" href="${pageContext.request.contextPath}/cheatsheet/detail/${s.id}"><c:out value="${s.title}" /></a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
