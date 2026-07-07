<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Cheat Sheet Project</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            font-family: 'Outfit', sans-serif;
            background-color: #f8fafc !important;
            color: #1e293b;
        }
        .page-title {
            color: #0f172a;
            font-weight: 700;
            letter-spacing: -0.02em;
        }
        .notifications-container {
            max-width: 850px;
            margin: 0 auto;
        }
        .notification-card {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        .notification-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 20px -8px rgba(0, 0, 0, 0.08) !important;
            border-color: #cbd5e1;
        }
        .bg-unread {
            background-color: #f8fafc;
        }
        .border-brand {
            border-left: 4px solid #ff3366 !important;
        }
        .border-normal {
            border-left: 4px solid #e2e8f0 !important;
        }
        .noti-icon-wrapper {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .icon-announcement { background-color: rgba(59, 130, 246, 0.08); color: #3b82f6; }
        .icon-ban { background-color: rgba(239, 68, 68, 0.08); color: #ef4444; }
        .icon-restore { background-color: rgba(34, 197, 94, 0.08); color: #22c55e; }
        .icon-follow { background-color: rgba(6, 182, 212, 0.08); color: #06b6d4; }
        .icon-report { background-color: rgba(245, 158, 11, 0.08); color: #f59e0b; }
        .icon-default { background-color: rgba(100, 116, 139, 0.08); color: #64748b; }
        
        .badge-pill-small {
            font-size: 0.65rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 0.25rem 0.6rem;
            border-radius: 30px;
        }
        .badge-announcement { background-color: rgba(59, 130, 246, 0.1); color: #2563eb; }
        .badge-ban { background-color: rgba(239, 68, 68, 0.1); color: #dc2626; }
        .badge-restore { background-color: rgba(34, 197, 94, 0.1); color: #16a34a; }
        .badge-follow { background-color: rgba(6, 182, 212, 0.1); color: #0891b2; }
        .badge-report { background-color: rgba(245, 158, 11, 0.1); color: #d97706; }
        .badge-new { background-color: #ff3366; color: #ffffff; }

        .btn-action-icon {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #e2e8f0;
            background-color: #ffffff;
            color: #64748b;
            transition: all 0.2s ease;
        }
        .btn-action-icon:hover {
            background-color: #f1f5f9;
            color: #334155;
            border-color: #cbd5e1;
        }
        .btn-action-read:hover {
            background-color: rgba(34, 197, 94, 0.08);
            color: #22c55e;
            border-color: rgba(34, 197, 94, 0.2);
        }
        .btn-action-delete:hover {
            background-color: rgba(239, 68, 68, 0.08);
            color: #ef4444;
            border-color: rgba(239, 68, 68, 0.2);
        }
        .btn-open-link {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.8rem;
            font-weight: 600;
            color: #ff3366;
            transition: all 0.2s ease;
        }
        .btn-open-link:hover {
            color: #e62e5c;
            transform: translateX(2px);
        }
        .btn-mark-all {
            border: 1px solid #e2e8f0;
            background-color: #ffffff;
            color: #475569;
            font-weight: 500;
            transition: all 0.2s ease;
            border-radius: 10px;
        }
        .btn-mark-all:hover {
            background-color: #f8fafc;
            color: #0f172a;
            border-color: #cbd5e1;
        }
        .empty-state {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
        }
        .animate-pulse {
            animation: pulse 1.8s infinite ease-in-out;
        }
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.05); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="header.jsp" />

    <main class="container py-5">
        <div class="notifications-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 page-title mb-1">Notifications</h1>
                    <p class="text-muted small mb-0">Manage your system alerts and activities</p>
                </div>
                <c:if test="${not empty notifications}">
                    <form method="post" action="${pageContext.request.contextPath}/notifications/read-all" class="m-0">
                        <button class="btn btn-mark-all btn-sm px-3 py-2" type="submit">
                            <i class="bi bi-check2-all me-1.5"></i> Mark all as read
                        </button>
                    </form>
                </c:if>
            </div>

            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="text-center py-5 empty-state shadow-sm p-5">
                        <div class="d-inline-flex align-items-center justify-content-center bg-light rounded-circle p-4 mb-3" style="width: 80px; height: 80px;">
                            <i class="bi bi-bell-slash text-muted display-6"></i>
                        </div>
                        <h5 class="fw-bold mb-1">No alerts yet</h5>
                        <p class="text-muted mb-0 small">We will let you know when you receive new updates.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="d-grid gap-2">
                        <c:forEach items="${notifications}" var="n">
                            <div id="noti-card-${n.id}" class="notification-card rounded-3 p-3.5 d-flex justify-content-between align-items-center shadow-sm gap-3 ${n.isRead ? 'border-normal' : 'bg-unread border-brand'}">
                                <div class="d-flex gap-3 align-items-start">
                                    <div class="noti-icon-wrapper 
                                        <c:choose>
                                            <c:when test="${n.notificationType == 'ANNOUNCEMENT'}">icon-announcement</c:when>
                                            <c:when test="${n.notificationType == 'CHEATSHEET_BAN' || n.notificationType == 'COMMENT_BAN'}">icon-ban</c:when>
                                            <c:when test="${n.notificationType == 'CHEATSHEET_RESTORE' || n.notificationType == 'COMMENT_RESTORE'}">icon-restore</c:when>
                                            <c:when test="${n.notificationType == 'FOLLOW'}">icon-follow</c:when>
                                            <c:when test="${n.notificationType == 'REPORT'}">icon-report</c:when>
                                            <c:otherwise>icon-default</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${n.notificationType == 'ANNOUNCEMENT'}">
                                                <i class="bi bi-megaphone-fill fs-5"></i>
                                            </c:when>
                                            <c:when test="${n.notificationType == 'CHEATSHEET_BAN' || n.notificationType == 'COMMENT_BAN'}">
                                                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                                            </c:when>
                                            <c:when test="${n.notificationType == 'CHEATSHEET_RESTORE' || n.notificationType == 'COMMENT_RESTORE'}">
                                                <i class="bi bi-check-circle-fill fs-5"></i>
                                            </c:when>
                                            <c:when test="${n.notificationType == 'FOLLOW'}">
                                                <i class="bi bi-person-plus-fill fs-5"></i>
                                            </c:when>
                                            <c:when test="${n.notificationType == 'REPORT'}">
                                                <i class="bi bi-flag-fill fs-5"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-bell-fill fs-5"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-1 flex-wrap">
                                            <h6 class="fw-bold mb-0 text-dark">
                                                <c:out value="${empty n.title ? n.notificationType : n.title}" />
                                            </h6>
                                            <c:choose>
                                                <c:when test="${n.notificationType == 'CHEATSHEET_BAN' || n.notificationType == 'COMMENT_BAN'}">
                                                    <span class="badge-pill-small badge-ban">Banned</span>
                                                </c:when>
                                                <c:when test="${n.notificationType == 'CHEATSHEET_RESTORE' || n.notificationType == 'COMMENT_RESTORE'}">
                                                    <span class="badge-pill-small badge-restore">Restored</span>
                                                </c:when>
                                                <c:when test="${n.notificationType == 'ANNOUNCEMENT'}">
                                                    <span class="badge-pill-small badge-announcement">Announcement</span>
                                                </c:when>
                                                <c:when test="${n.notificationType == 'FOLLOW'}">
                                                    <span class="badge-pill-small badge-follow">Follower</span>
                                                </c:when>
                                                <c:when test="${n.notificationType == 'REPORT'}">
                                                    <span class="badge-pill-small badge-report">Report</span>
                                                </c:when>
                                            </c:choose>
                                            <c:if test="${!n.isRead}">
                                                <span class="badge-pill-small badge-new animate-pulse">New</span>
                                            </c:if>
                                        </div>
                                        <p class="text-secondary mb-1.5 small"><c:out value="${n.message}" /></p>
                                        <div class="d-flex align-items-center gap-3">
                                            <span class="text-muted small" style="font-size: 11px;"><i class="bi bi-clock-history me-1"></i>${n.createdAt}</span>
                                            <c:if test="${not empty n.linkUrl}">
                                                <a class="btn-open-link text-decoration-none small fw-semibold" href="${pageContext.request.contextPath}${n.linkUrl}">
                                                    Open <i class="bi bi-arrow-right-short"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-flex gap-2 align-items-center">
                                    <c:if test="${!n.isRead}">
                                        <form method="post" action="${pageContext.request.contextPath}/notifications/${n.id}/read" class="m-0">
                                            <button class="btn btn-action-icon btn-action-read" type="submit" title="Mark as read">
                                                <i class="bi bi-check2"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                    <form method="post" action="${pageContext.request.contextPath}/notifications/${n.id}/delete" onsubmit="return confirm('Delete this notification?');" class="m-0">
                                        <button class="btn btn-action-icon btn-action-delete" type="submit" title="Delete notification">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
