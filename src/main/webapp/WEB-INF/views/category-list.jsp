<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category List</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ffffff;
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
        .main-content-area {
            flex-grow: 1;
            height: 100%;
            overflow-y: auto; 
            min-width: 0;
            padding: 24px;
            background-color: #ffffff;
        }
        
        /* Custom Admin Pink/White Theme Overrides */
        .btn-primary { background-color: #ff3366 !important; border-color: #ff3366 !important; color: #ffffff !important; }
        .btn-primary:hover { background-color: #e62e5c !important; border-color: #e62e5c !important; }
        .btn-outline-primary { color: #ff3366 !important; border-color: #ff3366 !important; }
        .btn-outline-primary:hover { background-color: #ff3366 !important; color: white !important; }
        .text-primary { color: #ff3366 !important; }
    </style>
</head>
<body style="background-color: #ffffff;">

    <jsp:include page="header.jsp" />

    <div class="app-container">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="categories" />
        </jsp:include>
        
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Category List</h2>
                    <p class="text-muted m-0 small">Manage your system categories.</p>
                </div>
                <a href="${pageContext.request.contextPath}/category/add" class="btn px-4 fw-medium text-white shadow-sm" style="background: linear-gradient(135deg, #7209b7, #3f37c9); border: none; border-radius: 8px;">
                    <i class="bi bi-plus-circle me-2"></i>Add New Category
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead style="background: rgba(255, 51, 102, 0.9); color: white;" class="small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4" style="width: 10%;">No</th>
                                    <th style="width: 40%;">Name</th>
                                    <th style="width: 30%;">Created At</th>
                                    <th class="text-end pe-4" style="width: 20%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty categorylist}">
                                         <c:set var="counter" value="1"/>
                                         <c:forEach var="c" items="${categorylist}">
                                             <c:if test="${c.status != 'INACTIVE' && c.status != 'inactive'}">
                                                 <tr>
                                                     <td class="ps-4 fw-bold text-secondary">${counter}</td>
                                                     <td><span class="fw-semibold text-dark">${c.name}</span></td>
                                                     <td>${c.createdAt}</td>
                                                     <td class="text-end pe-4">
                                                         <a href="${pageContext.request.contextPath}/category/edit/${c.id}" class="btn btn-sm btn-outline-primary me-1 rounded-2">
                                                             <i class="bi bi-pencil-square"></i>
                                                         </a>
                                                         <a href="${pageContext.request.contextPath}/category/delete/${c.id}" 
                                                            class="btn btn-sm btn-outline-danger rounded-2" 
                                                            onclick="return confirm('Are you sure you want to delete this category?');">
                                                             <i class="bi bi-trash3-fill"></i>
                                                         </a>
                                                     </td>
                                                 </tr>
                                                 <c:set var="counter" value="${counter + 1}"/>
                                             </c:if>
                                         </c:forEach>
                                         <c:if test="${counter == 1}">
                                             <tr>
                                                 <td colspan="4" class="text-center py-5 text-muted">
                                                     <i class="bi bi-folder-x display-4 d-block mb-3" style="color: #ff3366;"></i>
                                                     No Category Found!
                                                 </td>
                                             </tr>
                                         </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="bi bi-folder-x display-4 d-block mb-3" style="color: #ff3366;"></i>
                                                No Category Found!
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
