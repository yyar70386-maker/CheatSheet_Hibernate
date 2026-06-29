<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcement Editor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4" style="max-width: 820px;">
    <div class="bg-white border rounded-4 p-4 shadow-sm">
        <h3 class="fw-bold mb-4">${announcement.id == null ? 'Create Announcement' : 'Edit Announcement'}</h3>
        <form action="${pageContext.request.contextPath}/admin/announcements/${announcement.id == null ? 'save' : 'update'}" method="post">
            <c:if test="${announcement.id != null}">
                <input type="hidden" name="id" value="${announcement.id}">
            </c:if>
            <div class="mb-3">
                <label class="form-label">Title</label>
                <input type="text" class="form-control" name="title" value="${announcement.title}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Content</label>
                <textarea class="form-control" name="content" rows="8" required><c:out value="${announcement.content}" /></textarea>
            </div>
            <div class="d-flex justify-content-end gap-2">
                <a href="${pageContext.request.contextPath}/admin/announcements" class="btn btn-outline-secondary">Cancel</a>
                <button class="btn btn-primary" type="submit">Save</button>
            </div>
        </form>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
