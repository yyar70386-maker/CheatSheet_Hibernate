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
        /* 💡 ပုံထဲက ကတ်ဒီဇိုင်းအတွက် ထပ်တိုးစတိုင် */
        .cheatsheet-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            background-color: #ffffff;
        }
        .author-link {
            color: #212529;
            font-weight: 700; /* Bold အရောင်တင်ခြင်း */
            text-decoration: none;
        }
        .author-link:hover {
            color: #0d6efd; /* Hover အပြာရောင်ပြောင်းခြင်း */
            text-decoration: underline;
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

    <%-- 📂 3. Dynamic Categories Card Section --%>
    <div class="container my-5 py-2">
        <div class="text-center mb-4">
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
                                }</div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <hr class="container my-5" style="opacity: 0.1;">

    <%-- 📄 🌟 4. [UPDATED] Recent Cheat Sheets Section (မိတ်ဆွေတောင်းဆိုထားသော အပိုင်း) --%>
    <div class="container mb-5 pb-5">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-dark">Recent Cheat Sheets</h2>
            <p class="text-muted">Check out the latest contributions from our developers.</p>
        </div>

        <c:choose>
            <%-- Controller မှ cheatsheetlist သို့မဟုတ် sheets ဟူသော variable ဖြင့် data လွှတ်ပေးရမည် --%>
            <c:when test="${empty cheatsheetlist}">
                <div class="text-center text-muted fs-6 py-4">
                    <i class="bi bi-file-earmark-x display-5 d-block mb-2"></i>
                    No cheat sheets shared yet.
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach items="${cheatsheetlist}" var="sheet">
                        
                        <div class="col-md-6 col-lg-4">
                            <div class="card cheatsheet-card p-4 h-100">
                                
                                <h3 class="fw-bold text-dark mb-1">${sheet.title}</h3> <p class="text-muted small mb-3">${sheet.description}</p> <a href="${pageContext.request.contextPath}/cheatsheet/view/${sheet.id}" class="text-primary fw-semibold small text-decoration-none d-block mb-4">See More</a>
                                
                                <div class="mb-2 text-secondary small d-flex align-items-center">
                                    <i class="bi bi-person text-dark me-2"></i>
                                    <a href="${pageContext.request.contextPath}/profile/${sheet.author.id}" class="author-link">
                                        <c:out value="${sheet.author.fullName}" /> </a>
                                </div>
                                
                                <div class="mb-2 text-secondary small d-flex align-items-center">
                                    <i class="bi bi-folder-fill me-2"></i>
                                    <span>${sheet.category.name} Cheat Sheets</span>
                                </div>
                                
                                <div class="mb-2 text-secondary small d-flex align-items-center">
                                    <i class="bi bi-calendar-plus me-2"></i>
                                    <span>Created: ${sheet.createdAt}</span>
                                </div>
                                
                                <div class="mb-4 text-secondary small d-flex align-items-center">
                                    <i class="bi bi-calendar-check me-2"></i>
                                    <span>Updated: ${sheet.updatedAt}</span>
                                </div>
                                
                                <div class="mb-4">
                                    <span class="text-primary fw-semibold small">#HR</span>
                                </div>
                                
                                <div class="d-flex gap-3 text-muted small mt-auto pt-2 border-top" style="opacity: 0.8;">
                                    <div><i class="bi bi-eye me-1"></i> ${sheet.viewCount}</div>
                                    <div><i class="bi bi-download me-1"></i> ${sheet.downloadCount}</div>
                                </div>

                            </div>
                        </div>

                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>