<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - CheatSheet Library</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        :root {
            --page-bg: #f8f9fa;
            --card-bg: #ffffff;
            --text-dark: #212529;
            --text-muted: #6c757d;
            --line-color: #dee2e6;
            
            /* Professional Developer Palette */
            --brand-primary: #1976d2;
            --brand-dark: #0d47a1;
            --accent-green: #2e7d32;
            --accent-teal: #00796b;
            --accent-amber: #f57c00;
        }

        /* Prevent main window scrolling; handle scroll inside the content area */
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            background-color: var(--page-bg);
            color: var(--text-dark);
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        }

        a { color: var(--brand-primary); text-decoration: none; }
        a:hover { color: var(--brand-dark); }

        /* App Layout Containers */
        .navbar {
            height: 56px;
            z-index: 1030;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
        }

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

        .hero-title {
            font-size: clamp(2rem, 3.5vw, 3rem);
            font-weight: 800;
        }

        /* Interactive Components */
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

        /* Section Titles */
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

        /* Feature Cards & Tiles */
        .feature-card, .sheet-card, .notice-card, .empty-panel {
            border: 1px solid var(--line-color);
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
        }

        .feature-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-decoration: none;
            display: block;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.12);
            border-color: rgba(25, 118, 210, 0.2);
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

        .icon-box i {
            font-size: 28px;
        }

        /* Sheet Cards styling */
        .sheet-card {
            overflow: hidden;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .sheet-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            border-color: rgba(25, 118, 210, 0.2);
        }

        .sheet-ribbon {
            background: #f1f3f5;
            border-right: 1px solid var(--line-color);
            min-width: 85px;
            text-align: center;
        }

        .sheet-pages {
            color: var(--brand-primary);
            font-size: 1.75rem;
            font-weight: 800;
            line-height: 1;
        }

        .author-chip, .tag-chip {
            border: 1px solid var(--line-color);
            background: #f8f9fa;
            border-radius: 50px;
            color: var(--text-muted);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.82rem;
            padding: 4px 12px;
            text-decoration: none;
        }
        
        a.author-chip:hover {
            background-color: #e9ecef;
            color: var(--brand-primary);
        }

        .notice-card {
            background: #fff9db;
            border-color: #ffe066;
        }

        .notice-mark {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--accent-amber);
            color: white;
            flex: 0 0 36px;
        }

        .empty-panel {
            border: 2px dashed var(--line-color);
            background: rgba(255,255,255,0.5);
        }

        .page-link {
            color: var(--brand-primary);
            border-color: var(--line-color);
        }

        .page-item.active .page-link {
            background-color: var(--brand-primary);
            border-color: var(--brand-primary);
        }

        .shadow-inner {
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.06);
        }

        @media (max-width: 991.98px) {
            .sheet-card { flex-direction: column; }
            .sheet-ribbon {
                border-right: 0;
                border-bottom: 1px solid var(--line-color);
                min-width: 100%;
                padding: 1rem !important;
            }
        }
    </style>
</head>
<body>

    <%-- 🧩 Header Component --%>
    <jsp:include page="header.jsp" />

    <%-- 🌐 Main Application View Frame Wrapper --%>
    <div class="app-container">

        <%-- 🛠️ Sidebar Component --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

        <%-- 🌐 Scrollable Work Content Context Panel --%>
        <div class="main-content-area">

            <%-- 🚀 Hero Banner Section --%>
            <header class="hero-section mb-4">
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
                                <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/cheatsheet/add"><i class="bi bi-plus-circle-fill text-primary"></i> Create</a>
                                <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone-fill text-warning"></i> Announcements</a>
                                <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-circle text-info"></i> Profile</a>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            <%-- 🔐 Admin Stat-Widgets Block --%>
            <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
                <div class="row g-4 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white h-100">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle bg-primary-subtle text-primary d-flex align-items-center justify-content-center fw-bold fs-3 shadow-inner" 
                                     style="width: 75px; height: 75px; flex-shrink: 0;">
                                    <c:out value="${not empty categorylist ? categorylist.size() : 0}" />
                                </div>
                                <div class="ms-3">
                                    <div class="text-secondary small fw-bold text-uppercase tracking-wider">Categories</div>
                                    <h5 class="fw-bold text-dark mb-0 mt-1">
                                        <i class="bi bi-tags-fill me-1 text-primary small"></i> Total Structs
                                    </h5>
                                </div>
                            </div>
                        </div>
                    </div>
    
                    <div class="col-12 col-md-4">
                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white h-100">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle bg-warning-subtle text-warning d-flex align-items-center justify-content-center fw-bold fs-3" 
                                     style="width: 75px; height: 75px; flex-shrink: 0;">
                                    <c:out value="${not empty totalTags ? totalTags : 0}" />
                                </div>
                                <div class="ms-3">
                                    <div class="text-secondary small fw-bold text-uppercase tracking-wider">Tags</div>
                                    <h5 class="fw-bold text-dark mb-0 mt-1">
                                        <i class="bi bi-bookmark-star-fill me-1 text-warning small"></i> Keywords
                                    </h5>
                                </div>
                            </div>
                        </div>
                    </div>
    
                    <div class="col-12 col-md-4">
                        <div class="card border-0 shadow-sm rounded-3 p-3 bg-white h-100">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle bg-success-subtle text-success d-flex align-items-center justify-content-center fw-bold fs-3" 
                                     style="width: 75px; height: 75px; flex-shrink: 0;">
                                    <c:out value="${not empty totalSheets ? totalSheets : 0}" />
                                </div>
                                <div class="ms-3">
                                    <div class="text-secondary small fw-bold text-uppercase tracking-wider">Cheat Sheets</div>
                                    <h5 class="fw-bold text-dark mb-0 mt-1">
                                        <i class="bi bi-file-earmark-code-fill me-1 text-success small"></i> Live Codes
                                    </h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <%-- 📂 Browse Categories Layout Wrapper Grid Section --%>
            <section class="mb-5" id="categories">
                <div class="d-flex align-items-end justify-content-between mb-4">
                    <div>
                        <h2 class="section-title h4 mb-1">Browse Categories</h2>
                        <div class="text-muted small">Explore system structural references by standard topics.</div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty categorylist}">
                        <div class="empty-panel text-center p-5 text-muted">
                            <i class="bi bi-folder-x display-4 d-block mb-3 text-secondary"></i> 
                            No categories available at the moment.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                            <c:forEach items="${categorylist}" var="c">
                                <div class="col">
                                    <a href="${pageContext.request.contextPath}/cheatsheet/category/${c.id}"
                                       class="card feature-card h-100 p-4 text-center bg-white">
                                        <div class="icon-box">
                                            <i class="bi bi-layers-half text-primary"></i>
                                        </div>
                                        <div class="card-body p-0">
                                            <h5 class="card-title fw-bold text-dark mb-2">${c.name}</h5>
                                            <p class="card-text text-secondary small mb-0">
                                                Browse all cheat sheets from this category.
                                            </p>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <div class="row g-4">
                <%-- Main Feeds Left Hand Section Block --%>
                <div class="col-lg-12">
                    
                    <%-- Announcements Layout List --%>
                    <c:if test="${not empty announcements}">
                        <div class="mb-5">
                            <h2 class="section-title h4 mb-4">Announcements</h2>
                            <div class="d-grid gap-3">
                                <c:forEach items="${announcements}" var="a">
                                    <article class="notice-card p-3">
                                        <div class="d-flex gap-3">
                                            <span class="notice-mark"><i class="bi bi-megaphone-fill"></i></span>
                                            <div>
                                                <h3 class="h6 fw-bold mb-1 text-dark">${a.title}</h3>
                                                <p class="text-secondary small mb-2">${a.content}</p>
                                                <div class="text-muted small style-meta">
                                                    <i class="bi bi-person me-1"></i>
                                                    <c:out value="${a.createdBy != null ? (a.createdBy.fullName != null ? a.createdBy.fullName : a.createdBy.username) : 'Admin'}" />
                                                    <span class="mx-2">/</span>
                                                    <i class="bi bi-clock me-1"></i>${a.createdAt}
                                                </div>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <%-- Latest Public Cheat Sheets Sub Grid Block --%>
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div>
                            <h2 class="section-title h4 mb-1">Latest Cheat Sheets</h2>
                            <div class="text-muted small">Newest public references listed first.</div>
                        </div>
                        <span class="tag-chip bg-white fw-semibold">Page ${currentPage} of ${totalPages}</span>
                    </div>

                    <c:choose>
                        <c:when test="${empty cheatsheetlist}">
                            <div class="empty-panel text-center p-5">
                                <i class="bi bi-journal-x display-5 d-block mb-3 text-secondary"></i>
                                <div class="fw-bold">No cheat sheets found</div>
                                <div class="text-muted small">Try another search keyword or browse a category.</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-grid gap-3">
                                <c:forEach items="${cheatsheetlist}" var="sheet">
                                    <article class="sheet-card d-flex">
                                        <div class="sheet-ribbon p-3 d-flex flex-lg-column align-items-center justify-content-center gap-1">
                                            <div class="sheet-pages">1</div>
                                            <div class="text-muted small fw-bold text-uppercase" style="font-size: 0.7rem; letter-spacing: 0.5px;">Page</div>
                                        </div>
                                        <div class="p-3 p-lg-4 flex-grow-1">
                                            <div class="d-flex flex-wrap justify-content-between gap-2 mb-3">
                                                <c:choose>
                                                    <c:when test="${not empty sheet.author}">
                                                        <a class="author-chip" href="${pageContext.request.contextPath}/profile/${sheet.author.id}">
                                                            <i class="bi bi-person-fill text-primary"></i>
                                                            <c:out value="${sheet.author.fullName != null ? sheet.author.fullName : sheet.author.username}" />
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="author-chip"><i class="bi bi-person-fill"></i> Anonymous</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="tag-chip border-0 bg-transparent"><i class="bi bi-calendar3"></i> ${sheet.createdAt}</span>
                                            </div>

                                            <h3 class="h5 fw-bold mb-2">
                                                <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark hover-link">
                                                    ${sheet.title}
                                                </a>
                                            </h3>
                                            <p class="text-secondary small mb-3">${sheet.description}</p>

                                            <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 pt-2 border-top">
                                                <div class="d-flex flex-wrap gap-1">
                                                    <span class="tag-chip"><i class="bi bi-folder-fill text-secondary"></i> ${sheet.category.name}</span>
                                                    <span class="tag-chip"><i class="bi bi-eye-fill text-secondary"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                    <span class="tag-chip"><i class="bi bi-download text-secondary"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                                    <span class="tag-chip text-success border-success-subtle bg-success-subtle bg-opacity-10"><i class="bi bi-share-fill"></i> ${sheet.shareCount != null ? sheet.shareCount : 0}</span>
                                                </div>
                                                <a class="btn btn-library btn-sm px-4" href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}">Open</a>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>

                            <%-- Pagination logic blocks --%>
                            <c:if test="${totalPages > 1}">
                                <nav class="mt-4" aria-label="Cheat sheet pagination">
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
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- 🧩 Footer Component Include inside Content Area --%>
            <jsp:include page="footer.jsp" />

        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>