<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <a class="btn btn-sm btn-outline-secondary mb-3" href="${pageContext.request.contextPath}/admin/reports">Back</a>
    <div class="bg-white border rounded-3 p-4 shadow-sm">
        <h3 class="fw-bold mb-4">Report #${report.id}</h3>
        <dl class="row">
            <dt class="col-sm-3">Reporter</dt><dd class="col-sm-9"><c:out value="${report.user != null ? report.user.username : 'Unknown'}" /></dd>
            <dt class="col-sm-3">Target</dt><dd class="col-sm-9">${report.targetType} #${report.targetId != null ? report.targetId : report.sheetId}</dd>
            <dt class="col-sm-3">Reason</dt><dd class="col-sm-9"><c:out value="${report.reason}" /></dd>
            <dt class="col-sm-3">Description</dt><dd class="col-sm-9"><c:out value="${report.description}" /></dd>
            <dt class="col-sm-3">Status</dt><dd class="col-sm-9"><span class="badge text-bg-secondary">${report.status}</span></dd>
            <dt class="col-sm-3">Created</dt><dd class="col-sm-9">${report.createdAt}</dd>
        </dl>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
