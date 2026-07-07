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

<div class="app-container">
    <c:if test="${sessionScope.currentUser.role == 1}">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="announcements" />
        </jsp:include>
    </c:if>

    <div class="${sessionScope.currentUser.role == 1 ? 'main-content-area' : 'container py-4'}" style="${sessionScope.currentUser.role != 1 ? 'max-width: 980px;' : ''}">
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
            <div class="text-center bg-white border rounded-3 py-5">
                <i class="bi bi-megaphone display-5 text-muted d-block mb-2"></i>
                <div class="fw-semibold">No announcements yet</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-grid gap-3">
                <c:forEach items="${announcements}" var="a">
                    <div class="border rounded-3 p-4 shadow-sm ${readStatusMap[a.id] == false ? 'bg-primary bg-opacity-10 border-primary' : 'bg-white'}">
                        <div class="d-flex justify-content-between align-items-start gap-3">
                            <div>
                                <h5 class="fw-bold mb-2">
                                    <c:out value="${a.title}" />
                                    <c:if test="${readStatusMap[a.id] == false}">
                                        <span class="badge bg-primary ms-2" style="font-size: 0.75rem;">New</span>
                                    </c:if>
                                </h5>
                                <p class="mb-3 text-muted"><c:out value="${a.content}" /></p>
                                <div class="text-muted small d-flex align-items-center flex-wrap gap-2">
                                    <span>By <c:out value="${a.createdBy != null ? (a.createdBy.fullName != null ? a.createdBy.fullName : a.createdBy.username) : 'Admin'}" /></span>
                                    <span>|</span>
                                    <span>${a.createdAt}</span>
                                    <span>|</span>
                                    <span class="badge text-bg-${a.status == 'active' ? 'success' : 'secondary'}">${a.status}</span>
                                    <c:if test="${readStatusMap[a.id] == false}">
                                        <span class="mx-1">|</span>
                                        <form action="${pageContext.request.contextPath}/notifications/${announcementNotiIdMap[a.id]}/read" method="post" class="d-inline m-0">
                                            <input type="hidden" name="redirect" value="/announcements" />
                                            <button type="submit" class="btn btn-sm btn-outline-primary py-0 px-2 fw-semibold" style="font-size: 0.75rem; border-radius: 4px; line-height: 1.5;">
                                                <i class="bi bi-check2 me-1"></i> Mark as read
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                            <c:if test="${sessionScope.currentUser.role == 1}">
                                <div class="d-flex gap-2 flex-wrap justify-content-end">
                                    <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/announcements/edit/${a.id}">Edit</a>
                                    <c:choose>
                                        <c:when test="${a.status == 'active'}">
                                            <form action="${pageContext.request.contextPath}/admin/announcements/${a.id}/status/inactive" method="post">
                                                <button class="btn btn-outline-warning btn-sm" type="submit">Deactivate</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/admin/announcements/${a.id}/status/active" method="post">
                                                <button class="btn btn-outline-success btn-sm" type="submit">Activate</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                    <form action="${pageContext.request.contextPath}/admin/announcements/delete/${a.id}" method="post" onsubmit="return confirm('Delete this announcement?');">
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
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
