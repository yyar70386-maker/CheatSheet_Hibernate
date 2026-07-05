<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .custom-footer { 
        /* Vibrant pink to deep coral-pink gradient background */
        background: linear-gradient(135deg, #ff3366, #ff5e84); 
        color: #ffffff; /* Main text changed to white for high contrast */
        padding: 48px 0 24px; 
        margin-top: auto; 
    }
    .custom-footer h5, .custom-footer h6 { 
        color: #ffffff; 
        font-weight: 800; 
        margin-bottom: 16px; 
    }
    .custom-footer p { 
        color: rgba(255, 255, 255, 0.85); /* Slightly translucent white for secondary text */
    }
    .custom-footer a { 
        color: rgba(255, 255, 255, 0.9); 
        text-decoration: none; 
        display: block; 
        margin-bottom: 10px; 
        transition: all .2s ease; 
        font-weight: 500; 
    }
    .custom-footer a:hover { 
        color: #1a1a1a; /* Turns dark gray on hover so it clearly stands out */
        padding-left: 2px; /* Subtle movement effect on hover */
    }
    .footer-brand-icon { 
        width:42px; 
        height:42px; 
        border-radius:12px; 
        background: #ffffff; /* Inverted background to white so it pops on the pink footer */
        color: #ff3366; /* Icon color becomes pink */
        display:inline-flex; 
        align-items:center; 
        justify-content:center; 
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15); 
    }
    .custom-footer .border-secondary { 
        border-color: rgba(255, 255, 255, 0.25) !important; /* Soft white horizontal divider line */
    }
</style>

<footer class="custom-footer">
    <div class="container">
        <div class="row g-4 text-start">
            <div class="col-lg-4">
                <div class="d-flex align-items-center gap-2 mb-3">
                    <span class="footer-brand-icon"><i class="bi bi-code-square"></i></span>
                    <h5 class="mb-0">KnowledgeHub</h5>
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
            <span>&copy; 2026 KnowledgeHub. All rights reserved.</span>
            <span style="color: rgba(255, 255, 255, 0.85);">Built for clean learning, sharing, and moderation.</span>
        </div>
    </div>
</footer>