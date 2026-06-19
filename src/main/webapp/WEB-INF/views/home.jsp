<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Java Web Development Project</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        .hero-section {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 100px 0;
            border-bottom: 1px solid #e2e8f0;
        }
        .feature-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .icon-box {
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
        }
    </style>
</head>
<body class="bg-light">

    <%-- 🧩 1. Include Header Component --%>
    <jsp:include page="header.jsp" />

    <%-- 🚀 2. Hero Banner Section --%>
    <div class="hero-section text-center">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <c:choose>
                        <%-- ==================== 🔒 CASE 1: USER LOGGED IN ==================== --%>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <div class="mb-3">
                                <span class="badge bg-success-subtle text-success px-3 py-2 rounded-pill fs-6 fw-semibold">
                                    <i class="bi bi-shield-check me-1"></i> Secure Session Active
                                </span>
                            </div>
                            <h1 class="display-4 fw-bold text-dark mb-3">
                                Welcome Back, <span class="text-primary">${sessionScope.currentUser.username}</span>! 👋
                            </h1>
                            <p class="lead text-muted mb-4">
                                You are currently logged into the system.                               
                            </p>
   
                        </c:when>
                        
                        <%-- ==================== 🔓 CASE 2: GUEST hi USER ==================== --%>
                        <c:otherwise>
                            <div class="mb-3">
                                <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fs-6 fw-semibold">
                                    Java Web Developer Course
                                </span>
                            </div>
                            <h1 class="display-4 fw-bold text-dark mb-3">Java Web Application Project</h1>
                            <p class="lead text-muted mb-0">
                                A systematically structured web application developed using Spring MVC and Hibernate Template architecture patterns.
                            </p>
                            </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <%-- 📊 3. Project Features Grid --%>
    <div class="container my-5 py-4">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-dark">Key System Implementations</h2>
            <p class="text-muted">Core architectural patterns integrated into this enterprise project</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card h-100 feature-card p-4">
                    <div class="icon-box bg-primary-subtle text-primary mb-3">
                        <i class="bi bi-layers-half fs-3"></i>
                    </div>
                    <h5 class="fw-bold">MVC Architecture</h5>
                    <p class="text-muted small">Designed with distinct Controller, Service, and Repository layers to completely separate business logic from infrastructure.</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card h-100 feature-card p-4">
                    <div class="icon-box bg-success-subtle text-success mb-3">
                        <i class="bi bi-shield-check fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Server-Side Validation</h5>
                    <p class="text-muted small">Implements robust server-side processing to validate user credentials using Regular Expressions and avoid duplicate resource generation.</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card h-100 feature-card p-4">
                    <div class="icon-box bg-warning-subtle text-warning mb-3">
                        <i class="bi bi-image fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Multipart File Upload</h5>
                    <p class="text-muted small">Handles dynamic user profile avatar image binary data directly via server-side multipart configurations and references database paths seamlessly.</p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>