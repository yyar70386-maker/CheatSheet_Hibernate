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
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: "Segoe UI", sans-serif;
}

body {
	min-height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
	padding: 20px;
}

.login-card {
	width: 100%;
	max-width: 430px;
	background: rgba(255, 255, 255, 0.45);
	backdrop-filter: blur(16px);
	-webkit-backdrop-filter: blur(16px);
	border: 1px solid rgba(255, 255, 255, 0.6);
	border-radius: 20px;
	padding: 35px;
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
	animation: fadeUp .6s ease;
}

.logo {
	width: 80px;
	height: 80px;
	margin: auto;
	border-radius: 50%;
	background: linear-gradient(135deg, rgba(255, 51, 102, 0.9),
		rgba(255, 102, 153, 0.9));
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 35px;
	color: white;
	margin-bottom: 20px;
	box-shadow: 0 10px 20px rgba(255, 51, 102, .3);
}

h2 {
	font-weight: bold;
	color: #222;
}

.subtitle {
	color: #777;
	font-size: 15px;
	margin-bottom: 30px;
}

.form-label {
	font-weight: 600;
	color: #555;
}

.input-group-text {
	background: #fff;
	border-right: none;
	border-radius: 12px 0 0 12px;
}

.form-control {
	height: 50px;
	border-left: none;
	border-radius: 0 12px 12px 0;
}

.form-control:focus {
	box-shadow: none;
	border-color: #ff3366;
}

.input-group:focus-within .input-group-text {
	border-color: #ff3366;
}

.password-btn {
	border-radius: 0 12px 12px 0;
}

.btn-login {
	height: 50px;
	border: none;
	border-radius: 12px;
	background: linear-gradient(135deg, rgba(255, 51, 102, 0.9),
		rgba(255, 102, 153, 0.9));
	font-weight: 600;
	transition: .3s;
}

.btn-login:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 20px rgba(255, 51, 102, .3);
}

.btn-cancel {
	height: 50px;
	border-radius: 12px;
	font-weight: 600;
}

.register-text {
	font-size: 14px;
	color: #666;
}

.alert {
	border-radius: 12px;
}

@
keyframes fadeUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

.logo-text {
	width: 90px;
	height: 90px;
	margin: auto;
	margin-bottom: 20px;
	border-radius: 50%;
	background: linear-gradient(135deg, rgba(255, 51, 102, 0.9),
		rgba(255, 102, 153, 0.9));
	display: flex;
	justify-content: center;
	align-items: center;
	color: white;
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	box-shadow: 0 10px 20px rgba(255, 51, 102, .3);
}
}
</style>

</head>

<body>

	<div class="login-card">

		<div class="logo">
			<i class="bi bi-shield-lock"></i>
		</div>
		<h3 class="text-center fw-bold mb-3" style="color: #ff3366;">CheatSheet</h3>

		<h2 class="text-center">Welcome Back</h2>

		<p class="text-center subtitle">Sign in to continue</p>


		<c:if test="${not empty loginError}">
			<div class="alert alert-danger text-center rounded-3 shadow-sm">
				<i class="bi bi-exclamation-triangle-fill me-2"></i> ${loginError}
			</div>
		</c:if>


		<c:if test="${param.success == 'password_changed'}">
			<div class="alert alert-success text-center rounded-3 shadow-sm">
				<i class="bi bi-check-circle-fill me-2"></i> Password changed
				successfully! Please login again.
			</div>
		</c:if>


		<c:if test="${not empty errorMessage}">
			<div class="alert alert-danger text-center rounded-3 shadow-sm">
				<i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
			</div>
		</c:if>
		<form action="${pageContext.request.contextPath}/login" method="POST">

			<div class="mb-3">

				<label class="form-label"> Email Address </label>

				<div class="input-group">

					<span class="input-group-text"> <i
						class="bi bi-envelope-fill"></i>
					</span> <input type="email" name="email" class="form-control"
						placeholder="Enter your email" required>

				</div>

			</div>

			<div class="mb-3">

				<label class="form-label"> Password </label>

				<div class="input-group">

					<span class="input-group-text"> <i class="bi bi-lock-fill"></i>
					</span> <input type="password" name="password" id="password"
						class="form-control" placeholder="Enter password" required>

					<button type="button"
						class="btn btn-outline-secondary password-btn"
						onclick="togglePassword()">

						<i class="bi bi-eye" id="eyeIcon"></i>

					</button>

				</div>

			</div>

			<div class="d-flex justify-content-end align-items-center mb-4">

				<a href="${pageContext.request.contextPath}/forgot-password"
					class="text-decoration-none"> Forgot Password? </a>

			</div>

			<div class="d-grid gap-2">

				<button type="submit" class="btn btn-login text-white">

					<i class="bi bi-box-arrow-in-right"></i> Login

				</button>

				<a href="${pageContext.request.contextPath}/"
					class="btn btn-outline-secondary btn-cancel"> <i
					class="bi bi-arrow-left-circle"></i> Back Home

				</a>

			</div>

		</form>

		<hr>

		<div class="text-center register-text">

			Don't have an account? <a
				href="${pageContext.request.contextPath}/register"
				class="fw-bold text-decoration-none"> Register Now </a>

		</div>

	</div>

	<c:if test="${param.error == 'login_required'}">
		<div class="position-fixed top-0 start-50 translate-middle-x mt-3">
			<div class="alert alert-danger shadow">⚠️ Please login first!</div>
		</div>
	</c:if>

	<c:if test="${param.error == 'admin_only'}">
		<div class="position-fixed top-0 start-50 translate-middle-x mt-3">
			<div class="alert alert-danger shadow">🚫 Admin access only!</div>
		</div>
	</c:if>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
		
	</script>

	<script>
		function togglePassword() {

			const password = document.getElementById("password");
			const eye = document.getElementById("eyeIcon");

			if (password.type === "password") {

				password.type = "text";

				eye.classList.remove("bi-eye");
				eye.classList.add("bi-eye-slash");

			} else {

				password.type = "password";

				eye.classList.remove("bi-eye-slash");
				eye.classList.add("bi-eye");

			}

		}
	</script>

</body>
</html>