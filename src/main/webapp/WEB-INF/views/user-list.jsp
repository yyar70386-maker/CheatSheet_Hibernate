<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - CheatSheet Project</title>
    
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
            <jsp:param name="activePage" value="users" />
        </jsp:include>

        <%-- 📂 Main Content Area --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">User Management</h2>
                    <p class="text-muted m-0 small">Manage registered system users, unlock accounts, update roles, and suspend users.</p>
                </div>
            </div>

            <%-- Action Alert Messages --%>
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
                    <form method="get" action="${pageContext.request.contextPath}/admin/users" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold text-secondary">Search</label>
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                                <input type="text" name="q" value="${keyword}" class="form-control" placeholder="Search by name, email, username...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold text-secondary">Role Filter</label>
                            <select name="role" class="form-select">
                                <option value="">All Roles</option>
                                <option value="0" ${role == '0' ? 'selected' : ''}>User</option>
                                <option value="1" ${role == '1' ? 'selected' : ''}>Admin</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold text-secondary">Status Filter</label>
                            <select name="status" class="form-select">
                                <option value="">All Statuses</option>
                                <option value="active" ${status == 'active' ? 'selected' : ''}>Active Only</option>
                                <option value="suspended" ${status == 'suspended' ? 'selected' : ''}>Suspended</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-brand-primary w-100">Apply Filters</button>
                        </div>
                    </form>
                </div>
            </div>

            <%-- 📊 Registered Users Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4">S.No</th>
                                    <th>User Info</th>
                                    <th>Role & Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="u" items="${users}" varStatus="statusLoop">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">${((currentPage - 1) * 10) + statusLoop.index + 1}</td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${u.username}</div>
                                                    <div class="text-muted small">${u.email}</div>
                                                    <c:if test="${not empty u.fullName}">
                                                        <div class="text-muted small fw-medium">${u.fullName}</div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="mb-1">
                                                        <c:choose>
                                                            <c:when test="${u.role == 1}">
                                                                <span class="badge bg-danger-subtle text-danger px-2.5 py-1.5 rounded-pill small">ADMIN</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-primary-subtle text-primary px-2.5 py-1.5 rounded-pill small">USER</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${u.suspended}">
                                                                <c:choose>
                                                                    <c:when test="${u.accountLocked}">
                                                                        <span class="badge bg-danger text-white px-2 py-1 rounded small"><i class="bi bi-lock me-1"></i>LOCKED</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-warning text-dark px-2 py-1 rounded small"><i class="bi bi-pause-circle me-1"></i>SUSPENDED</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success text-white px-2 py-1 rounded small"><i class="bi bi-check-circle me-1"></i>ACTIVE</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="d-flex gap-2 align-items-center">
                                                        
                                                        <%-- Inline Role Change --%>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.id}/role" class="d-inline-flex align-items-center">
                                                            <select name="role" class="form-select form-select-sm" style="width: auto;">
                                                                <option value="0" ${u.role == 0 ? 'selected' : ''}>User</option>
                                                                <option value="1" ${u.role == 1 ? 'selected' : ''}>Admin</option>
                                                            </select>
                                                            <button type="submit" class="btn btn-sm btn-outline-secondary ms-1 py-1" title="Update Role"><i class="bi bi-check-lg"></i></button>
                                                        </form>
                                                        
                                                        <%-- Suspend / Unsuspend --%>
                                                        <c:choose>
                                                            <c:when test="${u.suspended}">
                                                                <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.id}/unsuspend" class="d-inline">
                                                                    <button type="submit" class="btn btn-sm btn-success rounded-2 px-3 py-1">
                                                                        <i class="bi bi-play me-1"></i> Unsuspend
                                                                    </button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-sm btn-warning rounded-2 px-3 py-1" onclick="openSuspendModal(${u.id}, '${u.username}')">
                                                                    <i class="bi bi-pause me-1"></i> Suspend
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <%-- Unlock Account (if locked) --%>
                                                        <c:if test="${u.accountLocked}">
                                                            <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.id}/unlock" class="d-inline">
                                                                <button type="submit" class="btn btn-sm btn-info text-white rounded-2 px-3 py-1">
                                                                    <i class="bi bi-unlock me-1"></i> Unlock
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        
                                                        <%-- Delete Button --%>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/users/${u.id}/delete" class="d-inline" onsubmit="return confirm('Delete user \'${u.username}\' permanently?');">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger rounded-2 px-3 py-1">
                                                                <i class="bi bi-trash3-fill me-1"></i> Delete
                                                            </button>
                                                        </form>
                                                        
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="bi bi-people display-4 d-block mb-3 text-secondary"></i>
                                                No users found.
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
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?q=${keyword}&role=${role}&status=${status}&page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="p">
                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/users?q=${keyword}&role=${role}&status=${status}&page=${p}">${p}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/users?q=${keyword}&role=${role}&status=${status}&page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <!-- Suspend User Modal -->
    <div class="modal fade" id="suspendUserModal" tabindex="-1" aria-labelledby="suspendUserModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="suspendUserForm" method="post" action="">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger" id="suspendUserModalLabel">Suspend User</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p class="mb-3 text-muted small">Are you sure you want to suspend <strong id="suspendUserName" class="text-dark"></strong>?</p>
                        <p class="mb-2 fw-semibold">Please select a reason:</p>
                        
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="suspendReasonSpam" value="Spam" required>
                            <label class="form-check-label" for="suspendReasonSpam">Spam</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="suspendReasonInappropriate" value="Inappropriate Content">
                            <label class="form-check-label" for="suspendReasonInappropriate">Inappropriate Content</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="suspendReasonHarassment" value="Harassment">
                            <label class="form-check-label" for="suspendReasonHarassment">Harassment</label>
                        </div>
                        <div class="form-check mb-2">
                            <input class="form-check-input" type="radio" name="reason" id="suspendReasonViolation" value="Violation of Terms">
                            <label class="form-check-label" for="suspendReasonViolation">Violation of Terms</label>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="radio" name="reason" id="suspendReasonOther" value="Other">
                            <label class="form-check-label" for="suspendReasonOther">Other</label>
                        </div>

                        <div class="mb-3">
                            <label for="suspendDescription" class="form-label fw-semibold text-secondary">Additional Details (Optional)</label>
                            <textarea name="description" id="suspendDescription" class="form-control" rows="2" placeholder="Enter additional details..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Suspend User</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openSuspendModal(userId, username) {
            document.getElementById('suspendUserName').innerText = username;
            document.getElementById('suspendUserForm').action = '${pageContext.request.contextPath}/admin/users/' + userId + '/suspend';
            var suspendModal = new bootstrap.Modal(document.getElementById('suspendUserModal'));
            suspendModal.show();
        }
    </script>
</body>
</html>
