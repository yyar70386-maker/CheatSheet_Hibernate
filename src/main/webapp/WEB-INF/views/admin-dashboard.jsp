<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }
        /* Fixed Left Sidebar Design */
        .sidebar {
            width: 260px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #1e293b; /* Dark Slate Blue */
            padding-top: 20px;
            z-index: 1000;
            transition: all 0.3s;
        }
        .sidebar-brand {
            padding: 10px 25px;
            font-size: 1.25rem;
            font-weight: bold;
            color: #f8fafc;
            letter-spacing: 1px;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 20px 0 0 0;
        }
        .sidebar-menu li a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.95rem;
            transition: all 0.2s;
        }
        .sidebar-menu li a:hover, 
        .sidebar-menu li.active a {
            color: #ffffff;
            background-color: #334155;
            border-left: 4px solid #3b82f6; /* Accent Blue line */
        }
        .sidebar-menu li a i {
            font-size: 1.2rem;
            margin-right: 15px;
        }
        /* Main Content Container Adjustments */
        .main-content {
            margin-left: 260px; /* Same as sidebar width */
            padding: 30px;
            min-height: 100vh;
        }
        .metric-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
            transition: transform 0.2s;
        }
        .metric-card:hover {
            transform: translateY(-3px);
        }
        .data-table-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand d-flex align-items-center">
            <i class="bi bi-speedometer2 me-2 text-primary"></i>
            <span>ADMIN CORE</span>
        </div>
        <hr class="text-secondary mx-3">
        <ul class="sidebar-menu">
            <li class="active">
                <a href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-house-door-fill"></i> Dashboard
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="bi bi-people-fill"></i> User Management
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="bi bi-shield-lock-fill"></i> Role Operations
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="bi bi-bar-chart-line-fill"></i> Analytics
                </a>
            </li>
            <li>
                <a href="#">
                    <i class="bi bi-gear-fill"></i> Global Settings
                </a>
            </li>
            <li class="mt-5">
                <a href="${pageContext.request.contextPath}/logout" class="text-danger">
                    <i class="bi bi-box-arrow-right text-danger"></i> Sign Out
                </a>
            </li>
        </ul>
    </div>
    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h2 class="fw-bold text-dark mb-0">System Analytics</h2>
                <small class="text-muted">Welcome back to your master control panel.</small>
            </div>
            <div class="d-flex align-items-center">
                <span class="badge bg-primary px-3 py-2 rounded-pill">Role: Master Admin</span>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <c:forEach var="metric" items="${metrics}">
                <div class="col-12 col-md-4">
                    <div class="card metric-card bg-white p-4">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted text-uppercase small fw-bold tracking-wider">${metric.metricName}</span>
                                <h2 class="mb-0 mt-2 fw-bold text-dark">${metric.metricValue}</h2>
                            </div>
                            <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-3">
                                <i class="bi bi-people fs-3"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="card data-table-card p-4 bg-white">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-dark mb-0"><i class="bi bi-table me-2 text-secondary"></i>Recent Registered User Logs</h5>
                <button class="btn btn-sm btn-outline-primary"><i class="bi bi-download me-1"></i> Export Logs</button>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-secondary">
                        <tr>
                            <th scope="col" style="width: 80px;">User ID</th>
                            <th scope="col">Username</th>
                            <th scope="col">Email Address</th>
                            <th scope="col">Full Name</th>
                            <th scope="col" class="text-center">Role Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <%-- ၁။ သင့် system တွင် users list ရှိမရှိ အရင်စစ်သည် --%>
                            <c:when test="${not empty users}">
                                <%-- ၂။ ရှိပါက loop ပတ်၍ table row တစ်ခုချင်းစီ ဆောက်သည် --%>
                                <c:forEach var="user" items="${users}">
                                    <tr>
                                        <td class="fw-bold text-secondary">#${user.id}</td>
                                        <td><span class="badge bg-light text-dark font-monospace">${user.username}</span></td>
                                        <td>${user.email}</td>
                                        <td>${user.fullName}</td>
                                        
                                        <%-- ၃။ Role Status အား စစ်ဆေးရမည့် နေရာအမှန် --%>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${user.role == 1}">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-1">Admin</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-1">Standard User</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            
                            <%-- ၄။ တကယ်လို့ database ထဲတွင် user လုံးဝမရှိပါက ပြသမည့်စာသား --%>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i> No active users found in database record.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>