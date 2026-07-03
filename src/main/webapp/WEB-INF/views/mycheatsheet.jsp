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
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    background:#eef3fb;
    padding:20px 10px;
}

.page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
}

.page-title{
    color:#1976d2;
    font-size:28px;
    font-weight:bold;
}

.btn-add{
    background:#1976d2;
    color:white;
    padding:12px 20px;
    text-decoration:none;
    border-radius:8px;
    font-weight:bold;
}

.btn-add:hover{
    background:#0d47a1;
}

.table{
    width:100%;
    border-collapse:collapse;
    background:white;
    border-radius:12px;
    overflow:hidden;
    box-shadow:0 4px 20px rgba(21,101,192,0.15);
}

.table th{
    background:#1976d2;
    color:white;
    padding:16px;
    text-align:left;
}

.table td{
    padding:16px;
    border-bottom:1px solid #e3f2fd;
    vertical-align: middle; /* ဒေတာများ အလယ်ကွက်တိ ဖြစ်စေရန် */
}

.table tr:last-child td{
    border-bottom:none;
}

/* 🌟 Tags Badge Styles */
.tag-badge {
    background-color: #e2e8f0;
    color: #4a5568;
    padding: 3px 10px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
    text-decoration: none;
    display: inline-block;
    margin-right: 4px;
    margin-top: 4px;
}

/* 🌟 Action Icon Buttons Styles */
.btn-icon-edit {
    color: #2196f3;
    font-size: 20px;
    margin-right: 12px;
    transition: color 0.2s ease;
    display: inline-block;
}

.btn-icon-edit:hover {
    color: #0b7dda;
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

<div class="page-header">
    <h1 class="page-title">My Cheatsheet List</h1>

    <a href="${pageContext.request.contextPath}/cheatsheet/add" class="btn-add">
        + Add Cheatsheet
    </a>
</div>

<c:choose>
    <c:when test="${empty cheatsheetlist}">
        <div class="no-data">
            You haven't created any cheat sheets yet!
        </div>
    </c:when>
    <c:otherwise>

        <table class="table">
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Category</th>
                <th>Tags</th> <!-- 🌟 Tags Column အသစ် ထည့်သွင်းခြင်း -->
                <th>Visibility</th>
                <th>Views</th>
                <th>Downloads</th>
                <th>Updated At</th>
                <th>Actions</th>
            </tr>

            <c:forEach items="${cheatsheetlist}" var="c">
                <tr>
                    <td>${c.id}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${c.id}" style="color:#1976d2; text-decoration:none; font-weight:bold;">
                            ${c.title}
                        </a>
                    </td>
                    <td>${c.category.name}</td>
                    
                    <!-- 🌟 Tags List ပြသပေးသည့် အပိုင်း -->
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

                    <td>${c.visibility}</td>
                    <td>${c.viewCount != null ? c.viewCount : 0}</td>
                    <td>${c.downloadCount != null ? c.downloadCount : 0}</td>
                    <td>${c.updatedAt}</td>
                    <td>
                        <!-- 🌟 စာသားအစား Pencil Icon ပြောင်းလဲခြင်း -->
                        <a class="btn-icon-edit" 
                           href="${pageContext.request.contextPath}/cheatsheet/edit/${c.id}" 
                           title="Edit Cheatsheet">
                            <i class="bi bi-pencil-square"></i>
                        </a>

                        <!-- 🌟 စာသားအစား Trash Icon ပြောင်းလဲခြင်း -->
                        <a class="btn-icon-delete"
						   href="${pageContext.request.contextPath}/cheatsheet/delete/${c.id}"
						   onclick="return confirm('Are you sure you want to delete this cheat sheet?');"
                           title="Delete Cheatsheet">
						    <i class="bi bi-trash3-fill"></i>
						</a>
                    </td>
                </tr>
            </c:forEach>
        </table>

    </c:otherwise>
</c:choose>

</body>
</html>