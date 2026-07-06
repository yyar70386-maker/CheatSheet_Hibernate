<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CheatSheet Management - Admin</title>
    
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
            <jsp:param name="activePage" value="cheatsheets" />
        </jsp:include>

        <%-- 📂 Main Content Area --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">CheatSheet Management</h2>
                    <p class="text-muted m-0 small">Review, approve, reject, ban, or delete user-submitted CheatSheets.</p>
                </div>
                <div class="d-flex flex-wrap gap-2">
                    <a class="btn btn-brand-primary" href="${pageContext.request.contextPath}/cheatsheet/add">
                        <i class="bi bi-plus-circle me-1"></i> Create CheatSheet
                    </a>
                </div>
            </div>

            <%-- Alert Messages --%>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- 🔍 Filter & Search Bar --%>
            <div class="card border-0 shadow-sm rounded-3 mb-4">
                <div class="card-body">
                    <form method="get" action="${pageContext.request.contextPath}/admin/cheatsheets" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary">Search</label>
                            <input type="text" name="q" value="${keyword}" class="form-control" placeholder="Search title, description...">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold text-secondary">Category</label>
                            <select name="categoryId" class="form-select">
                                <option value="">All Categories</option>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.id}" ${categoryId == c.id.toString() ? 'selected' : ''}>${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold text-secondary">Status</label>
                            <select name="status" class="form-select">
                                <option value="">All Statuses</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="banned" ${status == 'banned' ? 'selected' : ''}>Banned</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-brand-primary w-100">Apply Filters</button>
                        </div>
                    </form>
                </div>
            </div>

            <%-- 📊 Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4">S.No</th>
                                    <th>CheatSheet Details</th>
                                    <th>Author</th>
                                    <th>State & Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty cheatsheets}">
                                        <c:forEach var="s" items="${cheatsheets}" varStatus="statusLoop">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">${((currentPage - 1) * 10) + statusLoop.index + 1}</td>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <c:choose>
                                                            <c:when test="${not empty s.imagePath}">
                                                                <img src="${pageContext.request.contextPath}${s.imagePath}" class="rounded shadow-sm border" style="width: 50px; height: 50px; object-fit: cover;" alt="Cover" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="rounded bg-light d-flex align-items-center justify-content-center text-muted border shadow-sm" style="width: 50px; height: 50px;">
                                                                    <i class="bi bi-image fs-4"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div>
                                                            <div class="fw-semibold text-dark">
                                                                <a href="${pageContext.request.contextPath}/cheatsheet/detail/${s.obfuscatedId}" class="text-decoration-none text-dark hover-brand">
                                                                    <c:out value="${s.title}" />
                                                                </a>
                                                            </div>
                                                            <div class="text-muted small">Category: <span class="badge bg-secondary-subtle text-secondary">${s.category.name}</span></div>
                                                            <div class="text-muted small">Visibility: <span class="fw-medium">${s.visibility}</span></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="fw-medium text-dark">${s.author.username}</div>
                                                    <div class="text-muted small">${s.author.email}</div>
                                                </td>
                                                <td>
                                                    <div class="mb-1">
                                                        <c:choose>
                                                            <c:when test="${s.banned}">
                                                                <span class="badge bg-danger text-white px-2 py-1 rounded small"><i class="bi bi-x-circle me-1"></i>BANNED</span>
                                                            </c:when>
                                                            <c:when test="${s.status == 'active'}">
                                                                <span class="badge bg-success text-white px-2 py-1 rounded small"><i class="bi bi-check-circle me-1"></i>ACTIVE</span>
                                                            </c:when>
                                                            <c:when test="${s.status == 'pending'}">
                                                                <span class="badge bg-warning text-dark px-2 py-1 rounded small"><i class="bi bi-clock me-1"></i>PENDING</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary text-white px-2 py-1 rounded small">${s.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${s.banned}">
                                                        <div class="text-danger small" style="max-width: 200px;" title="Reason: ${s.bannedReason}">
                                                            <strong>Reason:</strong> <c:out value="${s.bannedReason}" />
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        
                                                        <%-- Approve / Reject Actions for Pending --%>
                                                        <c:if test="${s.status == 'pending' && (s.author == null || s.author.role == 1)}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/cheatsheets/${s.id}/approve" class="d-inline">
                                                                <button type="submit" class="btn btn-sm btn-success rounded-2 px-2.5 py-1">Approve</button>
                                                            </form>
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/cheatsheets/${s.id}/reject" class="d-inline">
                                                                <button type="submit" class="btn btn-sm btn-outline-warning rounded-2 px-2.5 py-1">Reject</button>
                                                            </form>
                                                        </c:if>
                                                        
                                                         <c:choose>
                                                             <%-- Case 1: Own post - Edit & Delete --%>
                                                             <c:when test="${s.author != null && s.author.id == sessionScope.currentUser.id}">
                                                                 <a href="${pageContext.request.contextPath}/cheatsheet/edit/${s.obfuscatedId}" class="btn btn-sm btn-outline-primary rounded-2 px-3 py-1">
                                                                     <i class="bi bi-pencil-square"></i> Edit
                                                                 </a>
                                                                 <form method="post" action="${pageContext.request.contextPath}/admin/cheatsheets/${s.id}/delete" class="d-inline" onsubmit="return confirm('Delete CheatSheet permanently?');">
                                                                     <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-3 py-1">
                                                                         <i class="bi bi-trash3-fill"></i> Delete
                                                                     </button>
                                                                 </form>
                                                             </c:when>
                                                             
                                                             <%-- Case 2: Other user's post - Ban / Restore only --%>
                                                             <c:otherwise>
                                                                 <c:choose>
                                                                     <c:when test="${s.banned}">
                                                                         <form method="post" action="${pageContext.request.contextPath}/admin/cheatsheets/${s.id}/restore" class="d-inline">
                                                                             <button type="submit" class="btn btn-sm btn-info text-white rounded-2 px-3 py-1">
                                                                                 <i class="bi bi-arrow-counterclockwise"></i> Restore
                                                                             </button>
                                                                         </form>
                                                                     </c:when>
                                                                     <c:otherwise>
                                                                         <button type="button" class="btn btn-sm btn-warning rounded-2 px-3 py-1" onclick="openBanModal(${s.id}, '${s.title}')">
                                                                             <i class="bi bi-slash-circle me-1"></i> Ban
                                                                         </button>
                                                                     </c:otherwise>
                                                                 </c:choose>
                                                             </c:otherwise>
                                                         </c:choose>
                                                        
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="bi bi-file-earmark-code display-4 d-block mb-3 text-secondary"></i>
                                                No CheatSheets found.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <%-- 📄 Pagination --%>
            <c:if test="${totalPages > 1}">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/cheatsheets?q=${keyword}&categoryId=${categoryId}&status=${status}&banned=${banned}&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/cheatsheets?q=${keyword}&categoryId=${categoryId}&status=${status}&banned=${banned}&page=${p}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/cheatsheets?q=${keyword}&categoryId=${categoryId}&status=${status}&banned=${banned}&page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <%-- 🛑 Ban Modal --%>
    <div class="modal fade" id="banModal" tabindex="-1" aria-labelledby="banModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form id="banForm" method="post" action="">
                <div class="modal-content border-0 shadow-lg">
                    <div class="modal-header bg-warning text-dark border-0">
                        <h5 class="modal-title fw-bold" id="banModalLabel">Ban CheatSheet</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p class="mb-2 fw-semibold">Please select a reason for banning:</p>
                        
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="banReasonSpam" value="Spam" required>
                            <label class="form-check-label" for="banReasonSpam">Spam / Misleading</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="banReasonPlagiarism" value="Plagiarism / Copyright">
                            <label class="form-check-label" for="banReasonPlagiarism">Plagiarism / Copyright Violation</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="banReasonInappropriate" value="Inappropriate Content">
                            <label class="form-check-label" for="banReasonInappropriate">Inappropriate Content</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="banReasonQuality" value="Low Quality / Not Useful">
                            <label class="form-check-label" for="banReasonQuality">Low Quality / Not Useful</label>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="radio" name="reason" id="banReasonOther" value="Other">
                            <label class="form-check-label" for="banReasonOther">Other</label>
                        </div>
                        
                        <div class="mb-3">
                            <label for="banDescription" class="form-label fw-semibold text-secondary">Additional Details (Optional)</label>
                            <textarea name="description" id="banDescription" class="form-control" rows="2" placeholder="Enter additional details..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger px-4">Confirm Ban</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openBanModal(cheatsheetId, title) {
            const form = document.getElementById('banForm');
            form.action = '${pageContext.request.contextPath}/admin/cheatsheets/' + cheatsheetId + '/ban';
            document.getElementById('banModalLabel').innerText = 'Ban CheatSheet: ' + title;
            
            const modal = new bootstrap.Modal(document.getElementById('banModal'));
            modal.show();
        }
    </script>
</body>
</html>
