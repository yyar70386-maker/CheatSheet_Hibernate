<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Cheat Sheet Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
    <jsp:include page="header.jsp" />

    <main class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h3 fw-bold mb-0">Notifications</h1>
            <form method="post" action="${pageContext.request.contextPath}/notifications/read-all">
                <button class="btn btn-outline-primary btn-sm" type="submit">
                    <i class="bi bi-check2-all me-1"></i> Mark all as read
                </button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="text-center text-muted py-5">
                    <i class="bi bi-bell-slash display-5 d-block mb-3"></i>
                    No notifications yet.
                </div>
            </c:when>
            <c:otherwise>
                <div class="list-group shadow-sm">
                    <c:forEach items="${notifications}" var="notification">
                        <div class="list-group-item d-flex justify-content-between gap-3 ${notification.isRead ? '' : 'list-group-item-primary'}">
                            <div>
                                <div class="fw-semibold"><c:out value="${empty notification.title ? notification.notificationType : notification.title}" /></div>
                                <div><c:out value="${notification.message}" /></div>
                                <div class="text-muted small">${notification.createdAt}</div>
                                <c:if test="${not empty notification.linkUrl}">
                                    <a class="small text-decoration-none" href="${pageContext.request.contextPath}${notification.linkUrl}">
                                        Open
                                    </a>
                                </c:if>
                            </div>
                            <div class="d-flex gap-2 align-items-start">
                                <c:if test="${not notification.isRead}">
                                    <form method="post" action="${pageContext.request.contextPath}/notifications/${notification.id}/read">
                                        <button class="btn btn-sm btn-light" type="submit" title="Mark as read">
                                            <i class="bi bi-check2"></i>
                                        </button>
                                    </form>
                                </c:if>
                                <form method="post" action="${pageContext.request.contextPath}/notifications/${notification.id}/delete" onsubmit="return confirm('Delete this notification?');">
                                    <button class="btn btn-sm btn-light" type="submit">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
