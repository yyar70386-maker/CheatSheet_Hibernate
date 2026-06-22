<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Cheatsheet List</title>

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
}

.table tr:last-child td{
    border-bottom:none;
}

.btn-edit{
    background:#64b5f6;
    color:white;
    padding:8px 14px;
    border-radius:6px;
    text-decoration:none;
    font-weight:bold;
    margin-right:6px;
}

.btn-edit:hover{
    background:#42a5f5;
}

.btn-delete{
    background:#ef5350;
    color:white;
    padding:8px 14px;
    border-radius:6px;
    text-decoration:none;
    font-weight:bold;
}

.btn-delete:hover{
    background:#d32f2f;
}

.no-data{
    color:red;
    text-align:center;
    margin-top:50px;
    font-size:24px;
    font-weight:bold;
}

</style>

</head>
<body>

<div class="page-header">

    <h1 class="page-title">Cheatsheet List</h1>

    <a href="${pageContext.request.contextPath}/cheatsheet/add"
       class="btn-add">

        + Add Cheatsheet

    </a>

</div>

<c:choose>

    <c:when test="${empty cheatsheetlist}">

        <div class="no-data">
            No Cheatsheet Found!
        </div>

    </c:when>

    <c:otherwise>

        <table class="table">

            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Category</th>
                <th>Visibility</th>
                <th>Views</th>
                <th>Downloads</th>
                <th>Updated At</th>
                <th>Actions</th>
            </tr>

            <c:forEach items="${cheatsheetlist}" var="c">

                <tr>

                    <td>${c.id}</td>

                    <td>${c.title}</td>

                    <td>${c.category.name}</td>

                    <td>${c.visibility}</td>

                    <td>${c.viewCount}</td>

                    <td>${c.downloadCount}</td>

                    <td>${c.updatedAt}</td>

                    <td>

                        <a class="btn-edit"
                           href="${pageContext.request.contextPath}/cheatsheet/edit/${c.id}">
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