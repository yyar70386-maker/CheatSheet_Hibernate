<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Announcements</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />

<div class="app-container">
    <c:if test="${sessionScope.currentUser.role == 1}">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="announcements" />
        </jsp:include>
    </c:if>

    <div class="${sessionScope.currentUser.role == 1 ? 'main-content-area' : 'container py-4'}" style="${sessionScope.currentUser.role != 1 ? 'max-width: 980px;' : ''}">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Announcements</h3>
            <div class="text-muted small">Platform-wide updates and admin notices</div>
        </div>
        <c:if test="${sessionScope.currentUser.role == 1}">
            <a href="${pageContext.request.contextPath}/admin/announcements/add" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i> New Announcement
            </a>
        </c:if>
    </div>

    <div id="announcements-empty" class="text-center bg-white border rounded-3 py-5" style="display: none;">
        <i class="bi bi-megaphone display-5 text-muted d-block mb-2"></i>
        <div class="fw-semibold">No announcements yet</div>
    </div>

    <c:choose>
        <c:when test="${empty announcements}">
            <div class="text-center bg-white border rounded-3 py-5">
                <i class="bi bi-megaphone display-5 text-muted d-block mb-2"></i>
                <div class="fw-semibold">No announcements yet</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-grid gap-3" id="announcements-container">
                <c:forEach items="${announcements}" var="a">
                    <div id="announcement-card-${a.id}" class="announcement-card border rounded-3 p-4 shadow-sm ${readStatusMap[a.id] == false ? 'bg-primary bg-opacity-10 border-primary' : 'bg-white'}">
                        <div class="d-flex justify-content-between align-items-start gap-3">
                            <div>
                                <h5 class="fw-bold mb-2">
                                    <c:out value="${a.title}" />
                                    <c:if test="${not empty sessionScope.currentUser}">
                                        <c:choose>
                                            <c:when test="${readStatusMap[a.id] == false}">
                                                <span class="badge bg-danger ms-2" style="font-size: 0.75rem;"><i class="bi bi-envelope-open me-1"></i>Unread</span>
                                            </c:when>
                                            <c:when test="${readStatusMap[a.id] == true}">
                                                <span class="badge bg-secondary ms-2" style="font-size: 0.75rem;"><i class="bi bi-envelope me-1"></i>Read</span>
                                            </c:when>
                                        </c:choose>
                                    </c:if>
                                </h5>
                                <p class="mb-3 text-muted"><c:out value="${a.content}" /></p>
                                <div class="text-muted small d-flex align-items-center flex-wrap gap-2">
                                    <span>By <c:out value="${a.createdBy != null ? (a.createdBy.fullName != null ? a.createdBy.fullName : a.createdBy.username) : 'Admin'}" /></span>
                                    <span>|</span>
                                    <span>${a.createdAt}</span>
                                    <span>|</span>
                                    <span class="badge text-bg-${a.status == 'active' ? 'success' : 'secondary'}">${a.status}</span>
                                    
                                    <span class="mx-1">|</span>
                                    <div class="d-inline-flex gap-2">
                                        <c:if test="${not empty sessionScope.currentUser && readStatusMap[a.id] == false}">
                                            <form action="${pageContext.request.contextPath}/notifications/${announcementNotiIdMap[a.id]}/read" method="post" class="d-inline m-0">
                                                <input type="hidden" name="redirect" value="/announcements" />
                                                <button type="submit" class="btn btn-sm btn-outline-primary py-0 px-2 fw-semibold" style="font-size: 0.75rem; border-radius: 4px; line-height: 1.5;">
                                                    <i class="bi bi-check2 me-1"></i> Mark as read
                                                </button>
                                            </form>
                                        </c:if>
                                        <button type="button" class="btn btn-sm btn-outline-danger py-0 px-2 fw-semibold" style="font-size: 0.75rem; border-radius: 4px; line-height: 1.5;" onclick="deleteAnnouncement(${a.id}, '${announcementNotiIdMap[a.id]}')">
                                            <i class="bi bi-trash me-1"></i> Delete
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${sessionScope.currentUser.role == 1}">
                                <div class="d-flex gap-2 flex-wrap justify-content-end">
                                    <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/admin/announcements/edit/${a.id}">Edit</a>
                                    <c:choose>
                                        <c:when test="${a.status == 'active'}">
                                            <form action="${pageContext.request.contextPath}/admin/announcements/${a.id}/status/inactive" method="post">
                                                <button class="btn btn-outline-warning btn-sm" type="submit">Deactivate</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/admin/announcements/${a.id}/status/active" method="post">
                                                <button class="btn btn-outline-success btn-sm" type="submit">Activate</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                    <form action="${pageContext.request.contextPath}/admin/announcements/delete/${a.id}" method="post" onsubmit="return confirm('Delete this announcement?');">
                                        <button class="btn btn-outline-danger btn-sm" type="submit">Delete</button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function() {
        var contextPath = '${pageContext.request.contextPath}';
        var currentUserId = '${sessionScope.currentUser.id}';
        var storageKey = currentUserId && currentUserId !== '0' ? 'hidden_announcements_' + currentUserId : 'hidden_announcements_guest';
        
        // Hide announcements stored in localStorage on load
        var hiddenList = JSON.parse(localStorage.getItem(storageKey) || '[]');
        var visibleCount = 0;
        
        var cards = document.querySelectorAll('.announcement-card');
        cards.forEach(function(card) {
            var annId = card.id.replace('announcement-card-', '');
            if (hiddenList.indexOf(Number(annId)) !== -1 || hiddenList.indexOf(String(annId)) !== -1) {
                card.remove();
            } else {
                visibleCount++;
            }
        });
        
        if (visibleCount === 0 && cards.length > 0) {
            var emptyDiv = document.getElementById('announcements-empty');
            var container = document.getElementById('announcements-container');
            if (container) container.remove();
            if (emptyDiv) emptyDiv.style.display = 'block';
        }
        
        window.deleteAnnouncement = function(annId, notiId) {
            if (!confirm('Are you sure you want to delete/hide this announcement?')) {
                return;
            }
            
            // 1. Save to localStorage
            var list = JSON.parse(localStorage.getItem(storageKey) || '[]');
            if (list.indexOf(annId) === -1) {
                list.push(annId);
                localStorage.setItem(storageKey, JSON.stringify(list));
            }
            
            // 2. Animate and remove from DOM
            var card = document.getElementById('announcement-card-' + annId);
            if (card) {
                card.style.transition = 'all 0.4s ease';
                card.style.opacity = '0';
                card.style.transform = 'translateY(-15px)';
                setTimeout(function() {
                    card.remove();
                    // Check remaining visible cards
                    var remaining = document.querySelectorAll('.announcement-card');
                    if (remaining.length === 0) {
                        var emptyDiv = document.getElementById('announcements-empty');
                        var container = document.getElementById('announcements-container');
                        if (container) container.remove();
                        if (emptyDiv) emptyDiv.style.display = 'block';
                    }
                }, 400);
            }
            
            // 3. Database Sync if notification exists and user is logged in
            if (notiId && notiId !== '' && currentUserId && currentUserId !== '0') {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = contextPath + '/notifications/' + notiId + '/delete';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'redirect';
                input.value = '/announcements';
                form.appendChild(input);
                
                document.body.appendChild(form);
                
                fetch(form.action, {
                    method: 'POST',
                    body: new URLSearchParams(new FormData(form))
                }).then(function() {
                    console.log('Notification deleted in database.');
                });
            }
        };
    })();
</script>
</body>
</html>
