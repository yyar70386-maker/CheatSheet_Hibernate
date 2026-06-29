<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <h3 class="fw-bold mb-4">Reports</h3>
    <div class="bg-white border rounded-4 overflow-hidden shadow-sm">
        <table class="table mb-0">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Sheet</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${reports}" var="r">
                    <tr>
                        <td>${r.id}</td>
                        <td><c:out value="${r.user != null ? r.user.username : 'Unknown'}" /></td>
                        <td>${r.sheetId}</td>
                        <td>${r.reason}</td>
                        <td><span class="badge text-bg-secondary">${r.status}</span></td>
                        <td>
                            <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.id}/status/Reviewed">
                                <button class="btn btn-sm btn-outline-primary">Reviewed</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
