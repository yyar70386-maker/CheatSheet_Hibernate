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
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

/* ================= Base & Background ================= */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Inter', sans-serif;
}

body {
    background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
    min-height: 100vh;
    overflow-x: hidden;
    position: relative;
    color: #1a1a1a;
}

/* ================= Particle Canvas ================= */
#particles {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    z-index: 0;
    pointer-events: none;
}

a { text-decoration: none; color: #ff3366; }
a:hover { color: #cc0044; }

/* ================= Layout ================= */
.app-container {
    display: flex;
    height: calc(100vh - 56px);
    width: 100%;
    position: relative;
    z-index: 10;
}

.main-content-area {
    flex-grow: 1;
    height: 100%;
    overflow-y: auto;
    min-width: 0;
    padding: 30px;
    background: transparent;
}

/* ================= Glassmorphism Core ================= */
.glass-card {
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border: 1px solid rgba(255, 255, 255, 0.6);
    border-radius: 20px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.glass-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
}

/* ================= 3D Scene (Hero Right) ================= */
.scene {
    width: 100%;
    height: 400px;
    perspective: 1200px;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
}

.floor-shadow {
    position: absolute;
    bottom: 0px;
    width: 250px;
    height: 50px;
    background: radial-gradient(ellipse at center, rgba(230, 100, 150, 0.4) 0%, rgba(0,0,0,0) 70%);
    border-radius: 50%;
    transform: rotateX(70deg);
    filter: blur(15px);
    animation: shadowPulse 6s ease-in-out infinite;
}

.glass-stack {
    position: relative;
    width: 180px;
    height: 240px;
    transform-style: preserve-3d;
    transform: rotateX(60deg) rotateZ(-45deg);
    animation: float3D 6s ease-in-out infinite;
}

.layer {
    position: absolute;
    width: 100%;
    height: 100%;
    border-radius: 24px;
    border: 2px solid rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    box-shadow: inset 0 0 20px rgba(255, 255, 255, 0.5), 0 20px 40px rgba(0, 0, 0, 0.1);
    transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.layer-1 { background: linear-gradient(135deg, rgba(255, 51, 102, 0.4), rgba(255, 102, 153, 0.1)); transform: translateZ(0px); box-shadow: 0 0 50px rgba(255, 51, 102, 0.3); }
.layer-2 { background: linear-gradient(135deg, rgba(255, 204, 0, 0.4), rgba(255, 153, 51, 0.1)); transform: translateZ(45px); }
.layer-3 { background: linear-gradient(135deg, rgba(102, 102, 255, 0.4), rgba(153, 51, 255, 0.1)); transform: translateZ(90px); }
.layer-4 { background: linear-gradient(135deg, rgba(0, 255, 255, 0.5), rgba(0, 153, 255, 0.2)); transform: translateZ(135px); display: flex; justify-content: center; align-items: center; box-shadow: 0 0 40px rgba(0, 255, 255, 0.4); }

.glass-stack:hover .layer-1 { transform: translateZ(-20px); }
.glass-stack:hover .layer-2 { transform: translateZ(40px); }
.glass-stack:hover .layer-3 { transform: translateZ(100px); }
.glass-stack:hover .layer-4 { transform: translateZ(160px); }

.code-icon-3d {
    width: 70px; height: 70px; fill: none; stroke: white; stroke-width: 2.5; stroke-linecap: round; stroke-linejoin: round;
    filter: drop-shadow(0 0 10px rgba(255,255,255,0.8));
    transform: rotateZ(45deg) rotateX(-10deg);
}

/* ================= Specific UI Elements ================= */
.hero-title { font-size: 3.5rem; font-weight: 800; line-height: 1.1; color: #1a1a1a; margin-bottom: 20px; letter-spacing: -1px; }

.search-panel { background: rgba(255, 255, 255, 0.7); border-radius: 50px; padding: 0.5rem; border: 1px solid rgba(255,255,255,0.9); box-shadow: 0 10px 30px rgba(0,0,0,0.05); backdrop-filter: blur(10px); }
.search-input { border: 0; background: transparent; padding-left: 1.5rem; color: #333; font-weight: 500; }
.search-input:focus { box-shadow: none; }
.btn-library { background: #1a1a1a; color: white; font-weight: 600; border-radius: 50px; padding: 10px 30px; transition: all 0.3s; }
.btn-library:hover { background: #ff3366; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 51, 102, 0.3); }

.tag-chip {
    background: rgba(255, 255, 255, 0.6); border: 1px solid rgba(255,255,255,0.8); backdrop-filter: blur(5px);
    border-radius: 50px; color: #333; display: inline-flex; align-items: center; gap: 8px; font-size: 0.85rem; padding: 8px 20px; font-weight: 600; transition: all 0.2s ease;
}
.tag-chip:hover { background: #1a1a1a; color: #fff; transform: translateY(-2px); }
.tag-chip i { color: #ff3366; }

.section-title { font-weight: 700; position: relative; padding-bottom: 0.5rem; margin-bottom: 1.5rem; color: #1a1a1a; }
.icon-box-glass { width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; border-radius: 16px; background: rgba(255,255,255,0.8); margin: 0 auto 15px auto; font-size: 1.5rem; color: #ff3366; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }

/* Infinite Marquee */
.marquee-container { width: 100%; overflow: hidden; padding: 2rem 0; margin-bottom: 2rem; border-top: 1px solid rgba(255,255,255,0.4); border-bottom: 1px solid rgba(255,255,255,0.4); }
.marquee-content { display: inline-flex; white-space: nowrap; animation: slideMarquee 25s linear infinite; }
.marquee-item { font-size: 1.2rem; font-weight: 700; color: rgba(26, 26, 26, 0.4); margin: 0 50px; display: flex; align-items: center; gap: 12px; transition: color 0.3s ease; }
.marquee-item:hover { color: #ff3366; }

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

/* 🤝 Shared Card Ribbon Custom Style */
.sheet-card {
    border: 1px solid #e2e8f0;
    border-radius: 20px;
    background: white;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.02);
    transition: all 0.3s ease;
}
.sheet-card:hover {
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

.pill-public { background-color: #d1e7dd; color: #0f5132; }
.pill-friends { background-color: #cff4fc; color: #055160; }
.pill-private { background-color: #f8d7da; color: #842029; }

/* Admin Charts Box */
.chart-box-container { position: relative; margin: auto; height: 180px; width: 180px; }

/* Animations */
@keyframes float3D {
    0% { transform: rotateX(60deg) rotateZ(-45deg) translateZ(0px); }
    50% { transform: rotateX(60deg) rotateZ(-45deg) translateZ(25px); }
    100% { transform: rotateX(60deg) rotateZ(-45deg) translateZ(0px); }
}
@keyframes shadowPulse {
    0% { transform: rotateX(70deg) scale(1); opacity: 0.6; }
    50% { transform: rotateX(70deg) scale(1.2); opacity: 0.3; }
    100% { transform: rotateX(70deg) scale(1); opacity: 0.6; }
}
@keyframes slideMarquee { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }
@keyframes slideUpFade { 0% { opacity: 0; transform: translateY(30px); } 100% { opacity: 1; transform: translateY(0); } }

.anim-1 { opacity: 0; animation: slideUpFade 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards 0.1s; }
.anim-2 { opacity: 0; animation: slideUpFade 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards 0.3s; }
.anim-3 { opacity: 0; animation: slideUpFade 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards 0.5s; }
</style>
</head>
<body>

    <canvas id="particles"></canvas>

    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <div class="main-content-area">

            <%-- 🔐 Role-Based Switching Logic --%>
            <c:choose>
                <%-- 🌟 ADMIN VIEW (Glassmorphism) --%>
                <c:when test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
                    <div class="mb-5 text-center mt-3 anim-1">
                        <h2 class="fw-bold mb-2 text-dark"><i class="bi bi-speedometer2 text-danger me-2"></i>Admin Dashboard</h2>
                        <div class="text-muted small fw-medium">Real-time platform metrics in 3D Glass Space</div>
                    </div>

                    <div class="row g-4 justify-content-center">
                        <div class="col-md-4 anim-2">
                            <div class="glass-card p-4 text-center h-100">
                                <h6 class="text-muted fw-bold mb-3"><i class="bi bi-people-fill me-2" style="color: #ff3366;"></i>Total Users</h6>
                                <div class="chart-box-container"><canvas id="usersCircleChart"></canvas></div>
                                <div class="fs-3 fw-bold mt-3 text-dark"><c:out value="${not empty totalUsers ? totalUsers : (not empty summary.totalUsers ? summary.totalUsers : 0)}" /></div>
                            </div>
                        </div>
                        <div class="col-md-4 anim-3">
                            <div class="glass-card p-4 text-center h-100">
                                <h6 class="text-muted fw-bold mb-3"><i class="bi bi-tags-fill me-2" style="color: #ffcc00;"></i>Total Categories</h6>
                                <div class="chart-box-container"><canvas id="categoriesCircleChart"></canvas></div>
                                <div class="fs-3 fw-bold mt-3 text-dark"><c:out value="${not empty categorylist ? categorylist.size() : 0}" /></div>
                            </div>
                        </div>
                        <div class="col-md-4 anim-3">
                            <div class="glass-card p-4 text-center h-100">
                                <h6 class="text-muted fw-bold mb-3"><i class="bi bi-file-earmark-code-fill me-2" style="color: #00ccff;"></i>Cheat Sheets</h6>
                                <div class="chart-box-container"><canvas id="sheetsCircleChart"></canvas></div>
                                <div class="fs-3 fw-bold mt-3 text-dark">
                                    <c:out value="${not empty totalSheets ? totalSheets : (not empty summary.totalCheatsheets ? summary.totalCheatsheets : 0)}" />
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- 🌟 REGULAR USER / GUEST VIEW (3D Glass Theme) --%>
                <c:otherwise>
                    <%-- Hero Section --%>
                    <div class="container-fluid mb-5 pt-4">
                        <div class="row align-items-center min-vh-50">
                            <div class="col-lg-6 col-xl-7 text-center text-lg-start mb-5 mb-lg-0">
                                <div class="badge bg-white text-dark rounded-pill px-3 py-2 mb-3 shadow-sm border anim-1 fw-bold">🚀 The ultimate developer library</div>
                                <h1 class="hero-title anim-1">Master Code with<br><span style="color: #ff3366;">3D CheatSheets</span></h1>
                                <p class="fs-6 text-muted mb-4 anim-2" style="max-width: 500px;">
                                    Unify your programming knowledge with our beautiful, high-performance community references. Search fast, code faster.
                                </p>
                                
                                <div class="anim-3">
                                    <form action="${pageContext.request.contextPath}/home" method="get" class="search-panel d-flex shadow-sm">
                                        <span class="input-group-text bg-transparent border-0"><i class="bi bi-search" style="color: #ff3366;"></i></span>
                                        <input type="search" class="form-control search-input" name="q" value="${searchQuery}" placeholder="What do you want to learn today?">
                                        <button class="btn btn-library" type="submit">Search</button>
                                    </form>
                                </div>
                                
                                <div class="d-flex flex-wrap justify-content-center justify-content-lg-start gap-3 mt-4 anim-3">
                                    <a class="tag-chip" href="${pageContext.request.contextPath}/${not empty sessionScope.currentUser ? 'cheatsheet/add' : 'login'}">
                                        <i class="bi bi-plus-lg"></i> Create
                                    </a>
                                    <a class="tag-chip" href="${pageContext.request.contextPath}/announcements"><i class="bi bi-bell-fill"></i> Announcements</a>
                                    <a class="tag-chip" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-fill"></i> Profile</a>
                                </div>
                            </div>
                            
                            <div class="col-lg-6 col-xl-5 anim-2 d-none d-md-block">
                                <div class="scene">
                                    <div class="floor-shadow"></div>
                                    <div class="glass-stack">
                                        <div class="layer layer-1"></div>
                                        <div class="layer layer-2"></div>
                                        <div class="layer layer-3"></div>
                                        <div class="layer layer-4">
                                            <svg class="code-icon-3d" viewBox="0 0 24 24">
                                                <polyline points="16 18 22 12 16 6"></polyline>
                                                <polyline points="8 6 2 12 8 18"></polyline>
                                            </svg>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Infinite Marquee --%>
                    <div class="marquee-container anim-3">
                        <div class="marquee-content">
                            <div class="marquee-item"><i class="bi bi-file-code text-danger"></i> JDBC Template</div>
                            <div class="marquee-item"><i class="bi bi-cup-hot text-warning"></i> Java Core</div>
                            <div class="marquee-item"><i class="bi bi-database text-info"></i> MySQL</div>
                            <div class="marquee-item"><i class="bi bi-box-seam text-success"></i> Spring Boot</div>
                            <div class="marquee-item"><i class="bi bi-github text-dark"></i> Version Control</div>
                            <div class="marquee-item"><i class="bi bi-file-code text-danger"></i> JDBC Template</div>
                            <div class="marquee-item"><i class="bi bi-cup-hot text-warning"></i> Java Core</div>
                            <div class="marquee-item"><i class="bi bi-database text-info"></i> MySQL</div>
                            <div class="marquee-item"><i class="bi bi-box-seam text-success"></i> Spring Boot</div>
                            <div class="marquee-item"><i class="bi bi-github text-dark"></i> Version Control</div>
                        </div>
                    </div>

                    <%-- Categories (Glass Cards) --%>
                    <section class="mb-5 anim-3" id="categories">
                        <h2 class="section-title h4 mb-4">Browse Categories</h2>
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                            <c:forEach items="${categorylist}" var="c">
                                <div class="col">
                                    <a href="${pageContext.request.contextPath}/cheatsheet/category/${c.obfuscatedId}" class="glass-card d-block p-4 text-center text-decoration-none h-100">
                                        <div class="icon-box-glass"><i class="bi bi-grid-1x2-fill"></i></div>
                                        <h5 class="fw-bold text-dark mb-0">${c.name}</h5>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </section>

                    <%-- 🌟 [SHARED CHEAT SHEETS SECTION] မင်းသူငယ်ချင်းရဲ့ သီးသန့် Shared Post Feed --%>
                    <c:if test="${not empty sharedPosts}">
                        <section class="mb-5 anim-3">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <div>
                                    <h2 class="section-title h4 mb-1">Shared Cheat Sheets</h2>
                                    <div class="text-muted small">Posts shared by the community.</div>
                                </div>
                            </div>
                            
                            <div class="d-grid gap-3">
                                <c:forEach items="${sharedPosts}" var="share">
                                    <article class="sheet-card d-flex border-info">
                                        <div class="sheet-ribbon p-3 d-flex flex-lg-column align-items-center justify-content-center gap-1 bg-info bg-opacity-10 border-info">
                                            <div class="sheet-pages"><i class="bi bi-share-fill text-info"></i></div>
                                        </div>
                                        <div class="p-3 p-lg-4 flex-grow-1">
                                            <div class="mb-3 text-muted small bg-light p-2 rounded d-inline-block">
                                                <i class="bi bi-arrow-return-right text-info"></i>
                                                <strong class="text-dark"><c:out value="${share.user.fullName != null ? share.user.fullName : share.user.username}" /></strong> shared 
                                                <strong><c:out value="${share.cheatsheet.author.fullName != null ? share.cheatsheet.author.fullName : share.cheatsheet.author.username}" /></strong>'s post
                                            </div>
                                            
                                            <h3 class="h5 fw-bold mb-2">
                                                <a href="${pageContext.request.contextPath}/cheatsheet/detail/${share.cheatsheet.obfuscatedId}" class="text-dark hover-link text-decoration-none">
                                                    ${share.cheatsheet.title}
                                                </a>
                                            </h3>
                                            <p class="text-secondary small mb-3">${share.cheatsheet.description}</p>

                                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 pt-2 border-top">
                                                <div class="d-flex flex-wrap gap-1">
                                                    <span class="tag-chip"><i class="bi bi-folder-fill text-secondary"></i> ${share.cheatsheet.category.name}</span>
                                                    <span class="tag-chip"><i class="bi bi-eye-fill text-secondary"></i> ${share.cheatsheet.viewCount != null ? share.cheatsheet.viewCount : 0}</span>
                                                </div>
                                                <a class="btn btn-outline-info btn-sm px-4 fw-bold" href="${pageContext.request.contextPath}/cheatsheet/detail/${share.cheatsheet.obfuscatedId}">View Post</a>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </section>
                    </c:if>

                    <%-- 🌟 [UPDATED SPLIT GRID] Latest Feed (ဘယ်ဘက်) နှင့် Popular Feed (ညာဘက်) စနစ် --%>
                    <div class="row g-4 mb-5 anim-3">
                        
                        <%-- ⬅️ LEFT SIDE: LATEST CHEAT SHEETS --%>
                        <div class="col-12 col-lg-6">
                            <h2 class="section-title h4 mb-4">Latest Cheat Sheets</h2>
                            <div class="row row-cols-1">
                                <c:forEach items="${cheatsheetlist}" var="sheet">
                                    <div class="col">
                                        <div class="cheatsheet-card">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h5 class="fw-bold m-0">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.obfuscatedId}" class="text-dark text-decoration-none hover-underline fs-5">
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
                                                <div class="d-flex flex-wrap gap-2">
                                                    <span class="tag-chip py-1 px-2 border-0 bg-transparent fs-7"><i class="bi bi-eye text-muted me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                    <span class="tag-chip py-1 px-2 border-0 bg-transparent fs-7"><i class="bi bi-download text-muted me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                                    <span class="tag-chip py-1 px-2 border-0 bg-transparent fs-7 text-success"><i class="bi bi-share-fill"></i> ${sheet.shareCount != null ? sheet.shareCount : 0}</span>
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                                       target="_blank" 
                                                       class="btn btn-sm btn-outline-danger px-3 py-1 d-flex align-items-center gap-1 fw-bold"
                                                       style="border-radius: 8px; font-size: 13px;">
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
                        <div class="col-12 col-lg-6">
                            <h2 class="section-title h4 mb-4">Popular Cheat Sheets</h2>
                            <div class="row row-cols-1">
                                <c:forEach items="${popularCheatsheets}" var="sheet">
                                    <div class="col">
                                        <div class="cheatsheet-card">
                                            <div>
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h5 class="fw-bold m-0">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.obfuscatedId}" class="text-dark text-decoration-none hover-underline fs-5">
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
                                                <div class="d-flex flex-wrap gap-2">
                                                    <span class="tag-chip py-1 px-2 border-0 bg-transparent fs-7"><i class="bi bi-eye text-muted me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                    <span class="tag-chip py-1 px-2 border-0 bg-transparent fs-7"><i class="bi bi-download text-muted me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                                       target="_blank" 
                                                       class="btn btn-sm btn-outline-danger px-3 py-1 d-flex align-items-center gap-1 fw-bold"
                                                       style="border-radius: 8px; font-size: 13px;">
                                                         <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div> <%-- /row [Split Grid] --%>

                    <%-- 📄 [PAGINATION] မင်းသူငယ်ချင်းရဲ့ Pagination Logic Block --%>
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4 mb-5" aria-label="Cheat sheet pagination">
                            <ul class="pagination justify-content-center flex-wrap">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage - 1}&q=${searchQuery}">Previous</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/home?page=${p}&q=${searchQuery}">${p}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/home?page=${currentPage + 1}&q=${searchQuery}">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>

                    <jsp:include page="footer.jsp" />
                </c:otherwise>
            </c:choose>

        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <%-- 🌌 Particle Canvas Effect Script --%>
    <script>
        const canvas = document.getElementById('particles');
        const ctx = canvas.getContext('2d');

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        window.addEventListener('resize', resizeCanvas);
        resizeCanvas();

        const particlesArray = [];
        const numberOfParticles = 60; 

        class Particle {
            constructor() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.size = Math.random() * 2.5 + 0.5; 
                this.speedX = Math.random() * 1 - 0.5; 
                this.speedY = Math.random() * -1.5 - 0.5; 
                this.color = `rgba(${Math.floor(Math.random() * 100 + 155)}, ${Math.floor(Math.random() * 50 + 50)}, ${Math.floor(Math.random() * 150 + 100)}, ${Math.random() * 0.4 + 0.1})`;
            }
            update() {
                this.x += this.speedX;
                this.y += this.speedY;
                if (this.y < 0) {
                    this.y = canvas.height;
                    this.x = Math.random() * canvas.width;
                }
            }
            draw() {
                ctx.fillStyle = this.color;
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fill();
                ctx.shadowBlur = 8;
                ctx.shadowColor = this.color;
            }
        }

        for (let i = 0; i < numberOfParticles; i++) { particlesArray.push(new Particle()); }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < particlesArray.length; i++) {
                particlesArray[i].update();
                particlesArray[i].draw();
            }
            requestAnimationFrame(animate);
        }
        animate();
    </script>

    <%-- 📊 Admin Circle Charts Script --%>
    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
        <script>
            const valUsers = ${not empty totalUsers ? totalUsers : (not empty summary.totalUsers ? summary.totalUsers : 0)};
            const valCategories = ${not empty categorylist ? categorylist.size() : 0};
            const valSheets = ${not empty totalSheets ? totalSheets : (not empty summary.totalCheatsheets ? summary.totalCheatsheets : 0)};

            const globalChartConfig = { 
                responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } }, cutout: '75%',
                elements: { arc: { borderWidth: 0 } }
            };

            new Chart(document.getElementById('usersCircleChart'), {
                type: 'doughnut',
                data: { datasets: [{ data: [valUsers, valUsers == 0 ? 1 : 0], backgroundColor: ['#ff3366', 'rgba(255,255,255,0.4)'] }] },
                options: globalChartConfig
            });

            new Chart(document.getElementById('categoriesCircleChart'), {
                type: 'doughnut',
                data: { datasets: [{ data: [valCategories, valCategories == 0 ? 1 : 0], backgroundColor: ['#ffcc00', 'rgba(255,255,255,0.4)'] }] },
                options: globalChartConfig
            });

            new Chart(document.getElementById('sheetsCircleChart'), {
                type: 'doughnut',
                data: { datasets: [{ data: [valSheets, valSheets == 0 ? 1 : 0], backgroundColor: ['#00ccff', 'rgba(255,255,255,0.4)'] }] },
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