<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="fw-bold mb-1">Audit Logs</h3>
            <div class="text-muted small">Search and review important system activity.</div>
        </div>
    </div>

    <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/admin/audit-logs">
        <div class="col-md-5">
            <input class="form-control" name="q" value="${keyword}" placeholder="Search action, user, description">
        </div>
        <div class="col-md-3">
            <select class="form-select" name="entityType">
                <option value="">All entities</option>
                <option value="User" ${entityType == 'User' ? 'selected' : ''}>User</option>
                <option value="Cheatsheet" ${entityType == 'Cheatsheet' ? 'selected' : ''}>Cheatsheet</option>
                <option value="Category" ${entityType == 'Category' ? 'selected' : ''}>Category</option>
                <option value="Tag" ${entityType == 'Tag' ? 'selected' : ''}>Tag</option>
                <option value="Comment" ${entityType == 'Comment' ? 'selected' : ''}>Comment</option>
                <option value="Report" ${entityType == 'Report' ? 'selected' : ''}>Report</option>
                <option value="Announcement" ${entityType == 'Announcement' ? 'selected' : ''}>Announcement</option>
            </select>
        </div>
        <div class="col-md-2">
            <button class="btn btn-primary w-100" type="submit"><i class="bi bi-search me-1"></i>Search</button>
        </div>
        <div class="col-md-2">
            <a class="btn btn-outline-secondary w-100" href="${pageContext.request.contextPath}/admin/audit-logs">Reset</a>
        </div>
    </form>

    <div class="bg-white border rounded-3 overflow-hidden shadow-sm">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr>
                    <th>S.No</th>
                    <th>User</th>
                    <th>Action</th>
                    <th>Entity</th>
                    <th>Created At</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty logs}">
                        <tr><td colspan="6" class="text-center text-muted py-5">No audit logs found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${logs}" var="log" varStatus="statusLoop">
                            <tr>
                                <td>${((currentPage - 1) * 15) + statusLoop.index + 1}</td>
                                <td><c:out value="${log.user != null ? log.user.username : 'System'}" /></td>
                                <td><c:out value="${log.action}" /></td>
                                <td><c:out value="${log.entityType != null ? log.entityType : log.entityName}" /> #${log.entityId}</td>
                                <td>${log.createdAt}</td>
                                <td class="text-end">
                                    <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/admin/audit-logs/${log.id}">View</a>
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
                    <a class="page-link" href="${pageContext.request.contextPath}/admin/audit-logs?page=${p}&q=${keyword}&entityType=${entityType}">${p}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
