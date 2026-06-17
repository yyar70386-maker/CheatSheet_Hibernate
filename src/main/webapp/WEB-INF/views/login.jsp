<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">
    <div class="card p-4 shadow" style="width: 400px;">
        <h3 class="text-center mb-4">Sign In</h3>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${param.success == 'registered'}">
            <div class="alert alert-success">Register successfully. Please login</div>
        </c:if>
        <c:if test="${param.success == 'password_reset'}">
            <div class="alert alert-success">New password has been changed, please login.</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <input type="email" name="email" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <div class="mb-3 text-end">
                <a href="forgot-password" class="small text-decoration-none">Forgot Password?</a>
            </div>
            <button type="submit" class="btn btn-success w-100">Login</button>
        </form>
        <p class="text-center mt-3 small">Don't have an account yet? <a href="register">Register</a></p>
    </div>
</body>
</html>