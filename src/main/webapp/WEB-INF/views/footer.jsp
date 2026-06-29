<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .custom-footer { background-color: #212529; color: #adb5bd; padding: 40px 0 20px; margin-top: auto; }
    .custom-footer h5 { color: #fff; font-weight: bold; margin-bottom: 20px; }
    .custom-footer a { color: #adb5bd; text-decoration: none; transition: 0.3s; }
    .custom-footer a:hover { color: #fff; }
</style>

<footer class="custom-footer">
    <div class="container">
        <div class="row text-center text-md-start">
            <div class="col-md-6 mb-4">
                <h5><i class="bi bi-code-slash text-primary me-2"></i> CheatSheet Hub</h5>
                <p class="small">A collaborative learning platform built with Spring MVC and Hibernate. Find the best guides and resources.</p>
            </div>
            <div class="col-md-6 mb-4 text-md-end">
                <h5>Quick Links</h5>
                <a href="${pageContext.request.contextPath}/home" class="me-3">Home</a>
                <a href="${pageContext.request.contextPath}/cheatsheet/list" class="me-3">All Sheets</a>
                <a href="#">Contact Support</a>
            </div>
        </div>
        <hr class="border-secondary">
        <div class="text-center small mt-3">
            &copy; 2026 CheatSheet Project Team. All Rights Reserved.
        </div>
    </div>
</footer>