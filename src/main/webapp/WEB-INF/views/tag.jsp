<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Tag - Admin Panel</title>
    
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
        .text-primary { color: #ff3366 !important; }
        .form-control:focus, .form-select:focus { border-color: #ff3366; box-shadow: 0 0 0 0.25rem rgba(255, 51, 102, 0.25); }
    </style>
</head>
<body style="background-color: #ffffff;">

    <jsp:include page="header.jsp" />

    <div class="app-container">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="tags" />
        </jsp:include>
        
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Add Tag</h2>
                    <p class="text-muted m-0 small">Create a new tag to organize cheatsheets.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/tags" class="btn btn-outline-secondary px-3 fw-medium">
                    <i class="bi bi-arrow-left me-2"></i>Back to List
                </a>
            </div>

            <div class="card border-0 shadow-sm rounded-3" style="max-width: 600px;">
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/tag/save" method="post">
                        
                        <div class="mb-4">
                            <label for="tagName" class="form-label fw-bold text-dark">Tag Name</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-secondary"><i class="bi bi-hash"></i></span>
                                <input type="text" 
                                       class="form-control" 
                                       id="tagName" 
                                       name="name" 
                                       placeholder="e.g., spring-boot, exception-handling" 
                                       required>
                            </div>
                            <div class="form-text text-muted">Use clear, short keywords (preferably lower-case with dashes).</div>
                        </div>

                        <div class="mb-4">
                            <label for="categorySelect" class="form-label fw-bold text-dark">Assign Category</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-secondary"><i class="bi bi-layers-half"></i></span>
                                <select class="form-select" id="categorySelect" name="category.id" required>
                                    <option value="" disabled selected>-- Select Target Category --</option>
                                    <c:forEach items="${categorylist}" var="cat">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-text text-muted">Select which structural category this tag belongs to.</div>
                        </div>

                        <input type="hidden" name="status" value="active">

                        <hr class="mt-4 mb-4" style="color: #e2e8f0;">

                        <div class="d-flex justify-content-end gap-3">
                            <a href="${pageContext.request.contextPath}/admin/tags" class="btn btn-outline-secondary px-4 fw-medium">
                                Cancel
                            </a>
                            <button type="submit" class="btn btn-primary d-flex align-items-center px-4 gap-2 fw-medium">
                                <i class="bi bi-check-circle-fill"></i> Save Tag
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>