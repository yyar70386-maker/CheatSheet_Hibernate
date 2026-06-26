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
        .page-header-section { text-align: left; margin: 20px 0 40px 0; }
        .cheatsheet-card { border: 1px solid #e2e8f0; border-radius: 20px; padding: 30px; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.02); transition: transform 0.3s ease, box-shadow 0.3s ease; height: auto; display: flex; flex-direction: column; }
        .cheatsheet-card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        .grid-item { align-self: start; }
        .description-text { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
        .description-text.expanded { display: block; -webkit-line-clamp: unset; }
        .see-more-btn { color: #1976d2; cursor: pointer; font-weight: bold; font-size: 14px; display: inline-block; margin-top: 5px; }
        .card-meta-item { color: #666; font-size: 14px; margin-bottom: 6px; display: flex; align-items: center; gap: 10px; }
        .tag-badge-link { background-color: #e2e8f0; color: #333; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: bold; text-decoration: none; display: inline-block; }
        .tag-badge-link:hover { background-color: #1976d2; color: white; }
        .stats-section { font-size: 14px; color: #555; display: flex; gap: 20px; margin-top: 15px; }
    </style>
</head>
<body class="bg-light">

    <%-- Include Header Component --%>
    <jsp:include page="header.jsp" />

    <div class="container my-4 flex-grow-1">
        
        <%-- Back Button --%>
        <a href="javascript:history.back()" class="btn btn-outline-secondary mb-3"><i class="bi bi-arrow-left"></i> Back</a>

        <div class="page-header-section">
            <h1 class="display-5 fw-bold text-dark">${totalCount} Cheat Sheets tagged with #${tagName}</h1>
        </div>

        <c:choose>
            <c:when test="${empty cheatsheetlist}">
                <div class="text-center text-muted fs-5 my-5 py-5">
                    <i class="bi bi-file-earmark-x display-4 d-block mb-3"></i>
                    No public cheat sheets found with this tag.
                </div>
            </c:when>
            <c:otherwise>
                
                <div class="row g-4 justify-content-start">
                    <c:forEach items="${cheatsheetlist}" var="sheet">
                        <div class="col-md-6 col-lg-4 grid-item">
                            <%-- 🌟 Card တစ်ခုလုံးကို နှိပ်လို့ရအောင် onclick ထည့်ထားပါသည် --%>
                            <div class="cheatsheet-card" style="cursor: pointer;" onclick="window.location.href='${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}'">
                                <div>
                                    <h3 class="fw-bold mb-2">
                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark text-decoration-none">
                                            ${sheet.title}
                                        </a>
                                    </h3>
                                    
                                    <div class="description-container mb-3">
                                        <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                        <%-- 🌟 event.stopPropagation() ထည့်ထားသည် --%>
                                        <span class="see-more-btn" onclick="event.stopPropagation(); toggleDescription(this)">See More</span>
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
                                            <%-- 🌟 Tags နှိပ်လျှင် Detail Page သို့မရောက်အောင် တားထားသည် --%>
                                            <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" onclick="event.stopPropagation();" class="tag-badge-link ${tag.id == param.tagId ? 'bg-primary text-white' : ''}">#${tag.name}</a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="stats-section mt-auto">
                                    <span><i class="bi bi-eye-fill me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                    <span><i class="bi bi-download me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

            </c:otherwise>
        </c:choose>

    </div>

    <%-- Include Footer Component --%>
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