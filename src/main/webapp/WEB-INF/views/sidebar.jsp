<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 🛠️ ADMIN SIDEBAR (ရေးထားတာ ၁ ဖိုင်တည်းပါပဲ) --%>
<c:if test="${currentUser.role == 1}">
    <div class="d-flex flex-column flex-shrink-0 p-3 text-white bg-dark admin-sidebar"
        style="box-shadow: 2px 0 5px rgba(0, 0, 0, 0.05);">
        <a href="#" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
            <i class="bi bi-shield-lock-fill me-2 fs-4 text-warning"></i> 
            <span class="fs-4 fw-bold">Admin Panel</span>
        </a>
        <hr>

        <ul class="nav nav-pills flex-column mb-auto">
            <li>
                <a href="${pageContext.request.contextPath}/home" 
                   class="nav-link text-white ${param.activePage == 'dashboard' ? 'active' : '🌟'}"> 
                    <i class="bi bi-speedometer2 me-2"></i> Dashboard
                </a>
            </li>

            <li class="text-secondary small fw-bold mt-3 mb-1 px-2 text-uppercase">Management</li>

            <li>
                <a href="${pageContext.request.contextPath}/categories" 
                   class="nav-link text-white ${param.activePage == 'categories' ? 'active' : '🌟'}"> 
                    <i class="bi bi-tags me-2"></i> Category Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/tag" 
                   class="nav-link text-white ${param.activePage == 'items' ? 'active' : '🌟'}"> 
                    <i class="bi bi-box-seam me-2 text-muted"></i> Tag Management
                </a>
            </li>

            <li>
                <a href="${pageContext.request.contextPath}/users" 
                   class="nav-link text-white ${param.activePage == 'users' ? 'active' : '🌟'}"> 
                    <i class="bi bi-people me-2 text-muted"></i> User Management
                </a>
            </li>
        </ul>
    </div>
</c:if>