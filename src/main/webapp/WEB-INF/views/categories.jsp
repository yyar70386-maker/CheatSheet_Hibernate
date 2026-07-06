<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Category Management</title>
    
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
        .table img {
            object-fit: cover;
        }
        
        /* Custom Admin Pink/White Theme Overrides */
        .btn-primary { background-color: #ff3366 !important; border-color: #ff3366 !important; color: #ffffff !important; }
        .btn-primary:hover { background-color: #e62e5c !important; border-color: #e62e5c !important; }
        .btn-outline-primary { color: #ff3366 !important; border-color: #ff3366 !important; }
        .btn-outline-primary:hover { background-color: #ff3366 !important; color: white !important; }
        .text-primary { color: #ff3366 !important; }
        .main-content-area { background-color: #ffffff; }
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
                    <h2 class="fw-bold text-dark m-0">Category Management</h2>
                    <p class="text-muted m-0 small">Create, edit and manage your system categories.</p>
                </div>
                <%-- Modal Target ကို #categoryModal သို့ ပြောင်းလဲထားပါသည် --%>
                <button class="btn btn-primary px-3 fw-medium" data-bs-toggle="modal" data-bs-target="#categoryModal">
                    <i class="bi bi-plus-circle me-2"></i>Add New Category
                </button>
            </div>

            <%-- Alert Messages --%>
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

            <%-- Data Table Card --%>
            <div class="card border-0 shadow-sm rounded-3">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light text-secondary small fw-bold text-uppercase">
                                <tr>
                                    <%-- 📌 ပြင်ဆင်ချက် (၁): ID နေရာတွင် No ဟု ပြောင်းလဲပေးထားပါသည် --%>
                                    <th class="ps-4" style="width: 10%;">No</th>
                                    <th style="width: 50%;">Category Name</th>
                                    <th style="width: 20%;">Status</th>
                                    <th class="text-end pe-4" style="width: 20%;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty categories}">
                                        <%-- 📌 ပြင်ဆင်ချက် (၂): Auto စီရန် varStatus="status" ကို ဖြည့်စွက်ထားပါသည် --%>
                                        <c:forEach var="cat" items="${categories}" varStatus="status">
                                            <tr>
                                                <%-- 📌 ပြင်ဆင်ချက် (၃): ဒေတာဘေ့စ် ID အစား ပတ်လမ်းအလိုက် Auto ပြန်စီပေးမည့် ${status.count} အား သုံးထားပါသည် --%>
                                                <td class="ps-4 fw-bold text-secondary">${status.count}</td>
                                                <td><span class="fw-semibold text-dark">${cat.name}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${cat.status == 'ACTIVE'}">
                                                            <span class="badge bg-success-subtle text-success px-2.5 py-1.5 rounded-pill small">ACTIVE</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger-subtle text-danger px-2.5 py-1.5 rounded-pill small">INACTIVE</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <%-- 📌 ပြင်ဆင်ချက် (၄): Controller Path အသစ်အတိုင်း URL များကို Path Variable ပုံစံသို့ ပြောင်းလဲထားပါသည် --%>
                                                    <a href="${pageContext.request.contextPath}/categories/edit/${cat.id}" class="btn btn-sm btn-outline-primary me-1 rounded-2">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/categories/delete/${cat.id}" 
                                                       class="btn btn-sm btn-outline-danger rounded-2" 
                                                       onclick="return confirm('Are you sure you want to delete this category?');">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center py-5 text-muted">
                                                <i class="bi bi-folder-x display-4 d-block mb-3 text-secondary"></i>
                                                No categories available inside database.
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

    <div class="modal fade" id="categoryModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="modalTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-light border-0 py-3">
                    <h5 class="modal-title fw-bold text-dark" id="modalTitle">
                        <c:choose>
                            <c:when test="${isEdit}"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit Category</c:when>
                            <c:otherwise><i class="bi bi-plus-circle me-2 text-primary"></i>Add New Category</c:otherwise>
                        </c:choose>
                    </h5>
                    <a href="${pageContext.request.contextPath}/categories" class="btn-close"></a>
                </div>
                
                <%-- Edit Mode ပေါ်မူတည်ပြီး သက်ဆိုင်ရာ Controller Action ဆီသို့ ပို့ပေးခြင်း --%>
                <form action="${pageContext.request.contextPath}/categories/${isEdit ? 'update' : 'add'}" method="POST">
                    <div class="modal-body p-4">
                        
                        <input type="hidden" name="id" value="${categoryAttr.id}" />

                        <div class="mb-3">
                            <label class="form-label fw-semibold text-secondary small text-uppercase">Category Name</label>
                            <input type="text" name="name" class="form-control form-control-lg fs-6" 
                                   value="${categoryAttr.name}" placeholder="Enter category name" required autocomplete="off" />
                        </div>

                        <c:if test="${isEdit}">
                            <div class="mb-3">
                                <label class="form-label fw-semibold text-secondary small text-uppercase">Status</label>
                                <select name="status" class="form-select form-control-lg fs-6">
                                    <option value="ACTIVE" ${categoryAttr.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                    <option value="INACTIVE" ${categoryAttr.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                </select>
                            </div>
                        </c:if>

                    </div>
                    <div class="modal-footer border-0 bg-light py-2.5">
                        <a href="${pageContext.request.contextPath}/categories" class="btn btn-light px-3 fw-medium">Cancel</a>
                        <button type="submit" class="btn btn-primary px-4 fw-medium">
                            <c:choose>
                                <c:when test="${isEdit}">Save Changes</c:when>
                                <c:otherwise>Submit</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <%-- 📌 ပြင်ဆင်ချက် (၅): Edit Button ကို နှိပ်လိုက်ပါက Modal အား Dynamic နည်းလမ်းဖြင့် Auto ပွင့်လာစေမည့် JavaScript --%>
    <c:if test="${isEdit}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                var categoryModal = new bootstrap.Modal(document.getElementById('categoryModal'));
                categoryModal.show();
            });
        </script>
    </c:if>
</body>
</html>