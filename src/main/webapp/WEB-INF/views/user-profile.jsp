<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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
        .cheatsheet-card {
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 25px;
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.01);
            transition: transform 0.2s ease;
        }
        .cheatsheet-card:hover {
            transform: translateY(-3px);
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
                        No public cheat sheets published yet.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-3">
                        <c:forEach items="${cheatsheetlist}" var="sheet">
                            <div class="col-md-6">
                                <div class="cheatsheet-card">
                                    <h5 class="fw-bold">
                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}" class="text-dark text-decoration-none hover-underline">
                                            ${sheet.title}
                                        </a>
                                    </h5>
                                    <p class="text-secondary small text-truncate mb-2">${sheet.description}</p>
                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="badge bg-light text-dark border rounded-pill">${sheet.category.name}</span>
                                        <small class="text-muted"><i class="bi bi-eye me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</small>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>