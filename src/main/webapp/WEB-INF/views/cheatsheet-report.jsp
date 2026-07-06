<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CheatSheet Report - Admin</title>
    
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

    <%-- Header Navbar --%>
    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <%-- Left Sidebar --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="cheatsheet-report" />
        </jsp:include>

        <%-- Main Content Area --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">CheatSheet Report</h2>
                    <p class="text-muted m-0 small">Generate and export CheatSheet data reports.</p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a class="btn btn-danger text-white" href="${pageContext.request.contextPath}/admin/reports/cheatsheet/pdf?startDate=${param.startDate}&endDate=${param.endDate}" download="cheatsheet-report.pdf">
                        <i class="bi bi-filetype-pdf me-1"></i> View PDF
                    </a>
                    <a class="btn btn-success text-white" href="${pageContext.request.contextPath}/admin/reports/cheatsheet/excel?startDate=${param.startDate}&endDate=${param.endDate}" download="cheatsheet-report.xlsx">
                        <i class="bi bi-file-earmark-spreadsheet me-1"></i> Export Excel
                    </a>
                </div>
            </div>

            <%-- Date Filter Card --%>
            <div class="card border-0 shadow-sm rounded-3 p-4 mb-4 bg-white">
                <form action="${pageContext.request.contextPath}/admin/reports/cheatsheet" method="get" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Start Date</label>
                        <input type="date" name="startDate" class="form-control" value="${param.startDate}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">End Date</label>
                        <input type="date" name="endDate" class="form-control" value="${param.endDate}">
                    </div>
                    <div class="col-md-4 d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1" style="background-color: #ff3366 !important; border-color: #ff3366 !important;">
                            <i class="bi bi-filter me-1"></i> Filter
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="btn btn-outline-secondary">
                            Reset
                        </a>
                    </div>
                </form>
            </div>

            <%-- Summary Cards --%>
            <div class="row g-3 mb-4">
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-primary-subtle text-primary p-3 rounded-3 me-3">
                                <i class="bi bi-file-earmark-code-fill fs-4 brand-primary"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Total CheatSheets</div>
                                <div class="fs-3 fw-bold text-dark">${totalRecords}</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-success-subtle text-success p-3 rounded-3 me-3">
                                <i class="bi bi-download fs-4 text-success"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Export PDF</div>
                                <div class="fs-6 fw-semibold text-dark">
                                    <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet/pdf?startDate=${param.startDate}&endDate=${param.endDate}" class="text-decoration-none text-success" download="cheatsheet-report.pdf">
                                        <i class="bi bi-box-arrow-up-right me-1"></i>Download
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-warning-subtle text-warning p-3 rounded-3 me-3">
                                <i class="bi bi-file-earmark-excel fs-4 text-warning"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Export Excel</div>
                                <div class="fs-6 fw-semibold text-dark">
                                    <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet/excel?startDate=${param.startDate}&endDate=${param.endDate}" class="text-decoration-none text-warning" download="cheatsheet-report.xlsx">
                                        <i class="bi bi-box-arrow-up-right me-1"></i>Download
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="card border-0 shadow-sm rounded-3 stat-card h-100 p-3">
                        <div class="d-flex align-items-center">
                            <div class="bg-info-subtle text-info p-3 rounded-3 me-3">
                                <i class="bi bi-clock-history fs-4 text-info"></i>
                            </div>
                            <div>
                                <div class="text-secondary small fw-medium">Report Time</div>
                                <div class="fs-6 fw-semibold text-dark">${empty generatedAt ? '' : generatedAt}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4" style="width: 60px;">No</th>
                                    <th>CheatSheet Name</th>
                                    <th>Created User</th>
                                    <th>Created Date</th>
                                    <th style="width: 100px;">Reaction Count</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty reportData}">
                                        <c:forEach var="row" items="${reportData}">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">${row.no}</td>
                                                <td class="fw-medium text-dark">${row.cheatsheetName}</td>
                                                <td>${row.createdUser}</td>
                                                <td>${row.createdDate}</td>
                                                <td class="text-center">
                                                    <span class="badge bg-primary-subtle text-primary px-2 py-1 rounded">
                                                        ${row.reactionCount}
                                                    </span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="bi bi-file-earmark-code display-4 d-block mb-3 text-secondary"></i>
                                                No CheatSheet data available for the report.
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
