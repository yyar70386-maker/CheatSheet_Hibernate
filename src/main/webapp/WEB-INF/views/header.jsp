<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<!-- 🌟 [FIXED] Logout SweetAlert အလုပ်လုပ်ရန် လိုအပ်သော SweetAlert2 Library အား ပြန်လည်ဖြည့်စွက်ခြင်း -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        border-radius: 8px;
    }
    .dropdown-item {
        padding: 8px 20px;
        transition: all 0.2s ease;
    }
    .dropdown-item:hover {
        background-color: #f8f9fa;
    }
    /* Notification Custom Styles */
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
        background-color: #ff3366 !important;
        border-color: #ff3366 !important;
        color: #fff !important;
    }
    /* Global Admin Layout & Theme Styles */
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
        color: #ff3366 !important;
    }
    .bg-brand-primary {
        background-color: #ff3366 !important;
        color: #fff !important;
    }
    .btn-brand-primary {
        background-color: #ff3366 !important;
        border-color: #ff3366 !important;
        color: #fff !important;
    }
    .btn-brand-primary:hover {
        background-color: #e62e5c !important;
        border-color: #e62e5c !important;
        color: #fff !important;
    }
    .btn-outline-primary {
        color: #ffffff;
        border-color: rgba(255, 255, 255, 0.6);
    }
    .btn-outline-primary:hover {
        background-color: #ffffff;
        color: #ff3366;
        border-color: #ffffff;
    }
    .btn-primary {
        background-color: #ffffff;
        border-color: #ffffff;
        color: #ff3366 !important;
    }
    .btn-primary:hover {
        background-color: rgba(255, 255, 255, 0.9);
        border-color: rgba(255, 255, 255, 0.9);
        color: #e62e5c !important;
    }
    .text-primary {
        color: #ff3366 !important;
    }
    /* Custom controls for white text on pink navbar navigation link elements */
    .custom-navbar .nav-link {
        color: rgba(255, 255, 255, 0.85) !important;
    }
    .custom-navbar .nav-link.active, .custom-navbar .nav-link:hover {
        color: #ffffff !important;
    }
    .custom-navbar .navbar-toggler {
        border-color: rgba(255, 255, 255, 0.5);
    }
    .custom-navbar .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.9%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }
</style>

<!-- Navbar with Pink Gradient Glassmorphism -->
<nav class="navbar navbar-expand-lg navbar-light sticky-top custom-navbar" style="background: linear-gradient(135deg, rgba(255, 51, 102, 0.9), rgba(255, 94, 132, 0.9)); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); border-bottom: 1px solid rgba(255, 255, 255, 0.25); box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);">
    <div class="container">
        <a class="navbar-brand fw-bold fs-4 d-flex align-items-center" href="${pageContext.request.contextPath}/">
            <!-- Brand icon box color altered to stand out nicely -->
            <span style="background: #ffffff; width:34px; height:34px; border-radius:8px; display:inline-flex; align-items:center; justify-content:center; margin-right: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.15);">
                <i class="bi bi-code-square text-primary" style="font-size: 1.1rem; line-height: 1;"></i> 
            </span>
            <span class="text-white">KnowledgeHub</span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Left Side: Navigation Links -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/home">
                        <i class="bi bi-house-door me-1"></i> Home
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
            
            <!-- Right Side: User Controls -->
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
                            <a class="btn btn-primary d-flex align-items-center" href="${pageContext.request.contextPath}/register" style="border-radius: 6px; padding: 6px 16px;">
                                <i class="bi bi-person-plus me-1"></i> Register
                            </a>
                        </li>
                    </c:when>
                    
                    <%-- ==================== 🔒 CASE 2: USER IS LOGGED IN ==================== --%>
                    <c:otherwise>
                        <!-- Notification Dropdown -->
                        <li class="nav-item dropdown me-lg-2">
                            <a class="nav-link notification-button" href="#" id="notificationDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-bell fs-5"></i>
                                <span id="notificationBadge" class="badge rounded-pill bg-danger notification-badge">0</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end notification-menu" aria-labelledby="notificationDropdown">
                                <li class="dropdown-header d-flex justify-content-between align-items-center">
                                    <span class="fw-bold text-dark">Notifications</span>
                                    <a class="small text-decoration-none text-primary" href="${pageContext.request.contextPath}/notifications">View all</a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li id="notificationEmpty" class="px-3 py-2 text-muted small">No notifications yet.</li>
                                <li id="notificationList"></li>
                            </ul>
                        </li>

                        <!-- User Profile Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.currentUser.avatarPath}">
                                        <img src="${pageContext.request.contextPath}/uploads/${sessionScope.currentUser.avatarPath}" class="rounded-circle me-2 nav-avatar" width="32" height="32">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-person-circle me-2 text-white" style="font-size: 1.4rem; opacity: 0.9;"></i>
                                    </c:otherwise>
                                </c:choose>
                                <span class="fw-medium text-white">${sessionScope.currentUser.fullName}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2 text-primary"></i> My Profile
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout" onclick="confirmLogout(event)">
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
                var titleText = notification.title || notification.notificationType || 'New notification';
                title.textContent = titleText;
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

        function confirmLogout(event) {
            event.preventDefault(); 
            const logoutUrl = event.currentTarget.getAttribute('href'); 

            Swal.fire({
                title: 'Are you sure?',
                text: "Do you really want to log out of your account?",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ff3366',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, logout!',
                cancelButtonText: 'Cancel',
                reverseButtons: true 
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = logoutUrl;
                }
            });
        }
    </script>
</c:if>