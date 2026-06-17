<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Register</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center"
	style="height: 100vh;">
	<div class="card p-4 shadow" style="width: 400px;">
		<h3 class="text-center mb-4">Create Account</h3>

	
		<c:if test="${not empty error}">
			<div class="alert alert-danger alert-dismissible fade show"
				role="alert">
				<i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
		</c:if>

		<form action="${pageContext.request.contextPath}/register"
			method="POST">
			<div class="mb-3">
				<label class="form-label">Username</label> <input type="text"
					name="username" class="form-content form-control" required>
			</div>
			<div class="mb-3">
				<label class="form-label">Email Address</label> <input type="email"
					name="email" class="form-control" required>
			</div>
			<div class="mb-3">
				<label class="form-label">Full Name</label> <input type="text"
					name="fullName" class="form-control" required>
			</div>
			<div class="mb-3">
				<label class="form-label">Password</label> <input type="password"
					name="password" class="form-control" required>
			</div>
			<div class="mb-3">
				<label class="form-label">Confirm Password</label> <input
					type="password" name="confirmPassword" class="form-control"
					required>
			</div>
			<div class="d-flex gap-2 mt-4">
    <button type="submit" class="btn btn-primary w-50">Sign Up</button>
    
    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary w-50 d-flex align-items-center justify-content-center">
        Cancel
    </a>
</div>
		</form>
		<p class="text-center mt-3 small">
			Already have an account? <a href="login">Login</a>
		</p>
	</div>
</body>
</html>