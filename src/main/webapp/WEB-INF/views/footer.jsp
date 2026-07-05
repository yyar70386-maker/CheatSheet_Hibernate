<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .custom-footer { 
        background: rgba(255, 255, 255, 0.45); 
        backdrop-filter: blur(16px); 
        -webkit-backdrop-filter: blur(16px); 
        border-top: 1px solid rgba(255, 255, 255, 0.6); 
        color: #1a1a1a; 
        padding: 48px 0 24px; 
        margin-top: auto; 
    }
    .custom-footer h5, .custom-footer h6 { color: #1a1a1a; font-weight: 800; margin-bottom: 16px; }
    .custom-footer p { color: #444; }
    .custom-footer a { color: #555; text-decoration: none; display: block; margin-bottom: 10px; transition: color .2s ease; font-weight: 500; }
    .custom-footer a:hover { color: #ff3366; }
    .footer-brand-icon { width:42px; height:42px; border-radius:12px; background: linear-gradient(135deg, rgba(255, 51, 102, 0.8), rgba(255, 102, 153, 0.8)); color:#fff; display:inline-flex; align-items:center; justify-content:center; box-shadow: 0 4px 10px rgba(255, 51, 102, 0.3); }
    .custom-footer .border-secondary { border-color: rgba(26, 26, 26, 0.2) !important; }
</style>

<footer class="custom-footer">
    <div class="container">
        <div class="row g-4 text-start">
            <div class="col-lg-4">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="footer-brand-icon"><i class="bi bi-code-square"></i></span>
                    <h5 class="mb-0">CheatSheetsHub</h5>
                </div>
                <p class="small mb-0">A collaborative reference hub for concise, practical cheat sheets across development topics.</p>
            </div>
            <div class="col-6 col-lg-2">
                <h6>Explore</h6>
                <a href="${pageContext.request.contextPath}/home">Home</a>
                <a href="${pageContext.request.contextPath}/home#latest-sheets">CheatSheets</a>
                <a href="${pageContext.request.contextPath}/cheatsheet/list">List</a>
            </div>
            <div class="col-6 col-lg-2">
                <h6>Community</h6>
                <a href="${pageContext.request.contextPath}/announcements">Announcements</a>
                <a href="${pageContext.request.contextPath}/profile">Creators</a>
                <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
            </div>
            <div class="col-6 col-lg-2">
                <h6>Create</h6>
                <a href="${pageContext.request.contextPath}/cheatsheet/add">New CheatSheet</a>
                <a href="${pageContext.request.contextPath}/profile">My Profile</a>
            </div>
            <div class="col-6 col-lg-2">
                <h6>Admin</h6>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/reports">Reports</a>
            </div>
        </div>
        <hr class="border-secondary my-4">
        <div class="d-flex flex-column flex-md-row justify-content-between gap-2 small">
            <span>&copy; 2026 CheatSheetsHub. All rights reserved.</span>
            <span>Built for clean learning, sharing, and moderation.</span>
        </div>
    </div>
</footer>
