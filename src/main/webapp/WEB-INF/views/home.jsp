<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home - CheatSheet Library</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- 📊 Chart.js Library -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
:root {
	--page-bg: #f8f9fa;
	--card-bg: #ffffff;
	--text-dark: #212529;
	--text-muted: #6c757d;
	--line-color: #dee2e6;
	--brand-primary: #1976d2;
	--brand-dark: #0d47a1;
	--accent-green: #2e7d32;
	--accent-teal: #00796b;
	--accent-amber: #f57c00;
}

html, body {
	height: 100vh;
	overflow: hidden;
	margin: 0;
	padding: 0;
	background-color: var(--page-bg);
	color: var(--text-dark);
	font-family: "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

a {
	color: var(--brand-primary);
	text-decoration: none;
}

a:hover {
	color: var(--brand-dark);
}

.app-container {
	display: flex;
	height: calc(100vh - 56px);
	width: 100%;
}

.main-content-area {
	flex-grow: 1;
	height: 100%;
	overflow-y: auto;
	min-width: 0;
	padding: 24px;
	background-color: var(--page-bg);
}

/* Hero Banner Section */
.hero-section {
	background: linear-gradient(135deg, var(--brand-dark) 0%,
		var(--brand-primary) 100%);
	padding: 3.5rem 2rem;
	color: white;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

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

.feature-card, .sheet-card, .notice-card, .empty-panel {
	border: 1px solid var(--line-color);
	background: var(--card-bg);
	border-radius: 12px;
}

.feature-card {
	transition: transform 0.3s ease;
	text-decoration: none;
	display: block;
}

.feature-card:hover {
	transform: translateY(-5px);
}

.icon-box {
	width: 64px;
	height: 64px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	background-color: #e9ecef;
	margin: 0 auto 15px auto;
}

.sheet-card {
	overflow: hidden;
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
}

/* Admin Circle Chart Box */
.chart-box-container {
	position: relative;
	margin: auto;
	height: 200px;
	width: 200px;
}
</style>
</head>
<body>

	<%-- 🧩 Header Component --%>
	<jsp:include page="header.jsp" />

	<div class="app-container">

		<%-- 🛠️ Sidebar Component --%>
		<jsp:include page="sidebar.jsp">
			<jsp:param name="activePage" value="dashboard" />
		</jsp:include>

		<div class="main-content-area">

			<%-- 🔐 Role-Based Switching Logic --%>
			<c:choose>


				<c:when
					test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">

					<div class="mb-5 text-center mt-3">
						<h2 class="fw-bold mb-2">
							<i class="bi bi-speedometer2 text-primary me-2"></i>Admin
							Overview Panel
						</h2>
						<div class="text-muted small">Real-time database system
							summary metrics info</div>
					</div>

					<div class="row g-4 justify-content-center">

						<!-- Total Users Circle -->
						<div class="col-md-4">
							<div
								class="card bg-white border-0 shadow-sm rounded-3 p-4 text-center h-100">
								<h6 class="text-muted fw-bold mb-3">
									<i class="bi bi-people-fill me-2 text-primary"></i>Total Users
								</h6>
								<div class="chart-box-container">
									<canvas id="usersCircleChart"></canvas>
								</div>
								<div class="fs-4 fw-bold mt-3 text-dark">
									<c:out
										value="${not empty totalUsers ? totalUsers : (not empty summary.totalUsers ? summary.totalUsers : 0)}" />
								</div>
							</div>
						</div>

						<!-- Total Categories Circle -->
						<div class="col-md-4">
							<div
								class="card bg-white border-0 shadow-sm rounded-3 p-4 text-center h-100">
								<h6 class="text-muted fw-bold mb-3">
									<i class="bi bi-tags-fill me-2 text-warning"></i>Total
									Categories
								</h6>
								<div class="chart-box-container">
									<canvas id="categoriesCircleChart"></canvas>
								</div>
								<div class="fs-4 fw-bold mt-3 text-dark">
									<c:out
										value="${not empty categorylist ? categorylist.size() : 0}" />
								</div>
							</div>
						</div>

						<!-- Total CheatSheets Circle -->
						<div class="col-md-4">
							<div
								class="card bg-white border-0 shadow-sm rounded-3 p-4 text-center h-100">
								<h6 class="text-muted fw-bold mb-3">
									<i class="bi bi-file-earmark-code-fill me-2 text-success"></i>Cheat
									Sheets
								</h6>
								<div class="chart-box-container">
									<canvas id="sheetsCircleChart"></canvas>
								</div>
								<div class="fs-4 fw-bold mt-3 text-dark">
									<c:out
										value="${not empty totalSheets ? totalSheets : (not empty summary.totalCheatsheets ? summary.totalCheatsheets : 0)}" />
								</div>
							</div>
						</div>

					</div>

				</c:when>


				<c:otherwise>

					<header class="hero-section mb-5">
						<div class="container-fluid px-2">
							<div class="row g-4 align-items-center">
								<div class="col-xl-7 text-center text-xl-start">
									<div
										class="text-uppercase small fw-bold tracking-wider mb-2 opacity-75">Quick
										references for every topic</div>
									<h1 class="hero-title mb-3">Developer Cheat Sheets</h1>
									<p class="fs-5 opacity-90 mb-0">Browse community cheat
										sheets, search fast, and jump into the newest references
										first.</p>
								</div>
								<div class="col-xl-5">
									<form action="${pageContext.request.contextPath}/home"
										method="get" class="search-panel shadow-sm">
										<div class="input-group">
											<span class="input-group-text bg-transparent border-0"><i
												class="bi bi-search text-muted"></i></span> <input type="search"
												class="form-control search-input" name="q"
												value="${searchQuery}" placeholder="Search cheat sheets...">
											<button class="btn btn-library px-4" type="submit">Search</button>
										</div>
									</form>
								</div>
							</div>
						</div>
					</header>

					<%-- Browse Categories Layout --%>
					<section class="mb-5" id="categories">
						<div class="d-flex align-items-end justify-content-between mb-4">
							<div>
								<h2 class="section-title h4 mb-1">Browse Categories</h2>
							</div>
						</div>
						<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
							<c:forEach items="${categorylist}" var="c">
								<div class="col">
									<a
										href="${pageContext.request.contextPath}/cheatsheet/category/${c.id}"
										class="card feature-card h-100 p-4 text-center bg-white">
										<div class="icon-box">
											<i class="bi bi-layers-half text-primary"></i>
										</div>
										<h5 class="card-title fw-bold text-dark mb-2">${c.name}</h5>
									</a>
								</div>
							</c:forEach>
						</div>
					</section>

					<%-- Cheat Sheets Latest Feed --%>
					<div class="d-flex align-items-center justify-content-between mb-4">
						<h2 class="section-title h4 mb-1">Latest Cheat Sheets</h2>
					</div>
					<div class="d-grid gap-3 mb-5">
						<c:forEach items="${cheatsheetlist}" var="sheet">
							<article class="sheet-card d-flex">
								<div
									class="sheet-ribbon p-3 d-flex align-items-center justify-content-center">
									<div class="sheet-pages">1</div>
								</div>
								<div class="p-3 flex-grow-1">
									<h3 class="h5 fw-bold mb-2">
										<a
											href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.id}"
											class="text-dark">${sheet.title}</a>
									</h3>
									<p class="text-secondary small mb-3">${sheet.description}</p>
								</div>
							</article>
						</c:forEach>
					</div>


					<jsp:include page="footer.jsp" />

				</c:otherwise>
			</c:choose>

		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

	<!-- 📊 JavaScript for Admin Circle Charts -->
	<c:if
		test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 1}">
		<script>
        const valUsers = ${not empty totalUsers ? totalUsers : (not empty summary.totalUsers ? summary.totalUsers : 0)};
        const valCategories = ${not empty categorylist ? categorylist.size() : 0};
        const valSheets = ${not empty totalSheets ? totalSheets : (not empty summary.totalCheatsheets ? summary.totalCheatsheets : 0)};

        const globalChartConfig = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            cutout: '75%'
        };

        new Chart(document.getElementById('usersCircleChart'), {
            type: 'doughnut',
            data: { datasets: [{ data: [valUsers, valUsers == 0 ? 1 : 0], backgroundColor: ['#1976d2', '#e9ecef'], borderWidth: 0 }] },
            options: globalChartConfig
        });

        new Chart(document.getElementById('categoriesCircleChart'), {
            type: 'doughnut',
            data: { datasets: [{ data: [valCategories, valCategories == 0 ? 1 : 0], backgroundColor: ['#ffc107', '#e9ecef'], borderWidth: 0 }] },
            options: globalChartConfig
        });

        new Chart(document.getElementById('sheetsCircleChart'), {
            type: 'doughnut',
            data: { datasets: [{ data: [valSheets, valSheets == 0 ? 1 : 0], backgroundColor: ['#2e7d32', '#e9ecef'], borderWidth: 0 }] },
            options: globalChartConfig
        });
    </script>
	</c:if>
</body>
</html>