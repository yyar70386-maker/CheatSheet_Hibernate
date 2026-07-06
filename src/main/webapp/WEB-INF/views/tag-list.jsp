<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tag List</title>
    
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
            <jsp:param name="activePage" value="items" />
        </jsp:include>
        
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Tag List</h2>
                    <p class="text-muted m-0 small">Manage your system tags.</p>
                </div>
                <a href="${pageContext.request.contextPath}/tag/add" class="btn btn-primary px-3 fw-medium">
                    <i class="bi bi-plus-circle me-2"></i>Add New Tag
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead style="background: rgba(255, 51, 102, 0.9); color: white;" class="small fw-bold text-uppercase">
                                <tr>
                                    <th class="ps-4" style="width: 10%;">No</th>
                                    <th style="width: 25%;">Tag Name</th>
                                    <th style="width: 25%;">Category</th>
                                    <th style="width: 20%;">Status</th>
                                    <th class="text-end pe-4" style="width: 20%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty taglist}">
                                        <c:forEach var="t" items="${taglist}" varStatus="statusLoop">
                                            <tr>
                                                <td class="ps-4 fw-bold text-secondary">${statusLoop.index + 1}</td>
                                                <td><span class="fw-semibold text-dark">${t.name}</span></td>
                                                <td><span class="text-secondary">${t.category.name}</span></td>
                                                <td>
                                                    <span class="badge ${t.status == 'ACTIVE' ? 'bg-success-subtle text-success' : 'bg-secondary-subtle text-secondary'} px-2 py-1 rounded-pill small">
                                                        ${t.status}
                                                    </span>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <a href="${pageContext.request.contextPath}/tag/edit/${t.id}" class="btn btn-sm btn-outline-primary me-1 rounded-2">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/tag/delete/${t.id}" 
                                                       class="btn btn-sm btn-outline-danger rounded-2" 
                                                       onclick="return confirm('Are you sure you want to delete this tag?');">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="bi bi-tags display-4 d-block mb-3" style="color: #ff3366;"></i>
                                                No Tag Found!
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
