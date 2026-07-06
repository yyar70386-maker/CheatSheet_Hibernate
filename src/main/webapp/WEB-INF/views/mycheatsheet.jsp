<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>My Cheatsheets</title>

<!-- Bootstrap & Bootstrap Icons CDN လင့်ခ်များ ထည့်သွင်းခြင်း -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
body{
    background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
    min-height: 100vh;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0;
    padding: 0;
}

.glass-box {
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border: 1px solid rgba(255, 255, 255, 0.6);
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    padding: 30px;
    margin-bottom: 40px;
}

.page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
    border-bottom: 2px solid rgba(255, 51, 102, 0.2);
    padding-bottom: 15px;
}

.page-title{
    color:#ff3366;
    font-size:28px;
    font-weight:bold;
    margin: 0;
}

.btn-add{
    background:#ff3366;
    color:white;
    padding:10px 20px;
    text-decoration:none;
    border-radius:8px;
    font-weight:bold;
    transition: background 0.3s;
}

.btn-add:hover{
    background:#e62e5c;
    color: white;
}

.table{
    width:100%;
    border-collapse:collapse;
    background: rgba(255, 255, 255, 0.6);
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 4px 20px rgba(0,0,0,0.03);
}

.table th{
    background:#ff3366;
    color:white;
    padding:16px;
    text-align:left;
}

.table td{
    padding:16px;
    border-bottom:1px solid rgba(0,0,0,0.05);
    vertical-align: middle;
}

.table tr:last-child td{
    border-bottom:none;
}

.tag-badge {
    background-color: rgba(255, 51, 102, 0.1);
    color: #ff3366;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
    text-decoration: none;
    display: inline-block;
    margin-right: 4px;
    margin-top: 4px;
}

.btn-icon-edit {
    color: #ff3366;
    font-size: 20px;
    margin-right: 12px;
    transition: color 0.2s ease;
    display: inline-block;
}

.btn-icon-edit:hover {
    color: #e62e5c;
}

.btn-icon-delete {
    color: #ef5350;
    font-size: 20px;
    transition: color 0.2s ease;
    display: inline-block;
}

.btn-icon-delete:hover {
    color: #c62828;
}

.no-data{
    color:#777;
    text-align:center;
    margin-top:50px;
    font-size:22px;
    font-weight:bold;
}
</style>

</head>
<body>

<jsp:include page="header.jsp" />

<div class="container py-5">
    <div class="glass-box">
        <div class="page-header">
            <h1 class="page-title">My Cheatsheet List</h1>

            <a href="${pageContext.request.contextPath}/cheatsheet/add" class="btn-add">
                <i class="bi bi-plus-circle me-1"></i> Add Cheatsheet
            </a>
        </div>

        <c:choose>
            <c:when test="${empty cheatsheetlist}">
                <div class="no-data py-5">
                    <i class="bi bi-file-earmark-code display-1 d-block mb-3 text-muted"></i>
                    You haven't created any cheat sheets yet!
                </div>
            </c:when>
            <c:otherwise>
            <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>No.</th> <!-- ID နေရာတွင် No. ဟု ပြောင်းလဲထားပါသည် -->
                                <th>Title</th>
                                <th>Category</th>
                                <th>Tags</th>
                                <th>Visibility</th>
                                <th>Status</th>
                                <th>Views</th>
                                <th>Downloads</th>
                                <th>Updated At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- varStatus="status" ကို ထည့်သွင်းပေးထားပါသည် -->
                            <c:forEach items="${cheatsheetlist}" var="c" varStatus="status">
                                <tr>
                                    <td>${status.count}</td> <!-- Database ID နေရာတွင် Loop ပတ်ထားသည့် အစဉ်လိုက်နံပါတ် (1,2,3...) ပြပေးထားပါသည် -->
                                    <td>
                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${c.obfuscatedId}" style="color:#ff3366; text-decoration:none; font-weight:bold;">
                                            ${c.title}
                                        </a>
                                    </td>
                                    <td>${c.category.name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty c.tags}">
                                                <span class="text-muted small">-</span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach items="${c.tags}" var="tag">
                                                    <span class="tag-badge">#${tag.name}</span>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary text-white px-2 py-1 rounded small">${c.visibility}</span>
                                    </td>
                                    <td>
                                         <c:choose>
                                             <c:when test="${c.status == 'draft'}">
                                                 <span class="badge bg-warning text-dark px-2 py-1 rounded small">Draft</span>
                                             </c:when>
                                             <c:when test="${c.status == 'banned'}">
                                                 <span class="badge bg-danger text-white px-2 py-1 rounded small">Banned</span>
                                                 <div class="text-danger small mt-1" style="font-size: 11px;">Reason: <c:out value="${c.bannedReason}"/></div>
                                             </c:when>
                                             <c:otherwise>
                                                 <span class="badge bg-success text-white px-2 py-1 rounded small">Published</span>
                                             </c:otherwise>
                                         </c:choose>
                                    </td>
                                    <td>${c.viewCount != null ? c.viewCount : 0}</td>
                                    <td>${c.downloadCount != null ? c.downloadCount : 0}</td>
                                    <td>${c.updatedAt}</td>
                                    <td>
                                        <a class="btn-icon-edit" 
                                           href="${pageContext.request.contextPath}/cheatsheet/edit/${c.obfuscatedId}" 
                                           title="Edit Cheatsheet">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a class="btn-icon-delete"
                                           href="${pageContext.request.contextPath}/cheatsheet/delete/${c.obfuscatedId}"
                                           onclick="return confirm('Are you sure you want to delete this cheat sheet?');"
                                           title="Delete Cheatsheet">
                                            <i class="bi bi-trash3-fill"></i>
                                        </a>
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

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>