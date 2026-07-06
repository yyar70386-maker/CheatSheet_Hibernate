<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Detail - Admin Panel</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f8f9fa;
        }
        .navbar {
            height: 56px;
            z-index: 1030;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
        }
        .app-container {
            display: flex;
            height: calc(100vh - 56px); 
            width: 100%;
        }
        .main-content-area {
            flex-grow: 1;
            height: 100%;
            overflow-y: auto; 
            min-width: 0;
            padding: 24px;
            background-color: #f8f9fa;
        }
        
        /* Custom Theme Overrides */
        .btn-brand-primary {
            background-color: #ff3366 !important;
            border-color: #ff3366 !important;
            color: white !important;
        }
        .btn-brand-primary:hover {
            background-color: #e62e5c !important;
            border-color: #e62e5c !important;
        }
        .text-brand-primary {
            color: #ff3366 !important;
        }
    </style>
</head>
<body class="bg-light">

    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <%-- Left Sidebar --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="reports" />
        </jsp:include>

        <%-- Main Content Area --%>
        <div class="main-content-area">
            
            <div class="mb-4">
                <a class="btn btn-outline-secondary px-3 fw-medium" href="${pageContext.request.contextPath}/admin/reports">
                    <i class="bi bi-arrow-left me-2"></i>Back to Reports
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-3" style="max-width: 800px;">
                <div class="card-header bg-white py-3 border-bottom-0">
                    <h3 class="fw-bold mb-0 text-dark"><i class="bi bi-flag-fill text-danger me-2"></i>Report Details #${report.id}</h3>
                </div>
                <div class="card-body p-4">
                    <dl class="row mb-0 g-3">
                        <dt class="col-sm-3 text-secondary">Reporter</dt>
                        <dd class="col-sm-9 fw-semibold text-dark">
                            <c:out value="${report.user != null ? report.user.username : 'Unknown'}" />
                        </dd>
                        
                        <dt class="col-sm-3 text-secondary">Reported User</dt>
                        <dd class="col-sm-9">
                            <span class="badge bg-danger-subtle text-danger px-2 py-1 rounded">
                                <c:out value="${reportedUsername}" />
                            </span>
                        </dd>
                        
                        <dt class="col-sm-3 text-secondary">Target Type</dt>
                        <dd class="col-sm-9">
                            <span class="badge bg-secondary-subtle text-secondary px-2 py-1 rounded border">
                                ${report.targetType}
                            </span>
                        </dd>
                        
                        <dt class="col-sm-3 text-secondary">Target Content / Title</dt>
                        <dd class="col-sm-9">
                            <c:choose>
                                <c:when test="${targetUrl != '#'}">
                                    <a href="${pageContext.request.contextPath}${targetUrl}" class="text-decoration-none text-brand-primary fw-medium">
                                        <c:out value="${targetTitle}" />
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted"><c:out value="${targetTitle}" /></span>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                        
                        <dt class="col-sm-3 text-secondary">Reason</dt>
                        <dd class="col-sm-9 text-dark"><c:out value="${report.reason}" /></dd>
                        
                        <dt class="col-sm-3 text-secondary">Description</dt>
                        <dd class="col-sm-9 text-dark" style="white-space: pre-wrap;"><c:out value="${report.description}" /></dd>
                        
                        <dt class="col-sm-3 text-secondary">Status</dt>
                        <dd class="col-sm-9">
                            <c:choose>
                                <c:when test="${report.status == 'Pending'}">
                                    <span class="badge bg-warning-subtle text-warning"><i class="bi bi-clock-history me-1"></i>Pending</span>
                                </c:when>
                                <c:when test="${report.status == 'Reviewing'}">
                                    <span class="badge bg-info-subtle text-info"><i class="bi bi-eye-fill me-1"></i>Reviewing</span>
                                </c:when>
                                <c:when test="${report.status == 'Resolved'}">
                                    <span class="badge bg-success-subtle text-success"><i class="bi bi-check-circle-fill me-1"></i>Resolved</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger-subtle text-danger"><i class="bi bi-x-circle-fill me-1"></i>${report.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </dd>
                        
                        <dt class="col-sm-3 text-secondary">Created At</dt>
                        <dd class="col-sm-9 text-muted">${report.createdAt}</dd>
                    </dl>

                    <hr class="my-4" style="color: #e2e8f0;">

                    <div class="d-flex flex-wrap gap-2 justify-content-end">
                        <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${report.id}/status/Reviewing">
                            <button class="btn btn-outline-info px-3">Mark Reviewing</button>
                        </form>
                        <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${report.id}/status/Resolved">
                            <button class="btn btn-success px-3">Mark Resolved</button>
                        </form>
                        <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${report.id}/status/Rejected">
                            <button class="btn btn-warning px-3">Mark Rejected</button>
                        </form>
                        <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${report.id}/delete" onsubmit="return confirm('Delete this report?');">
                            <button class="btn btn-danger px-3"><i class="bi bi-trash me-1"></i>Delete Report</button>
                        </form>
                    </div>
                </div>
            </div>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
