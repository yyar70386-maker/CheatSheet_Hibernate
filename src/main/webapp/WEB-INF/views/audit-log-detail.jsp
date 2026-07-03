<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Log Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <a class="btn btn-sm btn-outline-secondary mb-3" href="${pageContext.request.contextPath}/admin/audit-logs">Back</a>
    <div class="bg-white border rounded-3 p-4 shadow-sm">
        <h3 class="fw-bold mb-4">Audit Log #${log.id}</h3>
        <dl class="row mb-0">
            <dt class="col-sm-3">User</dt><dd class="col-sm-9"><c:out value="${log.user != null ? log.user.username : 'System'}" /></dd>
            <dt class="col-sm-3">Action</dt><dd class="col-sm-9"><c:out value="${log.action}" /></dd>
            <dt class="col-sm-3">Entity</dt><dd class="col-sm-9"><c:out value="${log.entityType != null ? log.entityType : log.entityName}" /> #${log.entityId}</dd>
            <dt class="col-sm-3">Description</dt><dd class="col-sm-9"><c:out value="${log.description}" /></dd>
            <dt class="col-sm-3">IP Address</dt><dd class="col-sm-9"><c:out value="${log.ipAddress}" /></dd>
            <dt class="col-sm-3">Created At</dt><dd class="col-sm-9">${log.createdAt}</dd>
        </dl>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
