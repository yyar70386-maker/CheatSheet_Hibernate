<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home - CheatSheet Library</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- 📊 Chart.js Library -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
:root {
    --page-bg: #f8f9fa;
    --card-bg: #ffffff;
    --text-dark: #212529;
    --text-muted: #6c757d;
    --line-color: #dee2e6;
    --brand-primary: #1976d2;
    --brand-dark: #0d47a1;
    --accent-green: #2e7d32;
    --accent-teal: #00796b;
    --accent-amber: #f57c00;
}

html, body {
    height: 100vh;
    overflow: hidden;
    margin: 0;
    padding: 0;
    background-color: var(--page-bg);
    color: var(--text-dark);
    font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

a {
    color: var(--brand-primary);
    text-decoration: none;
}

a:hover {
    color: var(--brand-dark);
}

.app-container {
    display: flex;
    height: calc(100vh - 56px);
    width: 100%;
}

.main-content-area {
    flex-grow: 1;
    height: 100%;
    overflow-y: auto;
    min-width: 0;
    padding: 24px;
    background-color: var(--page-bg);
}

/* Hero Banner Section */
.hero-section {
    background: linear-gradient(135deg, var(--brand-dark) 0%, var(--brand-primary) 100%);
    padding: 3.5rem 2rem;
    color: white;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.search-panel {
    background: var(--card-bg);
    border-radius: 50px;
    padding: 0.4rem;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.search-input {
    border: 0;
    background: transparent;
    padding-left: 1rem;
}

.search-input:focus {
    box-shadow: none;
}

.btn-library {
    background-color: var(--brand-primary);
    color: white;
    font-weight: 600;
    border-radius: 50px;
    transition: all 0.2s ease;
}

.btn-library:hover {
    background-color: var(--brand-dark);
    color: white;
}

.section-title {
    font-weight: 700;
    position: relative;
    padding-bottom: 0.5rem;
    margin-bottom: 1.5rem;
}

.section-title::after {
    content: '';
    position: absolute;
    left: 0;
    bottom: 0;
    height: 3px;
    width: 40px;
    background-color: var(--brand-primary);
    border-radius: 2px;
}

.feature-card, .cheatsheet-card, .notice-card, .empty-panel {
    border: 1px solid var(--line-color);
    background: var(--card-bg);
    border-radius: 8px;
}

.feature-card {
    transition: transform 0.3s ease;
    text-decoration: none;
    display: block;
}

.feature-card:hover {
    transform: translateY(-5px);
}

.icon-box {
    width: 64px;
    height: 64px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background-color: #e9ecef;
    margin: 0 auto 15px auto;
}

/* CheatSheet Card Standardized Styles */
.cheatsheet-card {
    border: 1px solid #e2e8f0;
    border-radius: 20px;
    padding: 25px;
    background: white;
    box-shadow: 0 4px 15px rgba(0,0,0,0.02);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    height: auto;
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
}

.cheatsheet-card:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
}

.description-text {
    display: -webkit-box;
    -webkit-line-clamp: 3; 
    -webkit-box-orient: vertical;  
    overflow: hidden;
    transition: all 0.3s ease;
}

.description-text.expanded {
    display: block;
    -webkit-line-clamp: unset;
}

.see-more-btn {
    color: #1976d2;
    cursor: pointer;
    font-weight: bold;
    font-size: 14px;
    text-decoration: none;
    display: inline-block;
    margin-top: 5px;
}

.see-more-btn:hover {
    text-decoration: underline;
}

.card-meta-item {
    color: #555;
    font-size: 14px;
    margin-bottom: 8px;
    display: flex;
    align-items: center;
    gap: 10px;
}

/* Tag Badges Styles */
.tag-badge-link {
    background-color: #e2e8f0;
    color: #333;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    text-decoration: none;
    display: inline-block;
}

.tag-badge-link:hover {
    background-color: #1976d2;
    color: white;
}

.stats-section {
    font-size: 14px;
    color: #555;
    display: flex;
    gap: 20px;
    margin-top: 15px;
}

/* Visibility Pill Badges Styles */
.visibility-pill {
    font-size: 11px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 50px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    text-transform: capitalize;
}

.pill-public {
    background-color: #d1e7dd;
    color: #0f5132;
}

.pill-friends {
    background-color: #cff4fc;
    color: #055160;
}

.pill-private {
    background-color: #f8d7da;
    color: #842029;
}

/* Admin Circle Chart Box */
.chart-box-container {
    position: relative;
    margin: auto;
    height: 200px;
    width: 200px;
}
</style>
</head>
<body>

    <%-- 🧩 Header Component --%>
    <jsp:include page="header.jsp" />

    <div class="app-container">

        <%-- 🛠️ Sidebar Component --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <div class="main-content-area">

            <%-- 🔐 Role-Based Switching Logic --%>
            <c:choose>
                <%-- 🌟 ADMIN VIEW --%>
                <c:when test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
                    <div class="mb-5 text-center mt-3">
                        <h2 class="fw-bold mb-2">
                            <i class="bi bi-speedometer2 text-primary me-2"></i>Admin Overview Panel
                        </h2>
                        <div class="text-muted small">Real-time database system summary metrics info</div>
                    </div>

                    <div class="row g-4 justify-content-center">
                        <!-- Total Users Circle -->
                        <div class="col-md-4">
                            <div class="card bg-white border-0 shadow-sm rounded-3 p-4 text-center h-100">
                                <h6 class="text-muted fw-bold mb-3">
                                    <i class="bi bi-people-fill me-2 text-primary"></i>Total Users
                                </h6>
                                <div class="chart-box-container">
                                    <canvas id="usersCircleChart"></canvas>
                                </div>
                                <div class="fs-4 fw-bold mt-3 text-dark">
                                    <c:out value="${not empty totalUsers ? totalUsers : (not empty summary.totalUsers ? summary.totalUsers : 0)}" />
                                </div>
                            </div>
                        </div>

                        <!-- Total Categories Circle -->
                        <div class="col-md-4">
                            <div class="card bg-white border-0 shadow-sm rounded-3 p-4 text-center h-100">
                                <h6 class="text-muted fw-bold mb-3">
                                    <i class="bi bi-tags-fill me-2 text-warning"></i>Total Categories
                                </h6>
                                <div class="chart-box-container">
                                    <canvas id="categoriesCircleChart"></canvas>
                                </div>
                                <div class="fs-4 fw-bold mt-3 text-dark">
                                    <c:out value="${not empty categorylist ? categorylist.size() : 0}" />
                                </div>
                            </div>
                        </div>

                        <!-- Total CheatSheets Circle -->
                        <div class="col-md-4">
                            <div class="card bg-white border-0 shadow-sm rounded-3 p-4 text-center h-100">
                                <h6 class="text-muted fw-bold mb-3">
                                    <i class="bi bi-file-earmark-code-fill me-2 text-success"></i>Cheat Sheets
                                </h6>
                                <div class="chart-box-container">
                                    <canvas id="sheetsCircleChart"></canvas>
                                </div>
                                <div class="fs-4 fw-bold mt-3 text-dark">
                                    <div class="fs-4 fw-bold mt-3 text-dark">
                                        <c:out value="${not empty totalSheets ? totalSheets : (not empty summary.totalCheatsheets ? summary.totalCheatsheets : 0)}" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- 🌟 REGULAR USER / GUEST VIEW --%>
                <c:otherwise>
                    <%-- 🚀 Hero Banner Section --%>
                    <header class="hero-section mb-5">
                        <div class="container-fluid px-2">
                            <div class="row g-4 align-items-center">
                                <div class="col-xl-7 text-center text-xl-start">
                                    <div class="text-uppercase small fw-bold tracking-wider mb-2 opacity-75">Quick references for every topic</div>
                                    <h1 class="hero-title mb-3">Developer Cheat Sheets</h1>
                                    <p class="fs-5 opacity-90 mb-0">
                                        Browse community cheat sheets, search fast, and jump into the newest references first.
                                    </p>
                                </div>
                                <div class="col-xl-5">
                                    <form action="${pageContext.request.contextPath}/home" method="get" class="search-panel shadow-sm">
                                        <div class="input-group">
                                            <span class="input-group-text bg-transparent border-0"><i class="bi bi-search text-muted"></i></span>
                                            <input type="search" class="form-control search-input" name="q" value="${searchQuery}" placeholder="Search cheat sheets...">
                                            <button class="btn btn-library px-4" type="submit">Search</button>
                                        </div>
                                    </form>
                                    <div class="d-flex flex-wrap justify-content-center justify-content-xl-start gap-2 mt-3">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.currentUser}">
                                                <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/cheatsheet/add">
                                                    <i class="bi bi-plus-circle-fill text-primary"></i> Create
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/login">
                                                    <i class="bi bi-plus-circle-fill text-primary"></i> Create
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                        <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone-fill text-warning"></i> Announcements</a>
                                        <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-circle text-info"></i> Profile</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </header>

                    <%-- Browse Categories Layout --%>
                    <section class="mb-5" id="categories">
                        <div class="d-flex align-items-end justify-content-between mb-4">
                            <div>
                                <h2 class="section-title h4 mb-1">Browse Categories</h2>
                            </div>
                        </div>
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                            <c:forEach items="${categorylist}" var="c">
                                <div class="col">
                                    <a href="${pageContext.request.contextPath}/cheatsheet/category/${c.id}" class="card feature-card h-100 p-4 text-center bg-white">
                                        <div class="icon-box">
                                            <i class="bi bi-layers-half text-primary"></i>
                                        </div>
                                        <h5 class="card-title fw-bold text-dark mb-2">${c.name}</h5>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </section>

                    <%-- 🌟 [UPDATED SPLIT GRID] Latest Feed (ဘယ်ဘက်) နှင့် Popular Feed (ညာဘက်) စနစ် --%>
                    <div class="row g-4 mb-5">
                        
                        <%-- ⬅️ LEFT SIDE: LATEST CHEAT SHEETS --%>
                        <div class="col-10 col-lg-6">
                            <h2 class="section-title h4 mb-4">Latest Cheat Sheets</h2>
                            <div class="row row-cols-1">
                                <c:forEach items="${cheatsheetlist}" var="sheet">
                                    <div class="col">
                                        <div class="cheatsheet-card">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h5 class="fw-bold m-0">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark text-decoration-none hover-underline fs-5">
                                                            ${sheet.title}
                                                        </a>
                                                    </h5>
                                                    
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.currentUser}">
                                                            <c:choose>
                                                                <c:when test="${sheet.visibility == 'PUBLIC'}">
                                                                    <span class="visibility-pill pill-public">
                                                                        <i class="bi bi-globe"></i> Public
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${sheet.visibility == 'FRIEND-ONLY'}">
                                                                    <span class="visibility-pill pill-friends">
                                                                        <i class="bi bi-people-fill"></i> Friends
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="visibility-pill pill-private">
                                                                        <i class="bi bi-lock-fill"></i> Private
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="visibility-pill pill-public">
                                                                <i class="bi bi-globe"></i> Public
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="description-container mb-3">
                                                    <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                                    <span class="see-more-btn" onclick="toggleDescription(this)">See More</span>
                                                </div>
                                                
                                                <div class="card-meta-item">
                                                    <i class="bi bi-person text-muted"></i> ${sheet.author != null ? sheet.author.username : 'Unknown'}
                                                </div>
                                                <div class="card-meta-item">
                                                    <i class="bi bi-folder text-muted"></i> ${sheet.category != null ? sheet.category.name : 'General'} Cheat Sheets
                                                </div>
                                                <div class="card-meta-item">
                                                    <i class="bi bi-calendar-plus text-muted"></i> Created: <fmt:formatDate value="${sheet.createdAt}" pattern="yyyy-MM-dd"/>
                                                </div>
                                                <div class="card-meta-item">
                                                    <i class="bi bi-calendar-event text-muted"></i> Updated: <fmt:formatDate value="${sheet.updatedAt}" pattern="yyyy-MM-dd"/>
                                                </div>

                                                <div class="d-flex flex-wrap gap-2 my-3">
                                                    <c:forEach items="${sheet.tags}" var="tag">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge-link">#${tag.name}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>

                                            <div class="stats-section mt-auto d-flex justify-content-between align-items-center border-top pt-3">
                                                <div class="d-flex gap-3">
                                                    <span><i class="bi bi-eye text-muted me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                    <span><i class="bi bi-download text-muted me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                                       target="_blank" 
                                                       class="btn btn-sm btn-outline-danger px-3 py-1 d-flex align-items-center gap-1 fw-bold"
                                                       style="border-radius: 8px; font-size: 13px;"
                                                       title="View PDF Document">
                                                        <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <%-- ➡️ RIGHT SIDE: POPULAR CHEAT SHEETS --%>
                        <div class="col-10 col-lg-6">
                            <h2 class="section-title h4 mb-4">Popular Cheat Sheets</h2>
                            <div class="row row-cols-1">
                                <c:forEach items="${popularCheatsheets}" var="sheet">
                                    <div class="col">
                                        <div class="cheatsheet-card">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h5 class="fw-bold m-0">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark text-decoration-none hover-underline fs-5">
                                                            ${sheet.title}
                                                        </a>
                                                    </h5>
                                                    
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.currentUser}">
                                                            <c:choose>
                                                                <c:when test="${sheet.visibility == 'PUBLIC'}">
                                                                    <span class="visibility-pill pill-public">
                                                                        <i class="bi bi-globe"></i> Public
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${sheet.visibility == 'FRIEND-ONLY'}">
                                                                    <span class="visibility-pill pill-friends">
                                                                        <i class="bi bi-people-fill"></i> Friends
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="visibility-pill pill-private">
                                                                        <i class="bi bi-lock-fill"></i> Private
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="visibility-pill pill-public">
                                                                <i class="bi bi-globe"></i> Public
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="description-container mb-3">
                                                    <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                                    <span class="see-more-btn" onclick="toggleDescription(this)">See More</span>
                                                </div>
                                                
                                                <div class="card-meta-item">
                                                    <i class="bi bi-person text-muted"></i> ${sheet.author != null ? sheet.author.username : 'Unknown'}
                                                </div>
                                                <div class="card-meta-item">
                                                    <i class="bi bi-folder text-muted"></i> ${sheet.category != null ? sheet.category.name : 'General'} Cheat Sheets
                                                </div>
                                                <div class="card-meta-item">
                                                    <i class="bi bi-calendar-plus text-muted"></i> Created: <fmt:formatDate value="${sheet.createdAt}" pattern="yyyy-MM-dd"/>
                                                </div>
                                                <div class="card-meta-item">
                                                    <i class="bi bi-calendar-event text-muted"></i> Updated: <fmt:formatDate value="${sheet.updatedAt}" pattern="yyyy-MM-dd"/>
                                                </div>

                                                <div class="d-flex flex-wrap gap-2 my-3">
                                                    <c:forEach items="${sheet.tags}" var="tag">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge-link">#${tag.name}</a>
                                                    </c:forEach>
                                                </div>
                                            </div>

                                            <div class="stats-section mt-auto d-flex justify-content-between align-items-center border-top pt-3">
                                                <div class="d-flex gap-3">
                                                    <span><i class="bi bi-eye text-muted me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                    <span><i class="bi bi-download text-muted me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                                       target="_blank" 
                                                       class="btn btn-sm btn-outline-danger px-3 py-1 d-flex align-items-center gap-1 fw-bold"
                                                       style="border-radius: 8px; font-size: 13px;"
                                                       title="View PDF Document">
                                                        <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        
                    </div>

                    <jsp:include page="footer.jsp" />
                </c:otherwise>
            </c:choose>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Admin Circle Charts Script -->
    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
        <script>
            const valUsers = ${not empty totalUsers ? totalUsers : (not empty summary.totalUsers ? summary.totalUsers : 0)};
            const valCategories = ${not empty categorylist ? categorylist.size() : 0};
            const valSheets = ${not empty totalSheets ? totalSheets : (not empty summary.totalCheatsheets ? summary.totalCheatsheets : 0)};

            const globalChartConfig = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                cutout: '75%'
            };

            new Chart(document.getElementById('usersCircleChart'), {
                type: 'doughnut',
                data: { datasets: [{ data: [valUsers, valUsers == 0 ? 1 : 0], backgroundColor: ['#1976d2', '#e9ecef'], borderWidth: 0 }] },
                options: globalChartConfig
            });

            new Chart(document.getElementById('categoriesCircleChart'), {
                type: 'doughnut',
                data: { datasets: [{ data: [valCategories, valCategories == 0 ? 1 : 0], backgroundColor: ['#ffc107', '#e9ecef'], borderWidth: 0 }] },
                options: globalChartConfig
            });

            new Chart(document.getElementById('sheetsCircleChart'), {
                type: 'doughnut',
                data: { datasets: [{ data: [valSheets, valSheets == 0 ? 1 : 0], backgroundColor: ['#2e7d32', '#e9ecef'], borderWidth: 0 }] },
                options: globalChartConfig
            });
        </script>
    </c:if>
    
    <script>
    function toggleDescription(btn) {
        var textEl = btn.previousElementSibling;
        textEl.classList.toggle('expanded');
        
        if (textEl.classList.contains('expanded')) {
            btn.innerText = 'See Less';
        } else {
            btn.innerText = 'See More';
        }
    }
    </script>
</body>
</html>