<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${targetUser.username}'s Profile</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        .profile-header-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
            margin-top: 40px;
        }
        .profile-avatar {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #f1f5f9;
        }
        .stats-box {
            text-align: center;
            padding: 12px 25px;
            background: #f8fafc;
            border-radius: 16px;
            min-width: 110px;
        }
        .stats-count {
            font-size: 22px;
            font-weight: 800;
            color: #1e293b;
            display: block;
        }
        .stats-label {
            font-size: 13px;
            color: #64748b;
            font-weight: 600;
        }
        
        /* 🌟 [MERGED FROM BROWSE] CheatSheet Card Layout & Typography Styles */
        .cheatsheet-card {
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 30px;
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.02);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%; /* Column Stretch အလုပ်လုပ်ရန် */
            display: flex;
            flex-direction: column;
        }
        .cheatsheet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
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
        
        /* 🌟 [MERGED FROM BROWSE] Visibility Pill Badges Styles */
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
    </style>
</head>
<body class="bg-light">

    <%-- Include Header Component --%>
    <jsp:include page="header.jsp" />

    <div class="container" style="max-width: 950px;">
        
        <div class="profile-header-card">
            <div class="row align-items-center g-4">
                
                <div class="col-md-auto text-center">
                    <c:choose>
                        <c:when test="${not empty targetUser.avatarPath}">
                            <img src="${pageContext.request.contextPath}/uploads/${targetUser.avatarPath}" class="profile-avatar" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <img src="https://cdn-icons-png.flaticon.com/512/3177/3177440.png" class="profile-avatar" alt="Default Avatar">
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div class="col text-center text-md-start">
                    <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-start gap-3 mb-2">
                        <h2 class="fw-bold m-0 text-dark">${targetUser.username}</h2>
                        
                        <c:if test="${sessionScope.currentUser.id != targetUser.id}">
                            <c:choose>
                                <c:when test="${isFollowing}">
                                    <form action="${pageContext.request.contextPath}/unfollow/${targetUser.id}" method="POST" class="d-inline">
                                        <button type="submit" class="btn btn-outline-secondary btn-sm rounded-pill px-3 fw-bold">
                                            <i class="bi bi-person-x-fill me-1"></i> Unfollow
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/follow/${targetUser.id}" method="POST" class="d-inline">
                                        <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-bold">
                                            <i class="bi bi-person-plus-fill me-1"></i> Follow
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                    
                    <p class="text-muted mb-3">@${targetUser.fullName}</p>
                    <p class="text-secondary m-0" style="max-width: 500px;">
                        ${not empty targetUser.bio ? targetUser.bio : "This user hasn't written a bio yet."}
                    </p>
                </div>
                
                <div class="col-md-auto">
                    <div class="d-flex justify-content-center gap-3">
                        <div class="stats-box">
                            <span class="stats-count">${followersCount}</span>
                            <span class="stats-label">Followers</span>
                        </div>
                        <div class="stats-box">
                            <span class="stats-count">${followingCount}</span>
                            <span class="stats-label">Following</span>
                        </div>
                        <div class="stats-box">
                            <span class="stats-count">${mutualFollowersCount}</span>
                            <span class="stats-label">Mutual</span>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>

        <div class="mt-5 mb-5">
            <h4 class="fw-bold text-dark mb-4">
                <i class="bi bi-file-earmark-code me-2 text-primary"></i>${targetUser.username}'s Cheat Sheets
            </h4>
            
            <c:choose>
                <c:when test="${empty cheatsheetlist}">
                    <div class="text-center text-muted py-5 bg-white rounded-4 border border-dashed">
                        <i class="bi bi-folder2-open display-6 d-block mb-2 text-secondary"></i>
                        No accessible cheat sheets published yet.
                    </div>
                </c:when>
                <c:otherwise>
                    
                    <!-- 🌟 [UPDATED LAYOUT] Browse စာမျက်နှာနှင့် တစ်ပြေးညီ Grid စနစ်ပြောင်းလဲခြင်း -->
                    <div class="row g-4 justify-content-start">
                        <c:forEach items="${cheatsheetlist}" var="sheet">
                            
                            <!-- [UI LEVEL SECURITY SHIELD] PRIVATE ဒေတာဖြစ်ပါက ကျော်သွားမည် -->
                            <c:if test="${sheet.visibility != 'PRIVATE'}">
                                <div class="col-md-6 grid-item">
                                    <div class="cheatsheet-card">
                                        <div>
                                            <h3 class="fw-bold mb-2 d-flex align-items-center justify-content-between">
                                                <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.obfuscatedId}" class="text-dark text-decoration-none hover-underline fs-4">
                                                    ${sheet.title}
                                                </a>
                                                
                                                <c:choose>
                                                    <%-- Login User ဖြစ်ပါက Pillow Badge စနစ်ဖြင့် စနစ်တကျထုတ်ပြမည် --%>
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
                                                    <%-- Guest ဖြစ်ပါက Public သာပြမည် --%>
                                                    <c:otherwise>
                                                        <span class="visibility-pill pill-public" title="Public Cheat Sheet">
                                                            <i class="bi bi-globe"></i> Public
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </h3>
                                            
                                            <!-- See More Handle -->
                                            <div class="description-container mb-3">
                                                <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                                <span class="see-more-btn" onclick="toggleDescription(this)">See More</span>
                                            </div>
                                            
                                            <!-- Meta Items -->
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
                                            
                                            <!-- Hash Tags -->
                                            <div class="d-flex flex-wrap gap-2 my-3">
                                                <c:forEach items="${sheet.tags}" var="tag">
                                                    <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge-link">#${tag.name}</a>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <!-- Bottom Metrics & PDF Button -->
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
                            </c:if>
                            
                        </c:forEach>
                    </div>
                    
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- See More/Less လုပ်ဆောင်ချက်အတွက် Javascript Function -->
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