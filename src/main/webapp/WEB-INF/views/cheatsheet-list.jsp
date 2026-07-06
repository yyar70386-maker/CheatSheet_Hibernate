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
    background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
    min-height: 100vh;
}

.page-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
}

.page-title{
    color: #ff3366;
    font-size:28px;
    font-weight:bold;
}

.btn-add{
    background: #ff3366;
    color:white;
    padding:12px 20px;
    text-decoration:none;
    border-radius:8px;
    font-weight:bold;
    transition: background 0.3s;
}

.btn-add:hover{
    background: #e62e5c;
    color: white;
}

.table{
    width:100%;
    border-collapse:collapse;
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-radius:12px;
    overflow:hidden;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.6);
}

.table th{
    background: rgba(255, 51, 102, 0.8);
    color:white;
    padding:16px;
    text-align:left;
}

.table td{
    padding:16px;
    border-bottom:1px solid rgba(255, 255, 255, 0.8);
    color: #333;
}

.table tr:last-child td{
    border-bottom:none;
}

.btn-edit{
    background: #4facfe;
    color:white;
    padding:8px 14px;
    border-radius:6px;
    text-decoration:none;
    font-weight:bold;
    margin-right:6px;
}

.btn-edit:hover{
    background: #00c6fb;
    color: white;
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
    color: white;
}

.no-data{
    color: #ff3366;
    text-align:center;
    margin-top:50px;
    font-size:24px;
    font-weight:bold;
}

</style>

</head>
<body>
<jsp:include page="header.jsp" />

<div class="container mt-5 mb-5" style="max-width: 1200px; margin: 40px auto; padding: 0 20px;">
<div class="page-header">
    <div style="display:flex; align-items:center; gap: 15px;">
        <a href="javascript:history.back()" style="padding: 8px 15px; border-radius: 8px; text-decoration: none; border: 1px solid #6c757d; color: #6c757d; font-weight: bold; transition: 0.2s;" onmouseover="this.style.background='#6c757d'; this.style.color='#fff';" onmouseout="this.style.background='transparent'; this.style.color='#6c757d';">
            &#8592; Back
        </a>
        <h1 class="page-title">Cheatsheet List</h1>
    </div>

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
						   href="${pageContext.request.contextPath}/cheatsheet/delete/${c.id}"
						   onclick="return confirm('Are you sure you want to delete this cheatsheet?');">
						    Delete
						</a>

                    </td>

                </tr>

            </c:forEach>

        </table>

    </c:otherwise>

</c:choose>

</div>
<jsp:include page="footer.jsp" />
</body>
</html>