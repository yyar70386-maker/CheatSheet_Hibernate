<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - JWD Project</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="height: 100vh;">

    <div class="card p-4 shadow-sm border-0" style="max-width: 420px; width: 100%; border-radius: 12px;">
        <h4 class="fw-bold text-dark mb-2">
            <i class="bi bi-key-fill text-warning me-2"></i>Reset Password
        </h4>
        <p class="text-muted small mb-4">
            Enter your registered email address below and we will send you instructions to reset your password.
        </p>
        
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success d-flex align-items-center py-2 small" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger d-flex align-items-center py-2 small" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
            </div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/forgot-password" method="POST">
            <div class="mb-4">
                <label class="form-label text-secondary small fw-medium">Your Email Address</label>
                <div class="input-group">
                    <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control bg-white border-start-0" style="padding: 10px;" placeholder="name@example.com" value="${param.email}" required>
                </div>
            </div>
            
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary flex-fill" style="border-radius: 6px; padding: 10px;">
                    Back to Login
                </a>
                <button type="submit" class="btn btn-success flex-fill fw-medium" style="background-color: #198754; border: none; border-radius: 6px; padding: 10px;">
                    <i class="bi bi-send me-1"></i> Send Link
                </button>
            </div>
        </form>
    </div>

</body>
</html>