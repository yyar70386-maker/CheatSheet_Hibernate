<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${totalCount} ${categoryName} Cheat Sheets</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        .page-header-section {
            text-align: left;
            margin: 40px 0 20px 0;
        }
        .cheatsheet-card {
            background: rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: auto;
            display: flex;
            flex-direction: column;
        }
        .cheatsheet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
        }
        .grid-item {
            align-self: start; 
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
            color: #ff3366;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            margin-top: 5px;
        }
        .see-more-btn:hover {
            text-decoration: underline;
            color: #e62e5c;
        }
        .card-meta-item {
            color: #666;
            font-size: 14px;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .tag-badge-link {
            background-color: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.8);
            color: #333;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s ease;
        }
        .tag-badge-link:hover {
            background-color: #1a1a1a;
            color: white;
            transform: translateY(-2px);
        }
        .stats-section {
            font-size: 14px;
            color: #555;
            display: flex;
            gap: 20px;
            margin-top: 15px;
        }
        .tags-footer-section {
            background: rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-top: 50px;
        }
        .vertical-tag-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .vertical-tag-item {
            font-size: 16px;
            color: #ff3366;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            width: fit-content;
        }
        .vertical-tag-item:hover {
            color: #e62e5c;
            text-decoration: underline;
        }
        
        /* 🌟 [UPDATED] Visibility Badges Style (Screenshot 2026-07-05 at 17.20.49.png ပုံစံအတိုင်း) */
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
        
        /* 🌟 Dropdown Button Style */
        .filter-dropdown-btn {
            border: 1px solid #ff3366;
            color: #ff3366;
            font-weight: 600;
            border-radius: 8px;
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(5px);
        }
        .filter-dropdown-btn:hover, .filter-dropdown-btn:focus {
            background-color: #ff3366;
            color: white;
            border-color: #ff3366;
        }
    </style>
</head>
<body style="background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%); min-height: 100vh; color: #1a1a1a;">

    <jsp:include page="header.jsp" />

    <div class="container my-5">
        
        <div class="d-flex flex-wrap justify-content-between align-items-center page-header-section">
            <div>
                <h1 class="display-5 fw-bold text-dark mb-0">${totalCount} ${categoryName} Cheat Sheets</h1>
            </div>
            
            <%-- 🌟 Login User ဖြစ်မှသာ Dropdown Filter အား ပြသပေးမည် --%>
            <c:if test="${not empty sessionScope.currentUser}">
                <div class="dropdown mt-3 mt-md-0">
                    <button class="btn filter-dropdown-btn dropdown-toggle d-flex align-items-center gap-2" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-funnel-fill"></i> 
                        Filter: 
                        <c:choose>
                            <c:when test="${currentFilter == 'PUBLIC'}">Public Only</c:when>
                            <c:when test="${currentFilter == 'FRIEND'}">Friends Only</c:when>
                            <c:otherwise>All</c:otherwise>
                        </c:choose>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="filterDropdown">
                        <li>
                            <a class="dropdown-item ${currentFilter == 'ALL' || empty currentFilter ? 'active bg-brand-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?filter=ALL">
                                <i class="bi bi-collection-fill me-2"></i> All
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${currentFilter == 'PUBLIC' ? 'active bg-brand-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?filter=PUBLIC">
                                <i class="bi bi-globe me-2"></i> Public Only
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${currentFilter == 'FRIEND' ? 'active bg-brand-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?filter=FRIEND">
                                <i class="bi bi-people-fill me-2"></i> Friends Only
                            </a>
                        </li>
                    </ul>
                </div>
                
                <div class="dropdown mt-3 mt-md-0 ms-2">
                    <button class="btn filter-dropdown-btn dropdown-toggle d-flex align-items-center gap-2" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-sort-down"></i> 
                        Sort: 
                        <c:choose>
                            <c:when test="${sortBy == 'likes'}">Most Likes</c:when>
                            <c:when test="${sortBy == 'dislikes'}">Most Dislikes</c:when>
                            <c:otherwise>Latest</c:otherwise>
                        </c:choose>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="sortDropdown">
                        <li>
                            <a class="dropdown-item ${sortBy == 'latest' || empty sortBy ? 'active bg-brand-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?filter=${currentFilter}&sortBy=latest">
                                <i class="bi bi-clock-history me-2"></i> Latest
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${sortBy == 'likes' ? 'active bg-brand-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?filter=${currentFilter}&sortBy=likes">
                                <i class="bi bi-hand-thumbs-up-fill me-2"></i> Most Likes
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${sortBy == 'dislikes' ? 'active bg-brand-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?filter=${currentFilter}&sortBy=dislikes">
                                <i class="bi bi-hand-thumbs-down-fill me-2"></i> Most Dislikes
                            </a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty cheatsheetlist}">
                <div class="text-center text-muted fs-5 my-5 py-5">
                    <i class="bi bi-file-earmark-x display-4 d-block mb-3"></i>
                    No cheat sheets found with the selected filter.
                </div>
            </c:when>
            <c:otherwise>
                
                <div class="row g-4 justify-content-start">
                    <c:forEach items="${cheatsheetlist}" var="sheet">
                        
                        <div class="col-md-6 col-lg-4 grid-item">
                            <div class="cheatsheet-card">
                                <div>
                                    <h3 class="fw-bold mb-2 d-flex align-items-center justify-content-between">
									    <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.obfuscatedId}" class="text-dark text-decoration-none hover-underline fs-4">
									        ${sheet.title}
									    </a>
                                        
                                        <c:choose>
                                            <%-- 🌟 [UPDATED UI] Login User ဖြစ်ပါက ၎င်း၏ Visibility အခြေအနေအလိုက် Pill Badges ပြောင်းလဲခြင်း --%>
                                            <c:when test="${not empty sessionScope.currentUser}">
                                                <c:choose>
                                                    <c:when test="${sheet.visibility == 'PUBLIC'}">
                                                        <span class="visibility-pill pill-public" title="Public Cheat Sheet">
                                                            <i class="bi bi-globe"></i> Public
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${sheet.visibility == 'FRIEND-ONLY'}">
                                                        <span class="visibility-pill pill-friends" title="Friends Only Cheat Sheet">
                                                            <i class="bi bi-people-fill"></i> Friends
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="visibility-pill pill-private" title="Private Cheat Sheet">
                                                            <i class="bi bi-lock-fill"></i> Private
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <%-- 🌟 Guest User ဖြစ်ပါက ကမ္ဘာလုံး Badge တစ်မျိုးတည်းကိုသာ ပုံသေပြသပေးခြင်း --%>
                                            <c:otherwise>
                                                <span class="visibility-pill pill-public" title="Public Cheat Sheet">
                                                    <i class="bi bi-globe"></i> Public
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
									</h3>
                                    
                                    <div class="description-container mb-3">
                                        <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                        <span class="see-more-btn" onclick="toggleDescription(this)">See More</span>
                                    </div>
                                    
                                    <div class="card-meta-item">
                                        <i class="bi bi-person-fill"></i> ${sheet.author != null ? sheet.author.username : 'Unknown'}
                                    </div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-folder-fill"></i> ${sheet.category.name} Cheat Sheets
                                    </div>
                                    
                                    <div class="card-meta-item">
                                        <i class="bi bi-calendar-plus"></i> Created: <fmt:formatDate value="${sheet.createdAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-calendar-event"></i> Updated: <fmt:formatDate value="${sheet.updatedAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                    
                                    <div class="d-flex flex-wrap gap-2 my-3">
                                        <c:forEach items="${sheet.tags}" var="tag">
                                            <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge-link">#${tag.name}</a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="stats-section mt-auto d-flex justify-content-between align-items-center">
                                    <div class="d-flex gap-3">
                                        <span><i class="bi bi-eye-fill me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                        <span><i class="bi bi-download me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                    </div>
                                    
                                    <div>
                                        <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                           target="_blank" 
                                           class="btn btn-sm btn-outline-danger px-2 py-1 d-flex align-items-center gap-1"
                                           style="border-radius: 6px; font-size: 12px; font-weight: bold;"
                                           title="View PDF Document">
                                            <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- 🧭 Pagination Bar --%>
                <nav class="d-flex justify-content-center mt-5">
                    <ul class="pagination pagination-md">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?page=${currentPage - 1}&filter=${currentFilter}&sortBy=${sortBy}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?page=${i}&filter=${currentFilter}&sortBy=${sortBy}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?page=${currentPage + 1}&filter=${currentFilter}&sortBy=${sortBy}">Next</a>
                        </li>
                    </ul>
                </nav>

            </c:otherwise>
        </c:choose>

        <div class="tags-footer-section">
            <h5 class="fw-bold text-dark mb-4"><i class="bi bi-tags-fill me-2 text-primary"></i>Tag in ${categoryName} Cheat Sheets</h5>
            <div class="vertical-tag-list">
                <c:choose>
                    <c:when test="${empty taglist}">
                        <span class="text-muted fs-6">No tags setup for this category yet.</span>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${taglist}" var="t">
                            <a href="${pageContext.request.contextPath}/cheatsheet/tag/${t.id}" class="vertical-tag-item">
                                <i class="bi bi-hash text-muted me-1"></i>${t.name}
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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