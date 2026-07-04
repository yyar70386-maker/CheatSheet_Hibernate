<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comment Management - Admin</title>
    
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
            <jsp:param name="activePage" value="comments" />
        </jsp:include>

        <%-- 📂 Main Content Area --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Comment Management</h2>
                    <p class="text-muted m-0 small">Moderate, ban, restore, or delete comments and replies across CheatSheets.</p>
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
                    <form method="get" action="${pageContext.request.contextPath}/admin/comments" class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold text-secondary">Search</label>
                            <input type="text" name="q" value="${keyword}" class="form-control" placeholder="Search comments by content or username...">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary">Status</label>
                            <select name="status" class="form-select">
                                <option value="">All Comments</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active Comments</option>
                                <option value="banned" ${status == 'banned' ? 'selected' : ''}>Banned Comments</option>
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
                                    <th class="ps-4">ID</th>
                                    <th>Comment Content</th>
                                    <th>Source CheatSheet</th>
                                    <th>Author</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty comments}">
                                        <c:forEach var="c" items="${comments}">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">#${c.id}</td>
                                                <td style="max-width: 300px;">
                                                    <div class="text-dark fw-medium text-truncate-2" style="white-space: normal; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                                        <c:out value="${c.content}" />
                                                    </div>
                                                    <c:if test="${c.parentComment != null}">
                                                        <div class="text-muted small mt-1"><i class="bi bi-arrow-return-right me-1"></i>Reply to #${c.parentComment.id}</div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="fw-semibold text-truncate" style="max-width: 180px;">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${c.cheatSheet.id}" class="text-decoration-none text-dark hover-brand">
                                                            <c:out value="${c.cheatSheet.title}" />
                                                        </a>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="fw-medium text-dark">${c.user.username}</div>
                                                    <div class="text-muted small">${c.user.email}</div>
                                                </td>
                                                <td>
                                                    <div class="mb-1">
                                                        <c:choose>
                                                            <c:when test="${c.banned}">
                                                                <span class="badge bg-danger text-white px-2 py-1 rounded small"><i class="bi bi-x-circle me-1"></i>BANNED</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success text-white px-2 py-1 rounded small"><i class="bi bi-check-circle me-1"></i>ACTIVE</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:if test="${c.banned}">
                                                        <div class="text-danger small" style="max-width: 180px;" title="Reason: ${c.bannedReason}">
                                                            <strong>Reason:</strong> <c:out value="${c.bannedReason}" />
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        
                                                        <%-- Ban / Restore Actions --%>
                                                        <c:choose>
                                                            <c:when test="${c.banned}">
                                                                <form method="post" action="${pageContext.request.contextPath}/admin/comments/${c.id}/restore" class="d-inline">
                                                                    <button type="submit" class="btn btn-sm btn-info text-white rounded-2 px-3 py-1">
                                                                        <i class="bi bi-arrow-counterclockwise"></i> Restore
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-warning rounded-2 px-3 py-1" onclick="openBanModal(${c.id})">
                                                                    <i class="bi bi-slash-circle me-1"></i> Ban
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <%-- Delete Action --%>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/comments/${c.id}/delete" class="d-inline" onsubmit="return confirm('Delete comment permanently?');">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-3 py-1">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>
                                                        
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">
                                                <i class="bi bi-chat-left display-4 d-block mb-3 text-secondary"></i>
                                                No comments found.
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
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/comments?q=${keyword}&status=${status}&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/comments?q=${keyword}&status=${status}&page=${p}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/comments?q=${keyword}&status=${status}&page=${currentPage + 1}">Next</a>
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
                        <h5 class="modal-title fw-bold" id="banModalLabel">Ban Comment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="banReason" class="form-label fw-semibold text-secondary">Reason for Banning</label>
                            <textarea name="reason" id="banReason" class="form-control" rows="3" required placeholder="Enter why this comment violates system guidelines..."></textarea>
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
        function openBanModal(commentId) {
            const form = document.getElementById('banForm');
            form.action = '${pageContext.request.contextPath}/admin/comments/' + commentId + '/ban';
            
            const modal = new bootstrap.Modal(document.getElementById('banModal'));
            modal.show();
        }
    </script>
</body>
</html>
