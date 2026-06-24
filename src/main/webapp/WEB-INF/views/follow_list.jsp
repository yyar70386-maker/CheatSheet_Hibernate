<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${pageTitle}</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
    body { background-color: #f8f9fa; }
    .user-card {
        transition: transform 0.2s, box-shadow 0.2s;
        border-radius: 15px;
    }
    .user-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.08) !important;
    }
    .avatar-img {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 50%;
    }
</style>
</head>
<body>

	<nav class="navbar navbar-dark bg-dark px-4 shadow-sm">
		<a href="${pageContext.request.contextPath}/home" class="navbar-brand mb-0 h1"> 
			<i class="bi bi-speedometer2 me-2"></i>Dashboard
		</a> 
		<a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-light btn-sm">
			<i class="bi bi-arrow-left me-1"></i> My Profile
		</a>
	</nav>

	<div class="container mt-5" style="max-width: 650px;">
		<h4 class="fw-bold mb-4 text-dark">
			<i class="bi bi-people me-2 text-primary"></i>${pageTitle}
		</h4>

		<c:choose>
			<c:when test="${empty userList}">
				<div class="text-center py-5 bg-white rounded-3 shadow-sm border">
					<i class="bi bi-person-dash display-4 text-muted"></i>
					<p class="text-muted mt-2 mb-0">No users found in this list.</p>
				</div>
			</c:when>
			<c:otherwise>
				<div class="d-flex flex-column gap-3 mb-5">
					<c:forEach items="${userList}" var="u">
						<div class="card user-card shadow-sm border-0 p-3">
							<div class="d-flex align-items-center justify-content-between">
								<div class="d-flex align-items-center">
									<c:choose>
										<%-- 🌟 Avatar Image လမ်းကြောင်းကို profile.jsp အတိုင်း ညှိနှိုင်းထားပါသည် --%>
										<c:when test="${not empty u.avatarPath}">
											<img src="${pageContext.request.contextPath}/profile/avatar/${u.avatarPath}" class="avatar-img me-3">
										</c:when>
										<c:otherwise>
											<img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" class="avatar-img me-3">
										</c:otherwise>
									</c:choose>
									
									<div>
										<h6 class="fw-bold mb-0 text-dark">${u.username}</h6>
										<small class="text-muted">@${u.fullName}</small>
									</div>
								</div>
								
								<%-- 🌟 View Profile ကိုနှိပ်လျှင် သက်ဆိုင်ရာ User ၏ ID အလိုက် တခြားသူ Profile စာမျက်နှာ (/profile/{id}) သို့ သွားမည် --%>
								<a href="${pageContext.request.contextPath}/profile/${u.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
									View Profile
								</a>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>