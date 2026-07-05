<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
    .navbar-brand {
        font-weight: 700;
        letter-spacing: 0.5px;
    }
    .nav-avatar {
        object-fit: cover;
        border: 2px solid #fff;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .dropdown-menu {
        border: none;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        border-radius: 8px;
    }
    .dropdown-item {
        padding: 8px 20px;
        transition: all 0.2s ease;
    }
    .dropdown-item:hover {
        background-color: #f8f9fa;
    }
    /* 🌟 Notification Custom Styles */
    .notification-button {
        position: relative;
    }
    .notification-badge {
        position: absolute;
        top: 0;
        right: 0;
        transform: translate(35%, -35%);
        display: none;
    }
    .notification-menu {
        width: 320px;
        max-height: 380px;
        overflow-y: auto;
    }
    .notification-item {
        white-space: normal;
    }
    .notification-toast {
        position: fixed;
        top: 72px;
        right: 24px;
        z-index: 1080;
        width: min(360px, calc(100vw - 32px));
        display: none;
    }
    /* 🌟 Global Admin Layout & Theme Styles */
    .app-container {
        display: flex;
        height: calc(100vh - 56px); 
        width: 100%;
    }
    .admin-sidebar {
        width: 280px;
        height: 100%;
        flex-shrink: 0;
        overflow-y: auto; 
    }
    .main-content-area {
        flex-grow: 1;
        height: 100%;
        overflow-y: auto; 
        min-width: 0;
        padding: 24px;
        background-color: #f8f9fa;
    }
    .brand-primary {
        color: #4f46e5 !important;
    }
    .bg-brand-primary {
        background-color: #4f46e5 !important;
        color: #fff !important;
    }
    .btn-brand-primary {
        background-color: #4f46e5 !important;
        border-color: #4f46e5 !important;
        color: #fff !important;
    }
    .btn-brand-primary:hover {
        background-color: #4338ca !important;
        border-color: #4338ca !important;
        color: #fff !important;
    }
</style>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <i class="bi bi-code-square me-2 text-primary"></i> 
            <span class="text-dark">Cheat</span><span class="text-primary">Sheet</span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door me-1"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home#latest-sheets">
                        <i class="bi bi-journal-code me-1"></i> CheatSheets
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/cheatsheet/list">
                        <i class="bi bi-list-ul me-1"></i> List
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/cheatsheet/add">
                        <i class="bi bi-plus-circle me-1"></i> Create
                    </a>
                </li>
            </ul>
            
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                <c:choose>
                    <%-- ==================== 🔓 CASE 1: USER IS NOT LOGGED IN ==================== --%>
                    <c:when test="${empty sessionScope.currentUser}">
                        <li class="nav-item">
                            <a class="btn btn-outline-primary me-2 d-flex align-items-center" href="${pageContext.request.contextPath}/login" style="border-radius: 6px; padding: 6px 16px;">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary text-white d-flex align-items-center" href="${pageContext.request.contextPath}/register" style="border-radius: 6px; padding: 6px 16px;">
                                <i class="bi bi-person-plus me-1"></i> Register
                            </a>
                        </li>
                    </c:when>
                    
                    <%-- ==================== 🔒 CASE 2: USER IS LOGGED IN ==================== --%>
                    <c:otherwise>
                        <li class="nav-item dropdown me-lg-2">
                            <a class="nav-link notification-button" href="#" id="notificationDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-bell fs-5"></i>
                                <span id="notificationBadge" class="badge rounded-pill bg-danger notification-badge">0</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end notification-menu" aria-labelledby="notificationDropdown">
                                <li class="dropdown-header d-flex justify-content-between align-items-center">
                                    <span>Notifications</span>
                                    <a class="small text-decoration-none" href="${pageContext.request.contextPath}/notifications">View all</a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li id="notificationEmpty" class="px-3 py-2 text-muted small">No notifications yet.</li>
                                <li id="notificationList"></li>
                            </ul>
                        </li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser.avatarPath}">
                                        <img src="${pageContext.request.contextPath}/uploads/${sessionScope.currentUser.avatarPath}" 
                                             class="rounded-circle me-2 nav-avatar" 
                                             width="32" height="32">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-person-circle me-2 text-secondary" style="font-size: 1.4rem;"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span class="fw-medium">${sessionScope.currentUser.fullName}</span>
                            </a>
                            
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2 text-primary"></i> My Profile
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<div id="notificationToast" class="alert alert-primary shadow notification-toast" role="alert">
    <div class="d-flex gap-2">
        <i class="bi bi-bell-fill"></i>
        <div>
            <div class="fw-semibold" id="notificationToastTitle">New notification</div>
            <div class="small" id="notificationToastMessage"></div>
        </div>
    </div>
</div>

<%-- ==================== 🌐 WEBSOCKET REAL-TIME NOTIFICATION SCRIPT ==================== --%>
<c:if test="${not empty sessionScope.currentUser}">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        (function () {
            var contextPath = '${pageContext.request.contextPath}';
            var currentUserId = '${sessionScope.currentUser.id}';
            var badge = document.getElementById('notificationBadge');
            var list = document.getElementById('notificationList');
            var empty = document.getElementById('notificationEmpty');
            var unreadCount = 0;

            function setBadge(count) {
                unreadCount = parseInt(count, 10) || 0;
                badge.textContent = unreadCount;
                badge.style.display = unreadCount > 0 ? 'inline-block' : 'none';
            }

            function escapeHtml(value) {
                var div = document.createElement('div');
                div.textContent = value || '';
                return div.innerHTML;
            }

            function addNotification(notification, prepend) {
                empty.style.display = 'none';

                var item = document.createElement('a');
                item.className = 'dropdown-item notification-item small';
                item.href = notification.linkUrl ? contextPath + notification.linkUrl : contextPath + '/notifications';
                item.innerHTML = '<div class="fw-semibold">' + escapeHtml(notification.message) + '</div>'
                    + '<div class="text-muted">' + escapeHtml(notification.notificationType || 'NOTIFICATION') + '</div>';

                if (prepend && list.firstChild) {
                    list.insertBefore(item, list.firstChild);
                } else {
                    list.appendChild(item);
                }
            }

            function showNotificationAlert(notification) {
                var toast = document.getElementById('notificationToast');
                var title = document.getElementById('notificationToastTitle');
                var message = document.getElementById('notificationToastMessage');
                title.textContent = notification.title || notification.notificationType || 'New notification';
                message.textContent = notification.message || '';
                toast.style.display = 'block';
                window.clearTimeout(window.cheatSheetNotificationTimer);
                window.cheatSheetNotificationTimer = window.setTimeout(function () {
                    toast.style.display = 'none';
                }, 5000);
            }

            function loadRecentNotifications() {
                fetch(contextPath + '/notifications/recent')
                    .then(function (response) { return response.json(); })
                    .then(function (data) {
                        list.innerHTML = '';
                        setBadge(data.unreadCount);
                        if (!data.notifications || data.notifications.length === 0) {
                            empty.style.display = 'block';
                            return;
                        }
                        data.notifications.forEach(function (notification) {
                            addNotification(notification, false);
                        });
                    });
            }

            function connectNotificationSocket() {
                var socket = new SockJS(contextPath + '/ws-notifications');
                var stompClient = Stomp.over(socket);
                stompClient.debug = null;
                stompClient.connect({}, function () {
                    stompClient.subscribe('/topic/notifications/' + currentUserId, function (message) {
                        var notification = JSON.parse(message.body);
                        setBadge(unreadCount + 1);
                        addNotification(notification, true);
                        showNotificationAlert(notification);
                    });
                });
            }

            loadRecentNotifications();
            connectNotificationSocket();
        })();
    </script>
</c:if>
