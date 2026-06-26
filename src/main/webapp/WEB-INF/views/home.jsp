<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        body {
            background-color: var(--page-bg);
            color: var(--text-dark);
            font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        a { color: var(--brand-primary); text-decoration: none; }
        a:hover { color: var(--brand-dark); }

        /* Hero Banner Section */
        .hero-section {
            background: linear-gradient(135deg, var(--brand-dark) 0%, var(--brand-primary) 100%);
            padding: 5rem 0;
            color: white;
            border-radius: 0 0 24px 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        .hero-title {
            font-size: clamp(2.2rem, 4vw, 3.5rem);
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

        /* Content Blocks */
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

        .category-tile, .sheet-card, .side-panel, .notice-card {
            border: 1px solid var(--line-color);
            background: var(--card-bg);
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.02);
        }

        /* Category Tiles */
        .category-tile {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            color: inherit;
        }

        .category-tile:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 20px rgba(25, 118, 210, 0.1);
            border-color: rgba(25, 118, 210, 0.3);
        }

        .category-icon {
            width: 46px;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            color: white;
            background: var(--brand-primary);
            flex: 0 0 46px;
        }

        /* Cycle badge/icon background colors organically */
        .category-tile:nth-child(2n) .category-icon { background: var(--accent-green); }
        .category-tile:nth-child(3n) .category-icon { background: var(--accent-teal); }
        .category-tile:nth-child(4n) .category-icon { background: var(--accent-amber); }

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

        /* Sidebar Sticky Alignment */
        .side-panel-wrapper {
            position: sticky;
            top: 24px;
        }

        .side-link {
            border-bottom: 1px solid var(--line-color);
            color: var(--text-dark);
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            transition: padding-left 0.2s ease;
        }

        .side-link:last-child { border-bottom: 0; }
        .side-link:hover { padding-left: 6px; color: var(--brand-primary); }

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
            border-radius: 12px;
        }

        .page-link {
            color: var(--brand-primary);
            border-color: var(--line-color);
        }

        .page-item.active .page-link {
            background-color: var(--brand-primary);
            border-color: var(--brand-primary);
        }

        .main-content {
            flex: 1;
        }

        @media (max-width: 991.98px) {
            .side-panel-wrapper { position: static; }
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

    <jsp:include page="header.jsp" />

    <header class="hero-section mb-5">
        <div class="container text-center text-lg-start">
            <div class="row g-4 align-items-center">
                <div class="col-lg-7">
                    <div class="text-uppercase small fw-bold tracking-wider mb-2 opacity-75">Quick references for every topic</div>
                    <h1 class="hero-title mb-3">Developer Cheat Sheets</h1>
                    <p class="fs-5 opacity-90 mb-0">
                        Browse community cheat sheets, search fast, and jump into the newest references first.
                    </p>
                </div>
                <div class="col-lg-5">
                    <form action="${pageContext.request.contextPath}/home" method="get" class="search-panel shadow-sm">
                        <div class="input-group">
                            <span class="input-group-text bg-transparent border-0"><i class="bi bi-search text-muted"></i></span>
                            <input type="search" class="form-control search-input" name="q" value="${searchQuery}" placeholder="Search cheat sheets...">
                            <button class="btn btn-library px-4" type="submit">Search</button>
                        </div>
                    </form>
                    <div class="d-flex flex-wrap justify-content-center justify-content-lg-start gap-2 mt-3">
                        <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/cheatsheet/add"><i class="bi bi-plus-circle-fill text-primary"></i> Create</a>
                        <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone-fill text-warning"></i> Announcements</a>
                        <a class="tag-chip bg-white text-dark shadow-sm" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-circle text-info"></i> Profile</a>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <main class="container main-content pb-5">
        
        <section class="mb-5" id="categories">
            <div class="d-flex align-items-end justify-content-between mb-4">
                <h2 class="section-title h4 mb-0">Browse Categories</h2>
                <span class="text-muted small">Find references by topic</span>
            </div>

            <c:choose>
                <c:when test="${empty categorylist}">
                    <div class="empty-panel text-center p-5 text-muted">
                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                        No categories available yet.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-3">
                        <c:forEach items="${categorylist}" var="cat">
                            <div class="col-md-6 col-xl-4">
                                <a href="${pageContext.request.contextPath}/cheatsheet/category/${cat.id}" class="category-tile d-flex gap-3 align-items-center p-3 h-100">
                                    <span class="category-icon"><i class="bi bi-journal-code"></i></span>
                                    <div>
                                        <span class="d-block fw-bold text-dark">${cat.name}</span>
                                        <span class="d-block text-muted small">View ${cat.name} references</span>
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <div class="row g-4">
            
            <section class="col-lg-8">
                
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
                                            </div>
                                            <a class="btn btn-library btn-sm px-4" href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}">Open</a>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>

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
            </section>

            <aside class="col-lg-4">
                <div class="side-panel-wrapper d-grid gap-4">
                    
                    <div class="side-panel p-3 p-lg-4">
                        <h2 class="section-title h5 mb-3">Quick Browse</h2>
                        <c:choose>
                            <c:when test="${empty categorylist}">
                                <div class="text-muted small">No browse links available.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="d-flex flex-column">
                                    <c:forEach items="${categorylist}" var="cat">
                                        <a class="side-link" href="${pageContext.request.contextPath}/cheatsheet/category/${cat.id}">
                                            <span>${cat.name}</span>
                                            <i class="bi bi-chevron-right small text-muted"></i>
                                        </a>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="side-panel p-3 p-lg-4">
                        <h2 class="section-title h5 mb-3">Library Tools</h2>
                        <div class="d-grid gap-2">
                            <a class="btn btn-library" href="${pageContext.request.contextPath}/cheatsheet/add">
                                <i class="bi bi-plus-circle me-2"></i>Create Cheat Sheet
                            </a>
                            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/cheatsheet/list">
                                <i class="bi bi-collection me-2"></i>Manage Sheets
                            </a>
                            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/notifications">
                                <i class="bi bi-bell me-2"></i>Notifications
                            </a>
                        </div>
                    </div>
                    
                </div>
            </aside>
        </div>
    </main>

    <jsp:include page="footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>