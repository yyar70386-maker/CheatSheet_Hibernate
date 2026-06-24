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
            margin: 40px 0;
        }
        .cheatsheet-card {
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 30px;
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            
            /* 🌟 ကတ်အမြင့်များကို dynamic ဖြစ်စေရန် auto ပြောင်းလဲခြင်း */
            height: auto;
            display: flex;
            flex-direction: column;
        }
        .cheatsheet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        
        /* 🌟 ကတ်တစ်ခု ရှည်ထွက်သွားလည်း ဘေးကကတ်များ လိုက်မရှည်စေရန် ထိန်းချုပ်သည့် CSS */
        .grid-item {
            align-self: start; 
        }

        /* 🌟 Description ကို စစချင်းမှာ ၃ ကြောင်းပဲ ဖြတ်ပြထားရန် */
        .description-text {
            display: -webkit-box;
            -webkit-line-clamp: 3; 
            -webkit-box-orient: vertical;  
            overflow: hidden;
            transition: all 0.3s ease;
        }

        /* See More နှိပ်လိုက်သည့်အခါ စာသားအားလုံး ပေါ်လာစေရန် */
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
            color: #666;
            font-size: 14px;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .tag-badge-link {
            background-color: #e2e8f0;
            color: #333;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
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
        .tags-footer-section {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 15px;
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
            color: #0d47a1;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
            width: fit-content;
        }
        .vertical-tag-item:hover {
            color: #1976d2;
            text-decoration: underline;
        }
    </style>
</head>
<body class="bg-light">

    <%-- Include Header Component --%>
    <jsp:include page="header.jsp" />

    <div class="container my-5">
        
        <%-- ၁။ Dynamic Page Header --%>
        <div class="page-header-section">
            <h1 class="display-5 fw-bold text-dark">${totalCount} ${categoryName} Cheat Sheets</h1>
        </div>

        <c:choose>
            <c:when test="${empty cheatsheetlist}">
                <div class="text-center text-muted fs-5 my-5 py-5">
                    <i class="bi bi-file-earmark-x display-4 d-block mb-3"></i>
                    No cheat sheets found in this category.
                </div>
            </c:when>
            <c:otherwise>
                
                <%-- ၂။ Grid Row (ဘယ်ဘက်ကစပြီး စီရန် justify-content-start နှင့် grid alignment ပါဝင်ပါသည်) --%>
                <div class="row g-4 justify-content-start">
                    <c:forEach items="${cheatsheetlist}" var="sheet">
                        
                        <%-- 🌟 grid-item class ကြောင့် ဘေးကကတ်များ လိုက်မရှည်တော့ပါ --%>
                        <div class="col-md-6 col-lg-4 grid-item">
                            <div class="cheatsheet-card">
                                <div>
                                    <h3 class="fw-bold mb-2">
									    <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark text-decoration-none hover-underline">
									        ${sheet.title}
									    </a>
									</h3>
                                    
                                    <%-- 🌟 See More စနစ်ထည့်သွင်းထားသော Description Area --%>
                                    <div class="description-container mb-3">
                                        <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                        <span class="see-more-btn" onclick="toggleDescription(this)">See More</span>
                                    </div>
                                    
                                    <%-- <div class="card-meta-item">
                                        <i class="bi bi-person-fill"></i> ${sheet.author != null ? sheet.author.username : 'Unknown'}
                                    </div> --%>
                                    
                                    <div class="card-meta-item">
    <i class="bi bi-person-fill text-dark"></i> 
    <c:choose>
        <c:when test="${sheet.author != null}">
            <a href="${pageContext.request.contextPath}/profile/${sheet.author.id}" 
               class="text-dark fw-bold text-decoration-none" 
               style="hover: text-decoration: underline;">
                <c:out value="${sheet.author.username}" />
            </a>
        </c:when>
        <c:otherwise>
            <span class="text-muted fw-normal">Unknown</span>
        </c:otherwise>
    </c:choose>
</div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-folder-fill"></i> ${sheet.category.name} Cheat Sheets
                                    </div>
                                    
                                    <%-- Created At & Updated At --%>
                                    <div class="card-meta-item">
                                        <i class="bi bi-calendar-plus"></i> Created: <fmt:formatDate value="${sheet.createdAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                    <div class="card-meta-item">
                                        <i class="bi bi-calendar-event"></i> Updated: <fmt:formatDate value="${sheet.updatedAt}" pattern="yyyy-MM-dd"/>
                                    </div>
                                    
                                    <%-- Tag Links List --%>
                                    <div class="d-flex flex-wrap gap-2 my-3">
                                        <c:forEach items="${sheet.tags}" var="tag">
                                            <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge-link">#${tag.name}</a>
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

                <%-- 🧭 Pagination Bar --%>
                <nav class="d-flex justify-content-center mt-5">
                    <ul class="pagination pagination-md">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?page=${currentPage - 1}">Previous</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/cheatsheet/category/${categoryId}?page=${currentPage + 1}">Next</a>
                        </li>
                    </ul>
                </nav>

            </c:otherwise>
        </c:choose>

        <%-- ၅။ Bottom Section: Tags In Category (အထက်အောက်ပုံစံနှင့် Dynamic Count ပါဝင်ပါသည်) --%>
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
    
    <%-- 🌟 JavaScript Function for See More / See Less Toggle --%>
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