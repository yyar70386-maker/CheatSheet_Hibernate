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
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fb;
        }
        .navbar {
            height: 56px;
            z-index: 1030;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
        }
        .app-container {
            display: flex;
            height: calc(100vh - 56px); 
            width: 100%;
        }
        .main-content-area {
            flex-grow: 1;
            height: 100%;
            overflow-y: auto; 
            min-width: 0;
            padding: 30px;
            background-color: #f5f7fb;
        }
        
        /* Modern Cards */
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            background: #ffffff;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            font-size: 20px;
        }
        
        .icon-blue { background: rgba(59, 130, 246, 0.1); color: #3b82f6; }
        .icon-purple { background: rgba(139, 92, 246, 0.1); color: #8b5cf6; }
        .icon-green { background: rgba(16, 185, 129, 0.1); color: #10b981; }
        .icon-orange { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
        
        /* Table overrides */
        .table-custom th {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6b7280;
            border-bottom: 2px solid #f3f4f6;
            font-weight: 600;
        }
        .table-custom td {
            vertical-align: middle;
            color: #374151;
            border-bottom: 1px solid #f3f4f6;
        }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold text-dark m-0">Dashboard</h3>
                <div class="text-muted small">Overview of the CheatSheet System</div>
            </div>

            <!-- Stats Row (Matching "Total Products, Total Sales" style) -->
            <div class="row g-4 mb-4">
                
                <div class="col-md-6 col-lg-3">
                    <div class="card p-4 h-100 d-flex flex-row align-items-center">
                        <div class="stat-icon icon-blue me-3">
                            <i class="bi bi-people-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">${summary.totalUsers}</h3>
                            <div class="text-muted small fw-medium mt-1">Total Users</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="card p-4 h-100 d-flex flex-row align-items-center">
                        <div class="stat-icon icon-purple me-3">
                            <i class="bi bi-file-earmark-code-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">${summary.totalCheatsheets}</h3>
                            <div class="text-muted small fw-medium mt-1">CheatSheets</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="card p-4 h-100 d-flex flex-row align-items-center">
                        <div class="stat-icon icon-green me-3">
                            <i class="bi bi-chat-left-text-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">${summary.totalComments}</h3>
                            <div class="text-muted small fw-medium mt-1">Total Comments</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3">
                    <div class="card p-4 h-100 d-flex flex-row align-items-center">
                        <div class="stat-icon icon-orange me-3">
                            <i class="bi bi-flag-fill"></i>
                        </div>
                        <div>
                            <h3 class="fw-bold mb-0 text-dark">${summary.totalReports}</h3>
                            <div class="text-muted small fw-medium mt-1">Reports Filed</div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Main Charts Row -->
            <div class="row g-4 mb-4">
                
                <!-- Bar Chart: Mimicking "Sales Revenue" -->
                <div class="col-lg-8">
                    <div class="card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold text-dark m-0">Content Growth</h5>
                            <select class="form-select form-select-sm w-auto border-0 bg-light text-muted fw-medium">
                                <option>Monthly</option>
                                <option>Weekly</option>
                            </select>
                        </div>
                        <div style="height: 300px; width: 100%;">
                            <canvas id="growthChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Donut Chart: Mimicking "Top Categories" -->
                <div class="col-lg-4">
                    <div class="card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold text-dark m-0">User Status</h5>
                            <i class="bi bi-three-dots text-muted"></i>
                        </div>
                        <div style="height: 250px; width: 100%; position: relative;" class="d-flex justify-content-center align-items-center">
                            <canvas id="usersDonut"></canvas>
                        </div>
                        <div class="d-flex justify-content-center gap-4 mt-4">
                            <div class="text-center">
                                <div class="d-flex align-items-center justify-content-center mb-1">
                                    <span class="d-inline-block rounded-circle bg-primary me-2" style="width:10px;height:10px;"></span>
                                    <span class="small text-muted fw-medium">Active</span>
                                </div>
                                <div class="fw-bold text-dark">${summary.activeUsers}</div>
                            </div>
                            <div class="text-center">
                                <div class="d-flex align-items-center justify-content-center mb-1">
                                    <span class="d-inline-block rounded-circle me-2" style="width:10px;height:10px;background-color: #ef4444;"></span>
                                    <span class="small text-muted fw-medium">Suspended</span>
                                </div>
                                <div class="fw-bold text-dark">${summary.suspendedUsers}</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- Lists Row -->
            <div class="row g-4">
                
                <!-- Recent Activities (Mimicking bottom-left list) -->
                <div class="col-lg-5">
                    <div class="card p-4 h-100">
                        <h5 class="fw-bold text-dark mb-4">Recent Activities</h5>
                        <div class="d-flex flex-column gap-3">
                            <c:choose>
                                <c:when test="${not empty summary.recentActivities}">
                                    <c:forEach items="${summary.recentActivities}" var="a" begin="0" end="4">
                                        <div class="d-flex align-items-center pb-3 border-bottom border-light">
                                            <div class="bg-light rounded p-2 me-3 text-secondary">
                                                <i class="bi bi-clock-history"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-semibold text-dark small"><c:out value="${a.action}" /></div>
                                                <div class="text-muted" style="font-size: 0.75rem;"><c:out value="${a.description}" /></div>
                                            </div>
                                            <div class="text-muted" style="font-size: 0.75rem;">${a.createdAt}</div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-muted text-center py-4 small">No recent activities.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Latest Reports Table (Mimicking Top Products table) -->
                <div class="col-lg-7">
                    <div class="card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="fw-bold text-dark m-0">Latest Reports</h5>
                            <a href="${pageContext.request.contextPath}/admin/reports" class="text-primary small text-decoration-none fw-medium">See all</a>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-custom table-borderless align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Target</th>
                                        <th>Reason</th>
                                        <th>Status</th>
                                        <th class="text-end">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty summary.latestReports}">
                                            <c:forEach items="${summary.latestReports}" var="r" begin="0" end="4">
                                                <tr>
                                                    <td>
                                                        <div class="fw-semibold text-dark small"><c:out value="${r.targetType}" /> Report</div>
                                                    </td>
                                                    <td>
                                                        <span class="text-muted small text-truncate d-inline-block" style="max-width: 150px;"><c:out value="${r.reason}" /></span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${r.status == 'Pending' ? 'bg-warning-subtle text-warning' : 'bg-success-subtle text-success'} px-2 py-1 rounded-pill" style="font-size: 0.7rem;">${r.status}</span>
                                                    </td>
                                                    <td class="text-end">
                                                        <a href="${pageContext.request.contextPath}/admin/reports/${r.id}" class="btn btn-light btn-sm rounded px-3 text-secondary small fw-medium">Review</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted small">No reports found.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

        </div> 
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Users Donut Chart
        const usersCtx = document.getElementById('usersDonut').getContext('2d');
        new Chart(usersCtx, {
            type: 'doughnut',
            data: {
                labels: ['Active', 'Suspended'],
                datasets: [{
                    data: [${summary.activeUsers}, ${summary.suspendedUsers}],
                    backgroundColor: ['#3b82f6', '#ef4444'],
                    borderWidth: 0,
                    hoverOffset: 4,
                    cutout: '75%'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false 
                    },
                    tooltip: {
                        padding: 12,
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        bodyFont: { size: 13 },
                        cornerRadius: 8
                    }
                }
            }
        });

        // Real Data for Content Growth Bar Chart
        const growthCtx = document.getElementById('growthChart').getContext('2d');
        
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        const monthlySheets = ${summary.monthlyCheatsheetCounts};
        const monthlyUsers = ${summary.monthlyActiveUserCounts};

        new Chart(growthCtx, {
            type: 'bar',
            data: {
                labels: months,
                datasets: [
                    {
                        label: 'CheatSheets Created',
                        data: monthlySheets,
                        backgroundColor: '#3b82f6',
                        borderRadius: 4,
                        barPercentage: 0.6,
                        categoryPercentage: 0.5
                    },
                    {
                        label: 'Active Users',
                        data: monthlyUsers,
                        backgroundColor: '#93c5fd',
                        borderRadius: 4,
                        barPercentage: 0.6,
                        categoryPercentage: 0.5
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        align: 'end',
                        labels: {
                            usePointStyle: true,
                            boxWidth: 8,
                            padding: 20,
                            font: {
                                size: 12,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#6b7280'
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: '#f3f4f6',
                            drawBorder: false
                        },
                        ticks: {
                            color: '#9ca3af',
                            font: { size: 11 },
                            padding: 10
                        },
                        border: { display: false }
                    },
                    x: {
                        grid: {
                            display: false,
                            drawBorder: false
                        },
                        ticks: {
                            color: '#6b7280',
                            font: { size: 11 },
                            padding: 10
                        },
                        border: { display: false }
                    }
                }
            }
        });
    </script>
</body>
</html>