<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>#${tagName} - Cheat Sheets</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { display: flex; flex-direction: column; min-height: 100vh; }
        .page-header-section { text-align: left; margin: 20px 0 20px 0; }
        
        /* 🌟 [UPDATED] Standardized Layout from Browse/Home CSS */
        .cheatsheet-card { 
            border: 1px solid #e2e8f0; 
            border-radius: 20px; 
            padding: 30px; 
            background: white; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.02); 
            transition: transform 0.3s ease, box-shadow 0.3s ease; 
            height: 100%; 
            display: flex; 
            flex-direction: column; 
        }
        .cheatsheet-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        .grid-item { align-self: start; }
        .description-text { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; transition: all 0.3s ease; }
        .description-text.expanded { display: block; -webkit-line-clamp: unset; }
        .see-more-btn { color: #1976d2; cursor: pointer; font-weight: bold; font-size: 14px; display: inline-block; margin-top: 5px; text-decoration: none; }
        .see-more-btn:hover { text-decoration: underline; }
        .card-meta-item { color: #555; font-size: 14px; margin-bottom: 8px; display: flex; align-items: center; gap: 10px; }
        
        .tag-badge-link { background-color: #e2e8f0; color: #333; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: bold; text-decoration: none; display: inline-block; }
        .tag-badge-link:hover { background-color: #1976d2; color: white; }
        .stats-section { font-size: 14px; color: #555; display: flex; gap: 20px; margin-top: 15px; }
        
        /* 🌟 [UPDATED] Visibility Pill Badges Styles (Screenshot 2026-07-05 at 18.04.46_2.png ပုံစံအတိုင်း) */
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

        .filter-dropdown-btn { border: 1px solid #1976d2; color: #1976d2; font-weight: 600; border-radius: 8px; padding: 8px 16px; }
        .filter-dropdown-btn:hover, .filter-dropdown-btn:focus { background-color: #1976d2; color: white; border-color: #1976d2; }
    </style>
</head>
<body class="bg-light">

    <jsp:include page="header.jsp" />

    <div class="container my-4 flex-grow-1">
        
        <%-- Back Button --%>
        <a href="javascript:history.back()" class="btn btn-outline-secondary mb-3"><i class="bi bi-arrow-left"></i> Back</a>

        <div class="d-flex flex-wrap justify-content-between align-items-center page-header-section">
            <div>
                <h1 class="display-5 fw-bold text-dark mb-0">${totalCount} Cheat Sheets tagged with #${tagName}</h1>
            </div>
            
            <c:if test="${not empty sessionScope.currentUser}">
                <div class="dropdown mt-3 mt-md-0">
                    <button class="btn filter-dropdown-btn dropdown-toggle d-flex align-items-center gap-2" type="button" id="tagFilterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-funnel-fill"></i> 
                        Filter: 
                        <c:choose>
                            <c:when test="${currentFilter == 'PUBLIC'}">Public Only</c:when>
                            <c:when test="${currentFilter == 'FRIEND'}">Friends Only</c:when>
                            <c:otherwise>All</c:otherwise>
                        </c:choose>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="tagFilterDropdown">
                        <li>
                            <a class="dropdown-item ${currentFilter == 'ALL' || empty currentFilter ? 'active bg-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/tag/${tagId}?filter=ALL">
                                <i class="bi bi-collection-fill me-2"></i> All
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${currentFilter == 'PUBLIC' ? 'active bg-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/tag/${tagId}?filter=PUBLIC">
                                <i class="bi bi-globe me-2"></i> Public Only
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item ${currentFilter == 'FRIEND' ? 'active bg-primary' : ''}" 
                               href="${pageContext.request.contextPath}/cheatsheet/tag/${tagId}?filter=FRIEND">
                                <i class="bi bi-people-fill me-2"></i> Friends Only
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
                            
                            <div class="cheatsheet-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}'">
                                <div>
                                    <h3 class="fw-bold mb-2 d-flex align-items-center justify-content-between">
                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark text-decoration-none fs-4">
                                            ${sheet.title}
                                        </a>
                                        
                                        <%-- 🌟 [UPDATED UI] Dynamic Pill Badge Icons (Screenshot အတိုင်း) --%>
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
                                    </h3>
                                    
                                    <div class="description-container mb-3">
                                        <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                        <span class="see-more-btn" onclick="event.stopPropagation(); toggleDescription(this)">See More</span>
                                    </div>
                                    
                                    <%-- 🌟 [UPDATED] Icons matching the reference image verbatim --%>
                                    <div class="card-meta-item">
                                        <i class="bi bi-person text-muted"></i> ${sheet.author != null ? sheet.author.username : 'Unknown'}
                                    </div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-folder text-muted"></i> ${sheet.category.name} Cheat Sheets
                                    </div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-calendar-plus text-muted"></i> Created: <fmt:formatDate value="${sheet.createdAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-calendar-event text-muted"></i> Updated: <fmt:formatDate value="${sheet.updatedAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                    
                                    <div class="d-flex flex-wrap gap-2 my-3">
                                        <c:forEach items="${sheet.tags}" var="tag">
                                            <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" onclick="event.stopPropagation();" class="tag-badge-link">#${tag.name}</a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <%-- 🌟 [UPDATED UI] Icons matching the reference image verbatim for metrics --%>
                                <div class="stats-section mt-auto d-flex justify-content-between align-items-center pt-2">
                                    <div class="d-flex gap-3">
                                        <span><i class="bi bi-eye text-muted me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                        <span><i class="bi bi-download text-muted me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                    </div>
                                    
                                    <div>
                                        <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                           onclick="event.stopPropagation();"
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

                <%-- 🧭 Pagination Bar --%>
                <nav class="d-flex justify-content-center mt-5">
                    <ul class="pagination pagination-md">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/tag/${tagId}?page=${currentPage - 1}&filter=${currentFilter}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/tag/${tagId}?page=${i}&filter=${currentFilter}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/tag/${tagId}?page=${currentPage + 1}&filter=${currentFilter}">Next</a>
                        </li>
                    </ul>
                </nav>

            </c:otherwise>
        </c:choose>

    </div>

    <jsp:include page="footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    function toggleDescription(btn) {
        var textEl = btn.previousElementSibling;
        textEl.classList.toggle('expanded');
        btn.innerText = textEl.classList.contains('expanded') ? 'See Less' : 'See More';
    }
    </script>
</body>
</html>