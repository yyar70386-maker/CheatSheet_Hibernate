<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appeals Management - Admin</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
    </style>
</head>
<body class="bg-light">

    <%-- 🧩 Header Navbar --%>
    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <%-- 🛠️ Left Sidebar --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="appeals" />
        </jsp:include>

        <%-- 📂 Main Content Area --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Appeals Management</h2>
                    <p class="text-muted m-0 small">Review and resolve user appeals for banned cheatsheets and deleted comments.</p>
                </div>
            </div>

            <%-- Alert Messages --%>
            <c:if test="${param.resolved == 'true'}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Appeal resolved successfully.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- 📊 Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4">ID</th>
                                    <th>User</th>
                                    <th>Target</th>
                                    <th>Reason</th>
                                    <th>Submitted At</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty appeals}">
                                        <c:forEach var="appeal" items="${appeals}">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">${appeal.id}</td>
                                                <td>
                                                    <div class="fw-medium text-dark">${appeal.user.username}</div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary-subtle text-secondary">${appeal.targetType}</span>
                                                    <span class="ms-1 fw-bold">#${appeal.targetId}</span>
                                                </td>
                                                <td>
                                                    <div style="max-width: 300px; white-space: normal;">
                                                        <c:out value="${appeal.reason}" />
                                                    </div>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${appeal.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${appeal.status == 'PENDING'}">
                                                            <span class="badge bg-warning text-dark px-2 py-1 rounded small"><i class="bi bi-clock me-1"></i>PENDING</span>
                                                        </c:when>
                                                        <c:when test="${appeal.status == 'APPROVED'}">
                                                            <span class="badge bg-success text-white px-2 py-1 rounded small"><i class="bi bi-check-circle me-1"></i>APPROVED</span>
                                                        </c:when>
                                                        <c:when test="${appeal.status == 'REJECTED'}">
                                                            <span class="badge bg-danger text-white px-2 py-1 rounded small"><i class="bi bi-x-circle me-1"></i>REJECTED</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        <c:if test="${appeal.status == 'PENDING'}">
                                                            <form method="post" action="${pageContext.request.contextPath}/appeals/admin/resolve" class="d-inline">
                                                                <input type="hidden" name="appealId" value="${appeal.id}">
                                                                <input type="hidden" name="status" value="APPROVED">
                                                                <button type="submit" class="btn btn-sm btn-success rounded-2 px-2.5 py-1" onclick="return confirm('Approve this appeal? The content will be restored.');">Approve</button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/appeals/admin/resolve" class="d-inline">
                                                                <input type="hidden" name="appealId" value="${appeal.id}">
                                                                <input type="hidden" name="status" value="REJECTED">
                                                                <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-2.5 py-1" onclick="return confirm('Reject this appeal? The content will remain banned/deleted.');">Reject</button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox display-4 d-block mb-3 text-secondary"></i>
                                                No pending appeals.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
