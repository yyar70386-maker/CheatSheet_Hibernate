<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="header.jsp" />
<main class="container py-4">
    <h3 class="fw-bold mb-3">Send Notification</h3>
    <div class="bg-white border rounded-3 p-4 shadow-sm">
        <form method="post" action="${pageContext.request.contextPath}/admin/notifications/send">
            <div class="mb-3">
                <label class="form-label">User ID</label>
                <input class="form-control" type="number" name="userId" placeholder="Leave empty to broadcast">
            </div>
            <div class="mb-3">
                <label class="form-label">Title</label>
                <input class="form-control" name="title" maxlength="150" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Message</label>
                <textarea class="form-control" name="message" rows="5" required></textarea>
            </div>
            <button class="btn btn-primary" type="submit">Send Notification</button>
        </form>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
