<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CheatSheet Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --page-bg: #f5f3ee;
            --ink: #28231f;
            --muted: #776f66;
            --paper: #ffffff;
            --paper-soft: #fbfaf7;
            --line: #ddd6ca;
            --brand: #b64a2f;
            --brand-dark: #873521;
            --gold: #d9a441;
            --green: #2f765d;
            --blue: #386b9b;
        }

        body {
            background:
                radial-gradient(circle at 20% 0%, rgba(217, 164, 65, .14), transparent 30%),
                linear-gradient(180deg, #faf8f3 0%, var(--page-bg) 55%, #eee9df 100%);
            color: var(--ink);
            font-family: Georgia, "Times New Roman", serif;
        }

        a { color: var(--brand-dark); }
        a:hover { color: var(--brand); }

        .library-shell {
            max-width: 1180px;
        }

        .library-hero {
            border: 1px solid var(--line);
            background: linear-gradient(135deg, #fff 0%, #fbf3e2 100%);
            border-radius: 8px;
            box-shadow: 0 16px 40px rgba(82, 59, 34, .08);
        }

        .hero-title {
            font-size: clamp(2rem, 4vw, 3.6rem);
            line-height: 1;
            letter-spacing: 0;
        }

        .hero-copy,
        .meta-text {
            color: var(--muted);
            font-family: "Segoe UI", Tahoma, sans-serif;
        }

        .search-panel {
            border: 1px solid var(--line);
            background: var(--paper);
            border-radius: 8px;
        }

        .search-input {
            border: 0;
            background: transparent;
            font-family: "Segoe UI", Tahoma, sans-serif;
        }

        .search-input:focus {
            box-shadow: none;
        }

        .btn-library {
            --bs-btn-bg: var(--brand);
            --bs-btn-border-color: var(--brand);
            --bs-btn-hover-bg: var(--brand-dark);
            --bs-btn-hover-border-color: var(--brand-dark);
            --bs-btn-color: #fff;
            --bs-btn-hover-color: #fff;
            border-radius: 6px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            font-weight: 700;
        }

        .section-title {
            border-bottom: 3px double var(--line);
            font-weight: 700;
            letter-spacing: 0;
        }

        .category-tile,
        .sheet-card,
        .side-panel,
        .notice-card {
            border: 1px solid var(--line);
            background: var(--paper);
            border-radius: 8px;
        }

        .category-tile {
            min-height: 96px;
            text-decoration: none;
            transition: transform .18s ease, box-shadow .18s ease, border-color .18s ease;
        }

        .category-tile:hover {
            transform: translateY(-2px);
            border-color: rgba(182, 74, 47, .45);
            box-shadow: 0 12px 26px rgba(82, 59, 34, .08);
        }

        .category-icon {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            color: #fff;
            background: var(--brand);
            flex: 0 0 42px;
        }

        .category-tile:nth-child(2n) .category-icon { background: var(--green); }
        .category-tile:nth-child(3n) .category-icon { background: var(--blue); }
        .category-tile:nth-child(4n) .category-icon { background: var(--gold); color: #372716; }

        .sheet-card {
            overflow: hidden;
            transition: border-color .18s ease, box-shadow .18s ease;
        }

        .sheet-card:hover {
            border-color: rgba(182, 74, 47, .45);
            box-shadow: 0 14px 30px rgba(82, 59, 34, .09);
        }

        .sheet-ribbon {
            background: #efe6d8;
            border-right: 1px solid var(--line);
            min-width: 92px;
            text-align: center;
        }

        .sheet-pages {
            color: var(--brand-dark);
            font-size: 1.65rem;
            line-height: 1;
            font-weight: 800;
        }

        .sheet-title {
            font-size: 1.24rem;
            line-height: 1.25;
        }

        .sheet-description {
            color: #5f564e;
            font-family: "Segoe UI", Tahoma, sans-serif;
        }

        .author-chip,
        .tag-chip {
            border: 1px solid var(--line);
            background: var(--paper-soft);
            border-radius: 999px;
            color: var(--muted);
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-family: "Segoe UI", Tahoma, sans-serif;
            font-size: .82rem;
            padding: 5px 10px;
            text-decoration: none;
        }

        .side-panel {
            position: sticky;
            top: 84px;
        }

        .side-link {
            border-bottom: 1px solid #eee6dc;
            color: var(--ink);
            display: flex;
            justify-content: space-between;
            padding: 9px 0;
            text-decoration: none;
            font-family: "Segoe UI", Tahoma, sans-serif;
        }

        .side-link:last-child {
            border-bottom: 0;
        }

        .notice-card {
            background: #fffaf0;
        }

        .notice-mark {
            width: 34px;
            height: 34px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: var(--gold);
            color: #372716;
            flex: 0 0 34px;
        }

        .empty-panel {
            border: 1px dashed var(--line);
            background: rgba(255,255,255,.62);
            border-radius: 8px;
        }

        .page-link {
            color: var(--brand-dark);
            border-color: var(--line);
            font-family: "Segoe UI", Tahoma, sans-serif;
        }

        .page-item.active .page-link {
            background: var(--brand);
            border-color: var(--brand);
        }

        @media (max-width: 991.98px) {
            .side-panel { position: static; }
            .sheet-card { flex-direction: column; }
            .sheet-ribbon {
                border-right: 0;
                border-bottom: 1px solid var(--line);
                min-width: 100%;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <main class="container library-shell py-4 py-lg-5">
        <section class="library-hero p-4 p-lg-5 mb-4">
            <div class="row g-4 align-items-center">
                <div class="col-lg-7">
                    <div class="meta-text fw-bold text-uppercase small mb-2">Quick references for every topic</div>
                    <h1 class="hero-title fw-bold mb-3">CheatSheet Library</h1>
                    <p class="hero-copy fs-5 mb-0">
                        Browse community cheat sheets, search fast, and jump into the newest references first.
                    </p>
                </div>
                <div class="col-lg-5">
                    <form action="${pageContext.request.contextPath}/home" method="get" class="search-panel p-2">
                        <div class="input-group">
                            <span class="input-group-text bg-transparent border-0"><i class="bi bi-search"></i></span>
                            <input type="search" class="form-control search-input" name="q" value="${searchQuery}" placeholder="Search cheat sheets">
                            <button class="btn btn-library px-4" type="submit">Search</button>
                        </div>
                    </form>
                    <div class="d-flex flex-wrap gap-2 mt-3">
                        <a class="tag-chip" href="${pageContext.request.contextPath}/cheatsheet/add"><i class="bi bi-plus-circle"></i> Create</a>
                        <a class="tag-chip" href="${pageContext.request.contextPath}/announcements"><i class="bi bi-megaphone"></i> Announcements</a>
                        <a class="tag-chip" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-circle"></i> Profile</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="mb-4">
            <div class="d-flex align-items-end justify-content-between mb-3">
                <h2 class="section-title h4 pb-2 mb-0">Browse Categories</h2>
                <span class="meta-text small">Find references by topic</span>
            </div>

            <c:choose>
                <c:when test="${empty categorylist}">
                    <div class="empty-panel text-center p-4 meta-text">No categories available yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="row g-3">
                        <c:forEach items="${categorylist}" var="cat">
                            <div class="col-md-6 col-xl-4">
                                <a href="${pageContext.request.contextPath}/cheatsheet/category/${cat.id}" class="category-tile d-flex gap-3 align-items-center p-3 h-100">
                                    <span class="category-icon"><i class="bi bi-journal-code"></i></span>
                                    <span>
                                        <span class="d-block fw-bold text-dark">${cat.name}</span>
                                        <span class="d-block meta-text small">View ${cat.name} cheat sheets</span>
                                    </span>
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
                    <div class="mb-4">
                        <h2 class="section-title h4 pb-2 mb-3">Announcements</h2>
                        <div class="d-grid gap-3">
                            <c:forEach items="${announcements}" var="a">
                                <article class="notice-card p-3">
                                    <div class="d-flex gap-3">
                                        <span class="notice-mark"><i class="bi bi-megaphone-fill"></i></span>
                                        <div>
                                            <h3 class="h6 fw-bold mb-1">${a.title}</h3>
                                            <p class="sheet-description small mb-2">${a.content}</p>
                                            <div class="meta-text small">
                                                <c:out value="${a.createdBy != null ? (a.createdBy.fullName != null ? a.createdBy.fullName : a.createdBy.username) : 'Admin'}" />
                                                <span class="mx-2">/</span>${a.createdAt}
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <div class="d-flex align-items-end justify-content-between mb-3">
                    <div>
                        <h2 class="section-title h4 pb-2 mb-1">Latest Cheat Sheets</h2>
                        <div class="meta-text small">Newest public cheat sheets are listed first.</div>
                    </div>
                    <span class="tag-chip">Page ${currentPage} of ${totalPages}</span>
                </div>

                <c:choose>
                    <c:when test="${empty cheatsheetlist}">
                        <div class="empty-panel text-center p-5">
                            <i class="bi bi-journal-x display-5 d-block mb-3 text-secondary"></i>
                            <div class="fw-bold">No cheat sheets found</div>
                            <div class="meta-text small">Try another search keyword or browse a category.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="d-grid gap-3">
                            <c:forEach items="${cheatsheetlist}" var="sheet">
                                <article class="sheet-card d-flex">
                                    <div class="sheet-ribbon p-3 d-flex flex-lg-column align-items-center justify-content-center gap-2">
                                        <div class="sheet-pages">1</div>
                                        <div class="meta-text small fw-bold text-uppercase">Page</div>
                                    </div>
                                    <div class="p-3 p-lg-4 flex-grow-1">
                                        <div class="d-flex flex-wrap justify-content-between gap-2 mb-2">
                                            <c:choose>
                                                <c:when test="${not empty sheet.author}">
                                                    <a class="author-chip" href="${pageContext.request.contextPath}/profile/${sheet.author.id}">
                                                        <i class="bi bi-person"></i>
                                                        <c:out value="${sheet.author.fullName != null ? sheet.author.fullName : sheet.author.username}" />
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="author-chip"><i class="bi bi-person"></i> Unknown</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="author-chip"><i class="bi bi-calendar3"></i> ${sheet.createdAt}</span>
                                        </div>

                                        <h3 class="sheet-title fw-bold mb-2">
                                            <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-decoration-none text-dark">
                                                ${sheet.title}
                                            </a>
                                        </h3>
                                        <p class="sheet-description mb-3">${sheet.description}</p>

                                        <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
                                            <div class="d-flex flex-wrap gap-2">
                                                <span class="tag-chip"><i class="bi bi-folder2-open"></i> ${sheet.category.name}</span>
                                                <span class="tag-chip"><i class="bi bi-eye"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                <span class="tag-chip"><i class="bi bi-download"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                            </div>
                                            <a class="btn btn-library btn-sm px-3" href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}">Open</a>
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
                <div class="side-panel p-3 p-lg-4">
                    <h2 class="section-title h5 pb-2 mb-3">Quick Browse</h2>
                    <c:choose>
                        <c:when test="${empty categorylist}">
                            <div class="meta-text small">No browse links available.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${categorylist}" var="cat">
                                <a class="side-link" href="${pageContext.request.contextPath}/cheatsheet/category/${cat.id}">
                                    <span>${cat.name}</span>
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="side-panel p-3 p-lg-4 mt-4">
                    <h2 class="section-title h5 pb-2 mb-3">Library Tools</h2>
                    <div class="d-grid gap-2">
                        <a class="btn btn-library" href="${pageContext.request.contextPath}/cheatsheet/add">
                            <i class="bi bi-plus-circle me-1"></i> Create Cheat Sheet
                        </a>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/cheatsheet/list">
                            <i class="bi bi-collection me-1"></i> Manage Sheets
                        </a>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/notifications">
                            <i class="bi bi-bell me-1"></i> Notifications
                        </a>
                    </div>
                </div>
            </aside>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
