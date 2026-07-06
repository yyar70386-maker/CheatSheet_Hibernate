<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Content Reports - Admin Panel</title>
    
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
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Content Reports</h2>
                    <p class="text-muted m-0 small">Review and manage content reports submitted by users.</p>
                </div>
            </div>

            <%-- Filter Card --%>
            <div class="card border-0 shadow-sm rounded-3 p-4 mb-4 bg-white">
                <form class="row g-3 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/reports">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Search</label>
                        <input class="form-control" name="q" value="${keyword}" placeholder="Search reporter, reason...">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-secondary">Status</label>
                        <select class="form-select" name="status">
                            <option value="">All Statuses</option>
                            <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Reviewing" ${status == 'Reviewing' ? 'selected' : ''}>Reviewing</option>
                            <option value="Resolved" ${status == 'Resolved' ? 'selected' : ''}>Resolved</option>
                            <option value="Rejected" ${status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold text-secondary">Target Type</label>
                        <select class="form-select" name="targetType">
                            <option value="">All Targets</option>
                            <option value="CHEATSHEET" ${targetType == 'CHEATSHEET' ? 'selected' : ''}>Cheatsheet</option>
                            <option value="COMMENT" ${targetType == 'COMMENT' ? 'selected' : ''}>Comment</option>
                            <option value="USER" ${targetType == 'USER' ? 'selected' : ''}>User</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button class="btn btn-brand-primary w-100" type="submit">
                            <i class="bi bi-filter me-1"></i> Apply
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-secondary">
                            Reset
                        </a>
                    </div>
                </form>
            </div>

            <%-- Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4" style="width: 60px;">No</th>
                                    <th>Reporter</th>
                                    <th>Reported User</th>
                                    <th>Target Type</th>
                                    <th>Target Content / Title</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Created At</th>
                                    <th class="text-end pe-4" style="width: 320px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty reports}">
                                        <tr>
                                            <td colspan="9" class="text-center text-muted py-5">
                                                <i class="bi bi-flag-fill display-4 d-block mb-3 text-secondary"></i>
                                                No content reports found.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach items="${reports}" var="r" varStatus="statusLoop">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">${((currentPage - 1) * 15) + statusLoop.index + 1}</td>
                                                <td>
                                                    <span class="fw-semibold text-dark">
                                                        <c:out value="${r.report.user != null ? r.report.user.username : 'Unknown'}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-danger-subtle text-danger px-2 py-1 rounded">
                                                        <c:out value="${r.reportedUsername}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge bg-secondary-subtle text-secondary px-2 py-1 rounded border">
                                                        ${r.report.targetType}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.targetUrl != '#'}">
                                                            <a href="${pageContext.request.contextPath}${r.targetUrl}" class="text-decoration-none text-brand-primary fw-medium text-truncate d-inline-block" style="max-width: 200px;" title="<c:out value="${r.targetTitle}"/>">
                                                                <c:out value="${r.targetTitle}" />
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted text-truncate d-inline-block" style="max-width: 200px;" title="<c:out value="${r.targetTitle}"/>">
                                                                <c:out value="${r.targetTitle}" />
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <span class="text-secondary small">
                                                        <c:out value="${r.report.reason}" />
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${r.report.status == 'Pending'}">
                                                            <span class="badge bg-warning-subtle text-warning"><i class="bi bi-clock-history me-1"></i>Pending</span>
                                                        </c:when>
                                                        <c:when test="${r.report.status == 'Reviewing'}">
                                                            <span class="badge bg-info-subtle text-info"><i class="bi bi-eye-fill me-1"></i>Reviewing</span>
                                                        </c:when>
                                                        <c:when test="${r.report.status == 'Resolved'}">
                                                            <span class="badge bg-success-subtle text-success"><i class="bi bi-check-circle-fill me-1"></i>Resolved</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger"><i class="bi bi-x-circle-fill me-1"></i>${r.report.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="small text-muted">${r.report.createdAt}</td>
                                                 <td class="text-end pe-4">
                                                     <div class="d-inline-flex gap-1">
                                                         <button type="button" class="btn btn-xs btn-outline-primary fw-semibold" style="font-size: 0.75rem; padding: 0.25rem 0.5rem;" data-bs-toggle="modal" data-bs-target="#detailModal_${r.report.id}">
                                                             View
                                                         </button>
                                                         
                                                         <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.report.id}/status/Reviewing">
                                                             <button class="btn btn-xs btn-outline-info fw-semibold" style="font-size: 0.75rem; padding: 0.25rem 0.5rem;">Review</button>
                                                         </form>
                                                         <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.report.id}/status/Resolved">
                                                             <button class="btn btn-xs btn-outline-success fw-semibold" style="font-size: 0.75rem; padding: 0.25rem 0.5rem;">Resolve</button>
                                                         </form>
                                                         <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.report.id}/status/Rejected">
                                                             <button class="btn btn-xs btn-outline-warning fw-semibold" style="font-size: 0.75rem; padding: 0.25rem 0.5rem;">Reject</button>
                                                         </form>
                                                         <form class="m-0" method="post" action="${pageContext.request.contextPath}/admin/reports/${r.report.id}/delete" onsubmit="return confirm('Delete this report?');">
                                                             <button class="btn btn-xs btn-outline-danger fw-semibold" style="font-size: 0.75rem; padding: 0.25rem 0.5rem;"><i class="bi bi-trash"></i></button>
                                                         </form>
                                                     </div>

                                                     <!-- Modal for Report Details -->
                                                     <div class="modal fade text-start" id="detailModal_${r.report.id}" tabindex="-1" aria-labelledby="detailModalLabel_${r.report.id}" aria-hidden="true">
                                                         <div class="modal-dialog modal-dialog-centered">
                                                             <div class="modal-content" style="border-radius: 16px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
                                                                 <div class="modal-header" style="border-bottom: 1px solid rgba(0,0,0,0.08); background: linear-gradient(135deg, rgba(255, 51, 102, 0.05), rgba(255, 94, 132, 0.05)); border-top-left-radius: 16px; border-top-right-radius: 16px;">
                                                                     <h5 class="modal-title fw-bold text-dark" id="detailModalLabel_${r.report.id}">
                                                                         <i class="bi bi-info-circle-fill text-primary me-2"></i> Report Details #${r.report.id}
                                                                     </h5>
                                                                     <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                 </div>
                                                                 <div class="modal-body p-4">
                                                                     <div class="card border-0 bg-light p-3 mb-3" style="border-radius: 12px;">
                                                                         <div class="row g-2">
                                                                             <div class="col-4 text-secondary small fw-bold">Reporter:</div>
                                                                             <div class="col-8 text-dark"><c:out value="${r.report.user != null ? r.report.user.username : 'Unknown'}" /></div>
                                                                             
                                                                             <div class="col-4 text-secondary small fw-bold">Reported:</div>
                                                                             <div class="col-8 text-dark"><c:out value="${r.reportedUsername}" /></div>
                                                                             
                                                                             <div class="col-4 text-secondary small fw-bold">Target Type:</div>
                                                                             <div class="col-8 text-dark">
                                                                                 <span class="badge bg-secondary-subtle text-secondary px-2 py-0.5 rounded border">${r.report.targetType}</span>
                                                                             </div>
                                                                             
                                                                             <div class="col-4 text-secondary small fw-bold">Target Content:</div>
                                                                             <div class="col-8 text-dark">
                                                                                 <c:choose>
                                                                                     <c:when test="${r.targetUrl != '#'}">
                                                                                         <a href="${pageContext.request.contextPath}${r.targetUrl}" class="text-decoration-none text-brand-primary fw-medium" target="_blank">
                                                                                             <c:out value="${r.targetTitle}" /> <i class="bi bi-box-arrow-up-right small"></i>
                                                                                         </a>
                                                                                     </c:when>
                                                                                     <c:otherwise>
                                                                                         <span class="text-muted"><c:out value="${r.targetTitle}" /></span>
                                                                                     </c:otherwise>
                                                                                 </c:choose>
                                                                             </div>
                                                                         </div>
                                                                     </div>
                                                                     
                                                                     <div class="mb-3">
                                                                         <label class="form-label text-secondary small fw-bold mb-1">Reason for Reporting</label>
                                                                         <div class="p-3 border rounded text-danger bg-danger-subtle fw-semibold" style="border-radius: 8px;">
                                                                             <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${r.report.reason}" />
                                                                         </div>
                                                                     </div>
                                                                     
                                                                     <div class="mb-0">
                                                                         <label class="form-label text-secondary small fw-bold mb-1">Additional Details / Description</label>
                                                                         <div class="p-3 border rounded text-dark bg-white" style="border-radius: 8px; min-height: 80px; white-space: pre-wrap;"><c:out value="${empty r.report.description ? 'No additional description provided.' : r.report.description}" /></div>
                                                                     </div>
                                                                 </div>
                                                                 <div class="modal-footer" style="border-top: 1px solid rgba(0,0,0,0.08);">
                                                                     <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal" style="border-radius: 8px;">Close</button>
                                                                 </div>
                                                             </div>
                                                         </div>
                                                     </div>
                                                 </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- Pagination --%>
            <nav class="mt-4">
                <ul class="pagination justify-content-end">
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <li class="page-item ${p == currentPage ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/reports?page=${p}&q=${keyword}&status=${status}&targetType=${targetType}">${p}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
