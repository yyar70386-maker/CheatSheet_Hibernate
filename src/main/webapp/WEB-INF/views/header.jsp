<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
</style>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top">
    <div class="container">
        <a class="navbar-brand text-primary" href="${pageContext.request.contextPath}/">
            <i class="bi bi-code-square me-2"></i>JWD Project
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/"><i class="bi bi-house-door me-1"></i> Home</a>
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