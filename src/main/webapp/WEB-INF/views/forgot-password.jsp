<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Reset Password</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>

body{
	min-height:100vh;
	display:flex;
	justify-content:center;
	align-items:center;
	background:linear-gradient(135deg,#4facfe,#00c6fb);
	font-family:"Segoe UI",sans-serif;
	padding:20px;
}

.reset-card{
	width:100%;
	max-width:450px;
	background:rgba(255,255,255,0.95);
	border:none;
	border-radius:20px;
	padding:35px;
	box-shadow:0 25px 50px rgba(0,0,0,0.15);
	animation:fadeUp .5s ease;
}

.icon{
	width:70px;
	height:70px;
	margin:auto;
	border-radius:50%;
	background:linear-gradient(135deg,#ffc107,#ff9800);
	display:flex;
	align-items:center;
	justify-content:center;
	color:white;
	font-size:30px;
	margin-bottom:15px;
	box-shadow:0 10px 20px rgba(255,193,7,.3);
}

h4{
	font-weight:bold;
	text-align:center;
}

.sub{
	text-align:center;
	font-size:14px;
	color:#666;
	margin-bottom:25px;
}

.input-group-text{
	background:#fff;
	border-right:none;
}

.form-control{
	height:48px;
	border-left:none;
}

.form-control:focus{
	box-shadow:none;
	border-color:#0d6efd;
}

.btn-success{
	height:48px;
	border-radius:12px;
	background:linear-gradient(135deg,#198754,#20c997);
	border:none;
	font-weight:600;
}

.btn-success:hover{
	transform:translateY(-2px);
	box-shadow:0 10px 20px rgba(25,135,84,.3);
}

.btn-outline-secondary{
	height:48px;
	border-radius:12px;
}

.alert{
	border-radius:12px;
}

@keyframes fadeUp{
	from{
		opacity:0;
		transform:translateY(30px);
	}
	to{
		opacity:1;
		transform:translateY(0);
	}
}

</style>

</head>

<body>

<div class="reset-card">

	<div class="icon">
		<i class="bi bi-key-fill"></i>
	</div>

	<h4>Reset Password</h4>

	<p class="sub">
		Enter your email and we will send reset instructions
	</p>

	<c:if test="${not empty successMessage}">
		<div class="alert alert-success text-center">
			<i class="bi bi-check-circle-fill"></i>
			${successMessage}
		</div>
	</c:if>

	<c:if test="${not empty errorMessage}">
		<div class="alert alert-danger text-center">
			<i class="bi bi-exclamation-triangle-fill"></i>
			${errorMessage}
		</div>
	</c:if>

	<form action="${pageContext.request.contextPath}/forgot-password"
		method="POST">

		<div class="mb-4">

			<label class="form-label">Email Address</label>

			<div class="input-group">

				<span class="input-group-text">
					<i class="bi bi-envelope"></i>
				</span>

				<input type="email"
					   name="email"
					   class="form-control"
					   placeholder="name@example.com"
					   value="${param.email}"
					   required>

			</div>

		</div>

		<div class="d-grid gap-2">

			<button type="submit" class="btn btn-success text-white">
				<i class="bi bi-send"></i> Send Reset Link
			</button>

			<a href="${pageContext.request.contextPath}/login"
			   class="btn btn-outline-secondary">
				Back to Login
			</a>

		</div>

	</form>

</div>

</body>
</html>