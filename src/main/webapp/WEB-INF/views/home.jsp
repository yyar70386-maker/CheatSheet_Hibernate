<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home - Cheat Sheet Project</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
/* 📌 ၁။ Browser Window ကြီးတစ်ခုလုံးကို လုံးဝ Scroll မဖြစ်အောင် ချုပ်ပစ်လိုက်ခြင်း */
html, body {
	height: 100vh;
	overflow: hidden; 
	margin: 0;
	padding: 0;
}

/* 📌 ၂။ Header Navbar အမြင့်ကို ပုံသေထားခြင်း */
.navbar {
	height: 56px;
	z-index: 1030;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
}

/* 📌 ၃။ Sidebar နဲ့ Content Area ကို ထိန်းချုပ်မည့် Wrapper အမြင့် */
.app-container {
	display: flex;
	height: calc(100vh - 56px); 
	width: 100%;
}

/* 📌 ၄။ Sidebar ကို နေရာမှာတင် အသေငြိမ်နေစေခြင်း */
.admin-sidebar {
	width: 280px;
	height: 100%;
	flex-shrink: 0;
	overflow-y: auto; 
}

/* 📌 ၅။ ညာဘက် Content Area ကိုပဲ Mouse Wheel ဖြင့် သီးသန့် Scroll ဖြစ်စေခြင်း */
.main-content-area {
	flex-grow: 1;
	height: 100%;
	overflow-y: auto; 
	min-width: 0;
	padding: 24px;
	background-color: #f8f9fa;
}

.hero-section {
	background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
	padding: 40px 0;
	border-bottom: 1px solid #e2e8f0;
	border-radius: 12px;
}

.feature-card {
	border: none;
	border-radius: 12px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	text-decoration: none;
	display: block;
}

.feature-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.icon-box {
	width: 70px;
	height: 70px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	background-color: #e9ecef;
	margin: 0 auto 20px auto;
}

.icon-box i {
	font-size: 32px;
	color: #333;
}
</style>
</head>
<body class="bg-light">

	<%-- 🧩 ၁။ Header Component ကို အပေါ်ဆုံးမှာ ထားပါတယ် --%>
	<jsp:include page="header.jsp" />

    <%-- 🌐 ဖွဲ့စည်းပုံတစ်ခုလုံးကို ထိန်းချုပ်မည့် App Container --%>
	<div class="app-container">

        <%-- 🛠️ ဘယ်ဘက်ခြမ်း - SIDEBAR COMPONENT --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="dashboard" />
        </jsp:include>

		<%-- 🌐 ညာဘက်ခြမ်း MAIN CONTENT AREA --%>
		<div class="main-content-area">

			<%-- 🔐 🌟 ပြင်ဆင်မှုအပိုင်း: Admin (role == 1) ဖြင့် ဝင်ထားမှသာ စက်ဝိုင်းများကို ပြသမည် --%>
			<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
				
				<%-- 📊 Count Widgets Section --%>
				<div class="row g-4 mb-4">
	
					<div class="col-10 col-md-4 mx-auto">
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
	
					<div class="col-10 col-md-4 mx-auto">
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
	
					<div class="col-10 col-md-4 mx-auto">
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
				
			</c:if> <%-- 🔐 /Admin Check End --%>

			<%-- 📂 BROWSE CATEGORIES AREA --%>
			<div class="bg-white rounded-3 shadow-sm border p-4">
				<div class="text-center my-2">
					<h3 class="fw-bold text-dark mb-1">Browse Categories</h3>
					<p class="text-muted small">Explore cheat sheets by category and improve your skills.</p>
					<hr class="w-25 mx-auto text-muted my-3">
				</div>

				<%-- 📋 CATEGORY CARDS GRID SYSTEM --%>
				<c:choose>
					<c:when test="${empty categorylist}">
						<div class="text-center text-muted fs-5 my-5 py-4">
							<i class="bi bi-folder-x display-4 d-block mb-3 text-secondary"></i> 
							No categories available at the moment.
						</div>
					</c:when>

					<c:otherwise>
						<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 justify-content-center">
							<c:forEach items="${categorylist}" var="c">
								<div class="col">
									<a href="${pageContext.request.contextPath}/cheatsheet/category/${c.id}"
										class="card feature-card h-100 p-4 text-center bg-light border">

										<div class="icon-box">
											<i class="bi bi-layers-half text-primary"></i>
										</div>

										<div class="card-body p-0">
											<h5 class="card-title fw-bold text-dark mb-2">
												${c.name}
											</h5>
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
			</div>

		</div> <%-- /main-content-area --%>
	</div> <%-- /app-container --%>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>