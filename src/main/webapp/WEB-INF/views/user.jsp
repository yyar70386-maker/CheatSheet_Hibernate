<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - User Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            height: 56px;
            z-index: 1030;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
        }
        .app-container {
            display: flex;
            height: calc(100vh - 56px); 
            width: 100%;
        }
        .admin-sidebar {
            width: 280px;
            height: 100%;
            flex-shrink: 0;
            overflow-y: auto; 
        }
        .main-content-area {
            flex-grow: 1;
            height: 100%;
            overflow-y: auto; 
            min-width: 0;
            padding: 24px;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="bg-light">

    <%-- 🧩 Header Navbar --%>
    <jsp:include page="header.jsp" />

    <div class="app-container">
        
        <%-- 🛠️ ဘယ်ဘက်ခြမ်း Sidebar --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="users" />
        </jsp:include>

        <%-- 📂 ညာဘက်ခြမ်း MAIN CONTENT AREA --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">User Management</h2>
                    <p class="text-muted m-0 small">Manage registered system users and their roles.</p>
                </div>
            </div>

            <%-- Action Alert Messages --%>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ${successMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <%-- 📊 Registered Users Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4" style="width: 15%;">ID</th>
                                    <th style="width: 35%;">Username</th>
                                    <th style="width: 20%;">Role</th>
                                    <th class="text-end pe-4" style="width: 30%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty users}">
                                        <c:forEach var="u" items="${users}">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">#${u.id}</td>
                                                <td>
                                                    <div class="fw-semibold text-dark">${u.username}</div>
                                                </td>
                                                <td>
                                                    <%-- Role အလိုက် Badge အရောင် ခွဲပြခြင်း (ဥပမာ- 1 ဆိုရင် Admin) --%>
                                                    <c:choose>
                                                        <c:when test="${u.role == 1}">
                                                            <span class="badge bg-danger-subtle text-danger px-2.5 py-1.5 rounded-pill small">ADMIN</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-primary-subtle text-primary px-2.5 py-1.5 rounded-pill small">USER</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <%-- 🗑️ Delete Button (နှိပ်လိုက်ရင် သေချာလား မေးမယ့် Javascript ပါဝင်ပါတယ်) --%>
                                                    <a href="${pageContext.request.contextPath}/users/delete?id=${u.id}" 
                                                       class="btn btn-sm btn-outline-danger rounded-2 px-3" 
                                                       onclick="return confirm('Are you sure you want to delete user \'${u.username}\'?');">
                                                        <i class="bi bi-trash me-1"></i> Delete
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="bi bi-people display-4 d-block mb-3 text-secondary"></i>
                                                No users found in the database.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>