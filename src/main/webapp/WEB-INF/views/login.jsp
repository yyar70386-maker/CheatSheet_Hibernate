<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sign In - Cheat Sheet Project</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
body {
	background-color: #f8f9fa;
	height: 100vh;
}

.login-card {
	border: none;
	border-radius: 12px;
	box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
	max-width: 420px;
	width: 100%;
	background: #ffffff;
}

.form-control {
	background-color: #edf2f9;
	border: 1px solid #edf2f9;
	padding: 10px 14px;
}

.form-control:focus {
	background-color: #fff;
	border-color: #cbd5e1;
	box-shadow: none;
}

.btn-login {
	background-color: #198754;
	color: white;
	border: none;
	padding: 10px;
}

.btn-login:hover {
	background-color: #157347;
	color: white;
}

.btn-cancel {
	padding: 10px;
}
</style>
</head>
<body class="d-flex align-items-center justify-content-center">

	<div class="card login-card p-4 mx-3">
		<h2 class="text-center fw-bold mb-4" style="color: #212529;">Sign
			In</h2>

		<c:if test="${not empty loginError}">
    <div class="alert alert-danger text-center small fw-bold mb-3" role="alert">
        ⚠️ ${loginError}
    </div>
</c:if>

		<form action="${pageContext.request.contextPath}/login" method="POST">
			<div class="mb-3">
				<label class="form-label text-secondary small fw-medium">Email
					Address</label> <input type="email" name="email" class="form-control"
					placeholder="Enter your email" required>
			</div>

			<div class="mb-2">
				<label class="form-label text-secondary small fw-medium">Password</label>
				<input type="password" name="password" class="form-control"
					placeholder="••••" required>
			</div>

			<div class="text-end mb-4">
				<a href="${pageContext.request.contextPath}/forgot-password"
					class="text-decoration-none small text-primary"> <i
					class="bi bi-question-circle me-1"></i>Forgot Password?
				</a>
			</div>

			<div class="d-flex gap-2 mb-3">
				<a href="${pageContext.request.contextPath}/"
					class="btn btn-outline-secondary btn-cancel flex-fill"> <i
					class="bi bi-x-circle me-1"></i> Cancel
				</a>
				<button type="submit" class="btn btn-login flex-fill fw-medium">
					Login</button>
			</div>

			<div class="text-center pt-2">
				<span class="text-muted small">Don't have an account yet? </span> <a
					href="${pageContext.request.contextPath}/register"
					class="text-decoration-none small text-primary fw-medium">Register</a>
			</div>
		</form>
	</div>

	<c:if test="${param.error == 'login_required'}">
		<div class="alert alert-danger text-center font-weight-bold">⚠️
			Please login first to access that page!</div>
	</c:if>

	<c:if test="${param.error == 'admin_only'}">
		<div class="alert alert-danger text-center font-weight-bold">🚫
			Access Denied: Admin privileges required!</div>
	</c:if>
</body>
</html>