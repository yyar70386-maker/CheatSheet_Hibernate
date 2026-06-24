<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Cheat Sheet Project</title>
    
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
            text-decoration: none; 
            display: block;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        .icon-box {
            width: 70px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background-color: #e9ecef;
            margin: 0 auto 20px auto;
        }
        .icon-box i {
            font-size: 32px;
            color: #333;
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
                        
                        <%-- ==================== 🔓 CASE 2: GUEST USER ==================== --%>
                        <c:otherwise>
                            <div class="mb-3">
                                <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fs-6 fw-semibold">
                                    On Job Training Course
                                </span>
                            </div>
                            <h1 class="display-4 fw-bold text-dark mb-3">Cheat Sheet Project</h1>
                            <p class="lead text-muted mb-0">
                                A systematically structured web application developed using Spring MVC and Hibernate Template architecture patterns.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    
    <div class="container my-5 py-4">
        
        <div class="text-center mb-5">
            <h2 class="fw-bold text-dark">Browse Categories</h2>
            <p class="text-muted">Explore cheat sheets by category and improve your skills.</p>
        </div>

        <c:choose>
           
            <c:when test="${empty categorylist}">
                <div class="text-center text-muted fs-5 my-5">
                    <i class="bi bi-folder-x display-4 d-block mb-3"></i>
                    No categories available at the moment.
                </div>
            </c:when>
            
           
            <c:otherwise>
                <div class="row g-4 justify-content-center">
                    <c:forEach items="${categorylist}" var="c">
                        
                        <div class="col-md-6 col-lg-4">
                           
                            <a href="${pageContext.request.contextPath}/cheatsheet/category/${c.id}" class="card feature-card h-100 p-4 text-center">
                                
                                <div class="icon-box">
                                    <i class="bi bi-layers-half"></i>
                                </div>
                                
                                <div class="card-body p-0">
                                    <h4 class="card-title fw-bold text-dark mb-3">${c.name} Cheat Sheets</h4>
                                    <p class="card-text text-secondary sm">Browse all cheat sheets from this category.</p>
                                </div>
                                
                            </a>
                        </div>

                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>