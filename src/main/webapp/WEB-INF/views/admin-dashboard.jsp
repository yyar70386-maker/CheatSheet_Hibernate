<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CheatSheet Project</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        .stat-card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08) !important;
        }
    </style>
</head>
<body class="bg-light">

    <%-- 🧩 Header Navbar --%>
    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <%-- 🛠️ Left Sidebar --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <%-- 📂 Main Content Area --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Dashboard Overview</h2>
                    <p class="text-muted m-0 small">Real-time status metrics and moderation summary.</p>
                </div>
            </div>

            <%-- 📊 Stats Grid --%>
            <div class="row g-3 mb-4">
                
                <%-- User Stats --%>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-primary-subtle text-primary p-3 rounded-3 me-3">
                                <i class="bi bi-people-fill fs-4 text-primary brand-primary"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Total Users</div>
                                <div class="fs-3 fw-bold text-dark">${summary.totalUsers}</div>
                                <div class="small mt-1">
                                    <span class="text-success fw-semibold">${summary.activeUsers} Active</span> / 
                                    <span class="text-danger fw-semibold">${summary.suspendedUsers} Suspended</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- CheatSheet Stats --%>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-success-subtle text-success p-3 rounded-3 me-3">
                                <i class="bi bi-file-earmark-code-fill fs-4 text-success"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">CheatSheets</div>
                                <div class="fs-3 fw-bold text-dark">${summary.totalCheatsheets}</div>
                                <div class="small mt-1">
                                    <span class="text-success fw-semibold">${summary.publishedCheatsheets} Published</span> / 
                                    <span class="text-danger fw-semibold">${summary.bannedCheatsheets} Banned</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Comment Stats --%>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-warning-subtle text-warning p-3 rounded-3 me-3">
                                <i class="bi bi-chat-left-text-fill fs-4 text-warning"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Comments</div>
                                <div class="fs-3 fw-bold text-dark">${summary.totalComments}</div>
                                <div class="small mt-1">
                                    <span class="text-success fw-semibold">${summary.totalComments - summary.bannedComments} Active</span> / 
                                    <span class="text-danger fw-semibold">${summary.bannedComments} Banned</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Report Stats --%>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-danger-subtle text-danger p-3 rounded-3 me-3">
                                <i class="bi bi-flag-fill fs-4 text-danger"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Reports</div>
                                <div class="fs-3 fw-bold text-dark">${summary.totalReports}</div>
                                <div class="small mt-1">
                                    <span class="text-danger fw-semibold">${summary.pendingReports} Pending</span> / 
                                    <span class="text-success fw-semibold">${summary.solvedReports} Solved</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <%-- Charts & Quick Actions Row --%>
            <div class="row g-4 mb-4">
                
                <%-- Chart 1: Users --%>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-3 p-4 h-100">
                        <h5 class="fw-bold mb-3 small text-uppercase text-secondary">User Statistics</h5>
                        <div style="max-height: 200px; position: relative;" class="d-flex justify-content-center">
                            <canvas id="usersChart"></canvas>
                        </div>
                    </div>
                </div>

                <%-- Chart 2: CheatSheets --%>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-3 p-4 h-100">
                        <h5 class="fw-bold mb-3 small text-uppercase text-secondary">CheatSheet Statistics</h5>
                        <div style="max-height: 200px; position: relative;" class="d-flex justify-content-center">
                            <canvas id="sheetsChart"></canvas>
                        </div>
                    </div>
                </div>

                <%-- Quick Actions --%>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-3 p-4 h-100 bg-white">
                        <h5 class="fw-bold mb-3 small text-uppercase text-secondary">Quick Actions</h5>
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/admin/announcements/add" class="btn btn-brand-primary btn-sm"><i class="bi bi-megaphone me-2"></i>Create Announcement</a>
                            <a href="${pageContext.request.contextPath}/admin/notifications" class="btn btn-outline-secondary btn-sm text-start"><i class="bi bi-bell me-2"></i>Send Notification</a>
                            <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-secondary btn-sm text-start"><i class="bi bi-flag me-2"></i>Manage Reports</a>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary btn-sm text-start"><i class="bi bi-people me-2"></i>Manage Users</a>
                            <a href="${pageContext.request.contextPath}/admin/audit-logs" class="btn btn-outline-secondary btn-sm text-start"><i class="bi bi-journal-text me-2"></i>View Audit Logs</a>
                        </div>
                    </div>
                </div>

            </div>

            <%-- Lists Row --%>
            <div class="row g-4">
                
                <%-- Recent Activities --%>
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-3 p-4">
                        <h5 class="fw-bold mb-3 text-dark">Recent Activities</h5>
                        <div class="list-group list-group-flush small">
                            <c:choose>
                                <c:when test="${not empty summary.recentActivities}">
                                    <c:forEach items="${summary.recentActivities}" var="a">
                                        <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-2.5" href="${pageContext.request.contextPath}/admin/audit-logs/${a.id}">
                                            <div>
                                                <div class="fw-semibold text-dark"><c:out value="${a.action}" /></div>
                                                <div class="text-muted small"><c:out value="${a.description}" /></div>
                                            </div>
                                            <div class="text-muted small">${a.createdAt}</div>
                                        </a>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-muted text-center py-4">No recent activities.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <%-- Latest Reports --%>
                <div class="col-lg-6">
                    <div class="card border-0 shadow-sm rounded-3 p-4">
                        <h5 class="fw-bold mb-3 text-dark">Latest Reports</h5>
                        <div class="list-group list-group-flush small">
                            <c:choose>
                                <c:when test="${not empty summary.latestReports}">
                                    <c:forEach items="${summary.latestReports}" var="r">
                                        <div class="list-group-item d-flex justify-content-between align-items-center py-2.5 px-0">
                                            <div>
                                                <span class="badge ${r.status == 'Pending' ? 'bg-warning-subtle text-warning' : 'bg-success-subtle text-success'} px-2 py-1 rounded small me-2">${r.status}</span>
                                                <span class="fw-medium text-dark"><c:out value="${r.targetType}" /> Report</span>
                                                <div class="text-muted small mt-1"><c:out value="${r.reason}" /></div>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/admin/reports/${r.id}" class="btn btn-sm btn-outline-primary py-0 px-2 rounded small">View</a>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-muted text-center py-4">No reports found.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>

        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Users Pie Chart
        const usersCtx = document.getElementById('usersChart').getContext('2d');
        new Chart(usersCtx, {
            type: 'doughnut',
            data: {
                labels: ['Active', 'Suspended'],
                datasets: [{
                    data: [${summary.activeUsers}, ${summary.suspendedUsers}],
                    backgroundColor: ['#4f46e5', '#ef4444'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            font: { size: 11 }
                        }
                    }
                }
            }
        });

        // CheatSheets Pie Chart
        const sheetsCtx = document.getElementById('sheetsChart').getContext('2d');
        new Chart(sheetsCtx, {
            type: 'doughnut',
            data: {
                labels: ['Published', 'Banned'],
                datasets: [{
                    data: [${summary.publishedCheatsheets}, ${summary.bannedCheatsheets}],
                    backgroundColor: ['#10b981', '#f59e0b'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            font: { size: 11 }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>
