<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Tag List</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, sans-serif;
}

body{
    background:#f4f8ff;
    padding:40px;
}

.page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:30px;
}

.page-title{
    color:#1565c0;
    font-size:32px;
}

.btn-add{
    background:#1976d2;
    color:white;
    padding:12px 20px;
    text-decoration:none;
    border-radius:10px;
    font-weight:bold;
}

.btn-add:hover{
    background:#0d47a1;
}

.table{
    width:100%;
    border-collapse:collapse;
    background:white;
    border-radius:14px;
    overflow:hidden;
    box-shadow:0 4px 20px rgba(21,101,192,0.15);
}

.table th{
    background:#1976d2;
    color:white;
    padding:18px;
    text-align:left;
}

.table td{
    padding:18px;
    border-bottom:1px solid #e3f2fd;
    color:#222;
}

.btn-edit{
    background:#64b5f6;
    color:white;
    padding:9px 15px;
    text-decoration:none;
    border-radius:8px;
    font-weight:bold;
    margin-right:8px;
}

.btn-delete{
    background:#ef5350;
    color:white;
    padding:9px 15px;
    text-decoration:none;
    border-radius:8px;
    font-weight:bold;
}

.no-data{
    color:red;
    font-size:24px;
    text-align:center;
    margin-top:60px;
    font-weight:bold;
}
</style>

</head>
<body>

<div class="page-header">
    <h1 class="page-title">Tag List</h1>

    <a href="${pageContext.request.contextPath}/tag/add" class="btn-add">
        + Add Tag
    </a>
</div>

<c:choose>

    <c:when test="${empty taglist}">
        <div class="no-data">No Tag Found!</div>
    </c:when>

    <c:otherwise>

        <table class="table">
            <tr>
                <th>ID</th>
                <th>Tag Name</th>
                <th>Category</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>

            <c:forEach items="${taglist}" var="t">
                <tr>
                    <td>${t.id}</td>
                    <td>${t.name}</td>
                    <td>${t.category.name}</td>
                    <td>${t.status}</td>
                    <td>
                        <a class="btn-edit"
                           href="${pageContext.request.contextPath}/tag/edit/${t.id}">
                            Edit
                        </a>

                        <a class="btn-delete"
						   href="${pageContext.request.contextPath}/category/delete/${c.id}"
						   onclick="return confirm('Are you sure you want to delete this category?');">
						    Delete
						</a>
                    </td>
                </tr>
            </c:forEach>
        </table>

    </c:otherwise>

</c:choose>

</body>
</html>