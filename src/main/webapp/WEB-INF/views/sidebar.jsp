<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- ADMIN SIDEBAR --%>
<c:if test="${sessionScope.currentUser.role == 1}">
    <div class="d-flex flex-column flex-shrink-0 p-3 text-white bg-dark admin-sidebar"
         style="box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05); height: 100%; overflow-y: auto;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <i class="bi bi-shield-lock-fill me-2 fs-4 text-warning"></i>
            <span class="fs-4 fw-bold">Admin Panel</span>
        </a>
        <hr>

        <ul class="nav nav-pills flex-column mb-auto">
            <li>
                <a href="${pageContext.request.contextPath}/admin/dashboard"
                   class="nav-link text-white ${param.activePage == 'dashboard' ? 'active' : ''}">
                    <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
            </li>

            <li class="text-secondary small fw-bold mt-3 mb-1 px-2 text-uppercase" style="letter-spacing: 0.5px; font-size: 0.75rem;">Management</li>

            <li>
                <a href="${pageContext.request.contextPath}/category/list"
                   class="nav-link text-white ${param.activePage == 'categories' ? 'active' : ''}">
                    <i class="bi bi-tags me-2 text-secondary"></i> Category Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/tag/list"
                   class="nav-link text-white ${param.activePage == 'items' ? 'active' : ''}">
                    <i class="bi bi-box-seam me-2 text-secondary"></i> Tag Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="nav-link text-white ${param.activePage == 'users' ? 'active' : ''}">
                    <i class="bi bi-people me-2 text-secondary"></i> User Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/cheatsheets"
                   class="nav-link text-white ${param.activePage == 'cheatsheets' ? 'active' : ''}">
                    <i class="bi bi-file-earmark-code me-2 text-secondary"></i> CheatSheet Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet"
                   class="nav-link text-white ${param.activePage == 'cheatsheet-report' ? 'active' : ''}">
                    <i class="bi bi-file-earmark-bar-graph me-2 text-secondary"></i> CheatSheet Report
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/comments"
                   class="nav-link text-white ${param.activePage == 'comments' ? 'active' : ''}">
                    <i class="bi bi-chat-left-text me-2 text-secondary"></i> Comment Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/reports"
                   class="nav-link text-white ${param.activePage == 'reports' ? 'active' : ''}">
                    <i class="bi bi-flag me-2 text-secondary"></i> Reports
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/announcements"
                   class="nav-link text-white ${param.activePage == 'announcements' ? 'active' : ''}">
                    <i class="bi bi-megaphone me-2 text-secondary"></i> Announcements
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/notifications"
                   class="nav-link text-white ${param.activePage == 'notifications' ? 'active' : ''}">
                    <i class="bi bi-bell me-2 text-secondary"></i> Notifications
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/admin/audit-logs"
                   class="nav-link text-white ${param.activePage == 'audit-logs' ? 'active' : ''}">
                    <i class="bi bi-journal-text me-2 text-secondary"></i> Audit Logs
                </a>
            </li>
        </ul>
    </div>
</c:if>
