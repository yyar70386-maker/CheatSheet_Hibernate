
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modern Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { 
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        /* Sidebar Styling */
        .sidebar {
            width: 260px;
            background: #ffffff;
            border-right: 1px solid #eaeaea;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            padding-top: 20px;
            z-index: 1000;
        }
        .sidebar .brand {
            font-weight: 800;
            font-size: 1.2rem;
            color: #333;
            padding: 0 20px 20px 20px;
            border-bottom: 1px solid #eaeaea;
            margin-bottom: 20px;
        }
        .sidebar .nav-link {
            color: #555;
            font-weight: 500;
            padding: 10px 20px;
            margin: 4px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: #f4f6f8;
            color: #0d6efd;
            font-weight: 600;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
        }
        /* Main Content Styling */
        .main-content {
            margin-left: 260px;
            padding: 30px 40px;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #eaeaea;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            transition: transform 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-3px);
        }
        .content-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #eaeaea;
            padding: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }
        .table > :not(caption) > * > * {
            padding: 1rem 0.5rem;
            border-bottom-color: #eaeaea;
        }
    </style>
</head>
<body>

<div class="sidebar d-flex flex-column">
    <div class="brand">
        <i class="bi bi-layers-fill text-primary"></i> Admin Panel
    </div>
    <div class="nav flex-column nav-pills" id="adminTabs" role="tablist" aria-orientation="vertical">
        <button class="nav-link active text-start" id="overview-tab" data-bs-toggle="pill" data-bs-target="#overview" type="button" role="tab">
            <i class="bi bi-grid-1x2"></i> Dashboard
        </button>
        <button class="nav-link text-start" id="users-tab" data-bs-toggle="pill" data-bs-target="#users" type="button" role="tab">
            <i class="bi bi-people"></i> Manage Users
        </button>
        <button class="nav-link text-start" id="cheatsheets-tab" data-bs-toggle="pill" data-bs-target="#cheatsheets" type="button" role="tab">
            <i class="bi bi-file-earmark-text"></i> Manage Cheatsheets
        </button>
        <button class="nav-link text-start" id="comments-tab" data-bs-toggle="pill" data-bs-target="#comments" type="button" role="tab">
            <i class="bi bi-chat-left-text"></i> Manage Comments
        </button>
        <a class="nav-link text-start" href="${pageContext.request.contextPath}/admin/reports">
            <i class="bi bi-flag"></i> Reports <span class="badge bg-danger float-end">${summary.pendingReports != null ? summary.pendingReports : '0'}</span>
        </a>
        <a class="nav-link text-start" href="${pageContext.request.contextPath}/admin/audit-logs">
            <i class="bi bi-journal-text"></i> Audit Logs
        </a>
        
        <div class="mt-auto p-3">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary w-100"><i class="bi bi-house-door"></i> Back to Home</a>
        </div>
    </div>
</div>

<div class="main-content">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <div>
            <h3 class="fw-bold m-0" id="pageTitle">Dashboard Overview</h3>
            <div class="text-muted small">Operational overview and moderation queue</div>
        </div>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/admin/notifications" class="btn btn-outline-dark btn-sm rounded-pill px-3">
                <i class="bi bi-bell me-1"></i> Send Notification
            </a>
            <a href="${pageContext.request.contextPath}/admin/announcements/add" class="btn btn-dark btn-sm rounded-pill px-3">
                <i class="bi bi-megaphone-fill me-1"></i> New Announcement
            </a>
        </div>
    </div>

    <div class="tab-content" id="adminTabsContent">
        
        <%-- TAB 1: OVERVIEW --%>
        <div class="tab-pane fade show active" id="overview" role="tabpanel">
            
            <%-- 🌟 Merged Stat Cards (Combining both branches' data) --%>
            <div class="row g-3 mb-5">
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Users</div><div class="fs-4 fw-bold">${summary.totalUsers != null ? summary.totalUsers : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Active Users</div><div class="fs-4 fw-bold text-success">${summary.activeUsers != null ? summary.activeUsers : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Cheatsheets</div><div class="fs-4 fw-bold">${summary.totalCheatsheets != null ? summary.totalCheatsheets : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Categories</div><div class="fs-4 fw-bold">${summary.totalCategories != null ? summary.totalCategories : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Tags</div><div class="fs-4 fw-bold">${summary.totalTags != null ? summary.totalTags : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Comments</div><div class="fs-4 fw-bold">${summary.totalComments != null ? summary.totalComments : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Reports</div><div class="fs-4 fw-bold">${summary.totalReports != null ? summary.totalReports : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Pending Reports</div><div class="fs-4 fw-bold text-danger">${summary.pendingReports != null ? summary.pendingReports : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Announcements</div><div class="fs-4 fw-bold">${summary.totalAnnouncements != null ? summary.totalAnnouncements : '0'}</div></div></div>
                <div class="col-md-3 col-xl-2"><div class="stat-card p-3"><div class="text-muted small fw-bold text-uppercase">Notifications</div><div class="fs-4 fw-bold">${summary.totalNotifications != null ? summary.totalNotifications : '0'}</div></div></div>
            </div>

            <div class="row g-4">
                <div class="col-lg-7">
                    <div class="content-card mb-4">
                        <h5 class="fw-bold mb-4">Recent Activities</h5>
                        <div class="list-group list-group-flush">
                            <c:forEach items="${summary.recentActivities}" var="a">
                                <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center px-0 py-3 border-bottom" href="${pageContext.request.contextPath}/admin/audit-logs/${a.id}">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light rounded-circle p-2 me-3"><i class="bi bi-activity text-primary"></i></div>
                                        <div>
                                            <div class="fw-semibold text-dark"><c:out value="${a.action}" /></div>
                                            <div class="text-muted small"><c:out value="${a.entityName}" /> #${a.entityId}</div>
                                        </div>
                                    </div>
                                    <div class="text-muted small">${a.createdAt}</div>
                                </a>
                            </c:forEach>
                            <c:if test="${empty summary.recentActivities}">
                                <div class="text-muted text-center py-4">No recent activities found.</div>
                            </c:if>
                        </div>
                    </div>
                    <div class="content-card">
                        <h5 class="fw-bold mb-3">Latest Reports</h5>
                        <c:forEach items="${summary.latestReports}" var="r">
                            <div class="d-flex justify-content-between border-bottom py-2">
                                <div><span class="badge text-bg-light border">${r.targetType}</span> <c:out value="${r.reason}" /></div>
                                <a href="${pageContext.request.contextPath}/admin/reports/${r.id}" class="small text-decoration-none">View <i class="bi bi-arrow-right"></i></a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty summary.latestReports}">
                            <div class="text-muted text-center py-3 small">No reports found.</div>
                        </c:if>
                    </div>
                </div>

                <%-- 🌟 Merged Sidebar Widgets from friend's code --%>
                <div class="col-lg-5">
                    <div class="content-card mb-4">
                        <h5 class="fw-bold mb-3">Latest Users</h5>
                        <c:forEach items="${summary.latestUsers}" var="u">
                            <div class="d-flex justify-content-between align-items-center border-bottom py-2">
                                <div>
                                    <i class="bi bi-person-circle text-secondary me-1"></i>
                                    <span class="fw-semibold"><c:out value="${u.username}" /></span>
                                </div>
                                <span class="badge ${u.role == 1 ? 'bg-primary' : 'bg-secondary'} small">${u.role == 1 ? 'Admin' : 'User'}</span>
                            </div>
                        </c:forEach>
                        <c:if test="${empty summary.latestUsers}">
                            <div class="text-muted text-center py-3 small">No users found.</div>
                        </c:if>
                    </div>
                    <div class="content-card">
                        <h5 class="fw-bold mb-3">Latest Cheatsheets</h5>
                        <c:forEach items="${summary.latestCheatsheets}" var="s">
                            <div class="border-bottom py-2">
                                <a class="text-decoration-none fw-semibold text-dark d-block text-truncate" href="${pageContext.request.contextPath}/cheatsheet/detail/${s.id}">
                                    <i class="bi bi-file-earmark-text text-primary me-1"></i> <c:out value="${s.title}" />
                                </a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty summary.latestCheatsheets}">
                            <div class="text-muted text-center py-3 small">No cheatsheets found.</div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <%-- TAB 2: MANAGE USERS --%>
        <div class="tab-pane fade" id="users" role="tabpanel">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">User Management</h5>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary btn-sm">Full User Directory <i class="bi bi-arrow-right"></i></a>
                </div>
                <p class="text-muted">Manage system users, change roles, and handle user status.</p>
                <%-- You can implement the full user table here later --%>
            </div>
        </div>

        <%-- TAB 3: MANAGE CHEATSHEETS --%>
        <div class="tab-pane fade" id="cheatsheets" role="tabpanel">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">Cheatsheet Repository</h5>
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="d-flex align-items-center">
                        <select name="sheetFilter" class="form-select form-select-sm shadow-none border-secondary" onchange="this.form.submit()">
                            <option value="newest" ${currentSheetFilter == 'newest' ? 'selected' : ''}>Newest First</option>
                            <option value="mostLikes" ${currentSheetFilter == 'mostLikes' ? 'selected' : ''}>Most Likes</option>
                            <option value="mostDislikes" ${currentSheetFilter == 'mostDislikes' ? 'selected' : ''}>Most Dislikes</option>
                        </select>
                        <input type="hidden" name="commentFilter" value="${currentCommentFilter}">
                    </form>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="text-muted small text-uppercase">
                            <tr>
                                <th>Sheet Info</th>
                                <th>Author</th>
                                <th class="text-center"><i class="bi bi-hand-thumbs-up-fill text-primary"></i></th>
                                <th class="text-center"><i class="bi bi-hand-thumbs-down-fill text-danger"></i></th>
                                <th class="text-center">Status</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${cheatsheets}" var="sheet">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-dark"><a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-decoration-none text-dark" target="_blank">${sheet.title}</a></div>
                                        <div class="text-muted small">ID: #${sheet.id}</div>
                                    </td>
                                    <td>
                                        <div class="fw-semibold">${sheet.author != null ? sheet.author.username : 'Unknown'}</div>
                                    </td>
                                    <td class="text-center fw-bold">${sheet.likeCount}</td>
                                    <td class="text-center fw-bold">${sheet.dislikeCount}</td>
                                    <td class="text-center">
                                        <span class="badge rounded-pill ${sheet.status == 'active' ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'} border-0 px-3 py-2">${sheet.status}</span>
                                    </td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-sm btn-light text-dark shadow-sm me-1" onclick="openActionModal('sheet', ${sheet.id}, 'hide')" title="Hide">
                                            <i class="bi bi-eye-slash"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-danger shadow-sm" onclick="openActionModal('sheet', ${sheet.id}, 'ban')" title="Ban">
                                            <i class="bi bi-slash-circle"></i> Ban
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- TAB 4: MANAGE COMMENTS --%>
        <div class="tab-pane fade" id="comments" role="tabpanel">
            <div class="content-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">User Comments</h5>
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="get" class="d-flex align-items-center">
                        <select name="commentFilter" class="form-select form-select-sm shadow-none border-secondary" onchange="this.form.submit()">
                            <option value="newest" ${currentCommentFilter == 'newest' ? 'selected' : ''}>Newest First</option>
                            <option value="mostLikes" ${currentCommentFilter == 'mostLikes' ? 'selected' : ''}>Most Likes</option>
                            <option value="mostDislikes" ${currentCommentFilter == 'mostDislikes' ? 'selected' : ''}>Most Dislikes</option>
                        </select>
                        <input type="hidden" name="sheetFilter" value="${currentSheetFilter}">
                    </form>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="text-muted small text-uppercase">
                            <tr>
                                <th>Content</th>
                                <th>User</th>
                                <th>Sheet</th>
                                <th class="text-center"><i class="bi bi-hand-thumbs-up-fill text-primary"></i></th>
                                <th class="text-center"><i class="bi bi-hand-thumbs-down-fill text-danger"></i></th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${comments}" var="cmt">
                                <tr>
                                    <td style="max-width: 300px;">
                                        <div class="text-truncate" title="${cmt.content}">${cmt.content}</div>
                                        <div class="text-muted small">ID: #${cmt.id}</div>
                                    </td>
                                    <td class="fw-semibold">${cmt.user.username}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${cmt.cheatSheet.id}" class="text-decoration-none small fw-bold" target="_blank">View <i class="bi bi-box-arrow-up-right"></i></a>
                                    </td>
                                    <td class="text-center fw-bold">${cmt.likeCount}</td>
                                    <td class="text-center fw-bold">${cmt.dislikeCount}</td>
                                    <td class="text-end">
                                        <button type="button" class="btn btn-sm btn-outline-danger shadow-sm" onclick="openActionModal('comment',${cmt.id}, 'delete')">
                                            <i class="bi bi-trash"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<%-- 🌟 ACTION MODAL (Reason တောင်းရန်) --%>
<div class="modal fade" id="actionModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
            <form id="actionForm" method="post" action="">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold" id="modalTitle">Confirm Action</h5>
                    <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="sheetId" id="sheetIdInput" disabled>
                    <input type="hidden" name="commentId" id="commentIdInput" disabled>
                    <input type="hidden" name="action" id="actionInput">
                    
                    <div class="alert alert-warning border-0 rounded-3 small">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i> This action will notify the user. Please provide a clear reason.
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small">Reason Details:</label>
                        <textarea name="reason" class="form-control shadow-none" rows="3" placeholder="e.g., Spam, Inappropriate content, Violation of terms..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-dark px-4">Confirm Action</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 🌟 Update Page Title based on active tab
    const pageTitles = {
        'overview-tab': 'Dashboard Overview',
        'users-tab': 'User Management',
        'cheatsheets-tab': 'Cheatsheet Repository',
        'comments-tab': 'User Comments'
    };

    // 🌟 Tab Memory & Title Update Script
    document.addEventListener("DOMContentLoaded", function(){
        var activeTabId = localStorage.getItem('activeAdminTab');
        if(activeTabId){ 
            var tabEl = document.querySelector('#' + activeTabId);
            if(tabEl) {
                var tab = new bootstrap.Tab(tabEl); 
                tab.show(); 
                document.getElementById('pageTitle').innerText = pageTitles[activeTabId];
            }
        }
        
        document.querySelectorAll('button[data-bs-toggle="pill"]').forEach(function(btn){
            btn.addEventListener('shown.bs.tab', function(e){ 
                localStorage.setItem('activeAdminTab', e.target.id); 
                document.getElementById('pageTitle').innerText = pageTitles[e.target.id];
            });
        });
    });

    // 🌟 Modal ဖွင့်ပေးမည့် Script
    function openActionModal(type, id, action) {
        const form = document.getElementById('actionForm');
        const sInput = document.getElementById('sheetIdInput');
        const cInput = document.getElementById('commentIdInput');
        const aInput = document.getElementById('actionInput');
        const title = document.getElementById('modalTitle');
        
        aInput.value = action;
        if (type === 'sheet') {
            form.action = '${pageContext.request.contextPath}/admin/cheatsheet/action';
            sInput.value = id; sInput.disabled = false;
            cInput.disabled = true;
            title.innerText = (action === 'hide' ? 'Hide' : 'Ban') + ' Cheatsheet #' + id;
        } else if (type === 'comment') {
            form.action = '${pageContext.request.contextPath}/admin/comment/action';
            cInput.value = id; cInput.disabled = false;
            sInput.disabled = true;
            title.innerText = 'Delete Comment #' + id;
        }
        
        new bootstrap.Modal(document.getElementById('actionModal')).show();
    }
</script>
</body>
</html>