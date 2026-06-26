<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Cheat Sheet Hub</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { background-color: #f8f9fa; display: flex; flex-direction: column; min-height: 100vh; }
        .hero-section { background: linear-gradient(135deg, #0d47a1 0%, #1976d2 100%); padding: 120px 0 100px; color: white; text-align: center; clip-path: polygon(0 0, 100% 0, 100% 85%, 0 100%); }
        .hero-title { font-size: 3.5rem; font-weight: 800; margin-bottom: 20px; }
        .hero-subtitle { font-size: 1.2rem; opacity: 0.9; margin-bottom: 40px; }
        
        .feature-card { border: none; border-radius: 15px; background: white; box-shadow: 0 10px 30px rgba(0,0,0,0.05); transition: all 0.3s ease; text-decoration: none; display: block; overflow: hidden; }
        .feature-card:hover { transform: translateY(-10px); box-shadow: 0 15px 40px rgba(25,118,210,0.15); }
        .icon-wrapper { width: 80px; height: 80px; background: #e3f2fd; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; color: #1976d2; font-size: 35px; transition: 0.3s; }
        .feature-card:hover .icon-wrapper { background: #1976d2; color: white; }
        .card-title { font-weight: 700; color: #333; }
        
        .main-content { flex: 1; margin-top: -60px; padding-bottom: 60px; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="hero-section">
        <div class="container">
            <h1 class="hero-title">Developer Cheat Sheets</h1>
            <p class="hero-subtitle">Your ultimate library for quick coding references, shortcuts, and commands.</p>
            <a href="#categories" class="btn btn-light btn-lg text-primary fw-bold px-5 rounded-pill shadow-sm">Start Exploring</a>
        </div>
    </div>

    <div class="main-content container" id="categories">
        <div class="text-center mb-5 mt-5">
            <h2 class="fw-bold text-dark">Browse by Category</h2>
            <div class="mx-auto mt-2" style="height: 4px; width: 60px; background-color: #1976d2; border-radius: 2px;"></div>
        </div>

        <c:choose>
            <c:when test="${empty categorylist}">
                <div class="text-center text-muted my-5 py-5 bg-white rounded-4 shadow-sm border">
                    <i class="bi bi-inbox fs-1 d-block mb-3 text-secondary"></i>
                    <h4>No categories found</h4>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4 justify-content-center">
                    <c:forEach items="${categorylist}" var="c">
                        <div class="col-md-6 col-lg-4">
                            <a href="${pageContext.request.contextPath}/cheatsheet/category/${c.id}" class="feature-card p-4 text-center h-100">
                                <div class="icon-wrapper">
                                    <i class="bi bi-journal-code"></i>
                                </div>
                                <h4 class="card-title mb-2">${c.name}</h4>
                                <p class="text-muted mb-0">Explore docs & guides</p>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>