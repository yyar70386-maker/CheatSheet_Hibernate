<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Tag Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body { background-color: #f8f9fa; min-height: 100vh; }
        .main-wrapper { display: flex; width: 100%; min-height: 100vh; }
        .sidebar-container { width: 280px; flex-shrink: 0; }
        .content-container { flex-grow: 1; padding: 40px; overflow-x: auto; }
        .management-card { background: white; border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.03); padding: 30px; }
        .custom-table th { background-color: #ff3366 !important; color: white !important; padding: 15px; font-weight: 600; }
        .custom-table td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #f1f3f5; }
        .btn-add-tag { background-color: #ff3366; color: white; font-weight: 600; border-radius: 8px; transition: all 0.2s; }
        .btn-add-tag:hover { background-color: #e62e5c; color: white; transform: translateY(-1px); }
        .badge-status { padding: 6px 12px; border-radius: 6px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; }
        .badge-active { background-color: rgba(25, 135, 84, 0.1); color: #198754; }
        .badge-inactive { background-color: rgba(220, 53, 69, 0.1); color: #dc3545; }
    </style>
</head>
<body>

<div class="main-wrapper">
    <!-- 🛑 ဘယ်ဘက် Sidebar အား activePage parameter ဖြင့် ဆွဲထည့်ခြင်း -->
    <div class="sidebar-container">
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="tags" />
        </jsp:include>
    </div>

    <!-- 🛑 ညာဘက် Content ဧရိယာ (Layout မပျက်ဘဲ ဒေတာများ ဝင်ရောက်လာမည့်နေရာ) -->
    <div class="content-container">
        <div class="container-fluid p-0">
            
            <!-- Page Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="fw-bold text-dark mb-1">Tag Management</h1>
                    <p class="text-secondary mb-0">Manage system tags, bind categories, and handle visibility statuses.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/tag/add" class="btn btn-add-tag shadow-sm px-4 py-2 d-flex align-items-center gap-2">
                        <i class="bi bi-plus-lg"></i> Add New Tag
                    </a>
                </div>
            </div>

            <!-- Main Management Card -->
            <div class="card management-card">
                <c:choose>
                    <c:when test="${empty taglist}">
                        <div class="text-center text-muted py-5">
                            <i class="bi bi-tags display-3 text-secondary mb-3 d-block"></i>
                            <h4 class="fw-bold">No Tags Found</h4>
                            <p class="mb-0">There are currently no tags registered in the system.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table custom-table mb-0">
                                <thead>
                                    <tr>
                                        <th style="border-top-left-radius: 10px; width: 80px;">S.NO</th>
                                        <th>TAG NAME</th>
                                        <th>CATEGORY</th>
                                        <th>STATUS</th>
                                        <th style="border-top-right-radius: 10px; width: 180px; text-align: center;">ACTIONS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${taglist}" var="t" varStatus="statusLoop">
                                        <tr>
                                            <td class="fw-bold text-secondary">${statusLoop.index + 1}</td>
                                            <td>
                                                <span class="fw-bold text-dark"><i class="bi bi-hash text-muted"></i>${t.name}</span>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-primary border border-primary-subtle px-2 py-1" style="font-size: 0.85rem;">
                                                    <i class="bi bi-folder2-open me-1"></i>${t.category.name}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.status == 'active'}">
                                                        <span class="badge badge-status badge-active"><i class="bi bi-check-circle-fill me-1"></i>Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-status badge-inactive"><i class="bi bi-x-circle-fill me-1"></i>${t.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-center gap-2">
                                                    <a class="btn btn-sm btn-outline-primary px-3 fw-bold" style="border-radius: 6px;"
                                                       href="${pageContext.request.contextPath}/tag/edit/${t.id}">
                                                        <i class="bi bi-pencil-square me-1"></i>Edit
                                                    </a>
                                                    <a class="btn btn-sm btn-outline-danger px-3 fw-bold" style="border-radius: 6px;"
                                                       href="${pageContext.request.contextPath}/category/delete/${t.id}"
                                                       onclick="return confirm('Are you sure you want to delete this tag?');">
                                                        <i class="bi bi-trash3-fill me-1"></i>Delete
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>