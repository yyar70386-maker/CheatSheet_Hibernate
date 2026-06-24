<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />

<main class="container py-4" style="max-width: 980px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Announcements</h3>
            <div class="text-muted small">Platform-wide updates and admin notices</div>
        </div>
        <c:if test="${sessionScope.currentUser.role == 1}">
            <a href="${pageContext.request.contextPath}/admin/announcements/add" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i> New Announcement
            </a>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty announcements}">
            <div class="text-center bg-white border rounded-4 py-5">
                <i class="bi bi-megaphone display-5 text-muted d-block mb-2"></i>
                <div class="fw-semibold">No announcements yet</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-grid gap-3">
                <c:forEach items="${announcements}" var="a">
                    <div class="bg-white border rounded-4 p-4 shadow-sm">
                        <div class="d-flex justify-content-between align-items-start gap-3">
                            <div>
                                <h5 class="fw-bold mb-2">${a.title}</h5>
                                <p class="mb-3 text-muted">${a.content}</p>
                                <div class="text-muted small">
                                    <c:out value="${a.createdBy != null ? (a.createdBy.fullName != null ? a.createdBy.fullName : a.createdBy.username) : 'Admin'}" />
                                    <span class="mx-2">•</span>${a.createdAt}
                                </div>
                            </div>
                            <c:if test="${sessionScope.currentUser.role == 1}">
                                <div class="d-flex gap-2">
                                    <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/announcements/edit/${a.id}">Edit</a>
                                    <form action="${pageContext.request.contextPath}/admin/announcements/delete/${a.id}" method="post">
                                        <button class="btn btn-outline-danger btn-sm" type="submit">Delete</button>
                                    </form>
                                </div>
                            </c:if>
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
