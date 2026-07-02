<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <h3 class="fw-bold mb-3">Reports</h3>
    <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/reports">
        <div class="col-md-4"><input class="form-control" name="q" value="${keyword}" placeholder="Search reporter, reason, description"></div>
        <div class="col-md-3">
            <select class="form-select" name="status">
                <option value="">All statuses</option>
                <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                <option value="Reviewing" ${status == 'Reviewing' ? 'selected' : ''}>Reviewing</option>
                <option value="Resolved" ${status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
            </select>
        </div>
        <div class="col-md-3">
            <select class="form-select" name="targetType">
                <option value="">All targets</option>
                <option value="CHEATSHEET" ${targetType == 'CHEATSHEET' ? 'selected' : ''}>Cheatsheet</option>
                <option value="COMMENT" ${targetType == 'COMMENT' ? 'selected' : ''}>Comment</option>
                <option value="USER" ${targetType == 'USER' ? 'selected' : ''}>User</option>
            </select>
        </div>
        <div class="col-md-2"><button class="btn btn-primary w-100" type="submit"><i class="bi bi-filter me-1"></i>Apply</button></div>
    </form>

    <div class="bg-white border rounded-3 overflow-hidden shadow-sm">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Reporter</th>
                    <th>Target</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty reports}">
                        <tr><td colspan="7" class="text-center text-muted py-5">No reports found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${reports}" var="r">
                            <tr>
                                <td>${r.id}</td>
                                <td><c:out value="${r.user != null ? r.user.username : 'Unknown'}" /></td>
                                <td><span class="badge text-bg-light border">${r.targetType}</span> #${r.targetId != null ? r.targetId : r.sheetId}</td>
                                <td><c:out value="${r.reason}" /></td>
                                <td><span class="badge text-bg-secondary">${r.status}</span></td>
                                <td>${r.createdAt}</td>
                                <td class="text-end">
                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/reports/${r.id}">View</a>
                                    <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.id}/status/Reviewing"><button class="btn btn-sm btn-outline-secondary">Reviewing</button></form>
                                    <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.id}/status/Resolved"><button class="btn btn-sm btn-outline-success">Resolved</button></form>
                                    <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.id}/status/Rejected"><button class="btn btn-sm btn-outline-warning">Rejected</button></form>
                                    <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.id}/delete" onsubmit="return confirm('Delete this report?');"><button class="btn btn-sm btn-outline-danger">Delete</button></form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <nav class="mt-3">
        <ul class="pagination justify-content-end">
            <c:forEach begin="1" end="${totalPages}" var="p">
                <li class="page-item ${p == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/reports?page=${p}&q=${keyword}&status=${status}&targetType=${targetType}">${p}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
