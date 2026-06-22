<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Cheatsheet</title>

<style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, sans-serif;
}

body{
    background:#f4f8ff;
}

.container{
    width:900px;
    margin:40px auto;
    background:white;
    padding:40px;
    border-radius:18px;
    border:2px solid #bbdefb;
    box-shadow:0 4px 20px rgba(21,101,192,0.15);
}

.form-icon{
    text-align:center;
    font-size:55px;
    color:#1976d2;
    margin-bottom:15px;
}

h1{
    text-align:center;
    color:#1565c0;
    margin-bottom:35px;
    font-size:40px;
}

.form-group{
    margin-bottom:25px;
}

label{
    display:block;
    margin-bottom:10px;
    font-weight:bold;
    color:#0d47a1;
    font-size:18px;
}

.form-control{
    width:100%;
    padding:15px;
    border:2px solid #90caf9;
    border-radius:12px;
    font-size:17px;
    outline:none;
    background:white;
}

.form-control:focus{
    border-color:#1976d2;
}

textarea{
    min-height:160px;
    resize:vertical;
}

.content-area{
    min-height:260px;
}

.btn{
    width:100%;
    background:#1976d2;
    color:white;
    border:none;
    padding:17px;
    border-radius:12px;
    font-size:20px;
    font-weight:bold;
    cursor:pointer;
}

.btn:hover{
    background:#0d47a1;
}

#tagContainer{
    margin-top:15px;
    min-height:45px;
    padding:15px;
    border:2px dashed #90caf9;
    border-radius:12px;
    background:#f8fbff;
}

.tag-box{
    display:inline-block;
    margin:6px;
    padding:9px 14px;
    background:#e3f2fd;
    border:1px solid #90caf9;
    border-radius:20px;
    color:#0d47a1;
    font-weight:bold;
    cursor:pointer;
}

.tag-box input{
    margin-right:6px;
}

.back-link{
    display:block;
    text-align:center;
    margin-top:25px;
    color:#1976d2;
    text-decoration:none;
    font-weight:bold;
}

.back-link:hover{
    text-decoration:underline;
}
</style>

</head>
<body>

<div class="container">

    <h1>Edit Cheatsheet</h1>

    <form:form
        modelAttribute="cheatsheet"
        action="${pageContext.request.contextPath}/cheatsheet/update"
        method="post">

        <form:hidden path="id"/>

        <div class="form-group">
            <label>Title</label>
            <form:input path="title" cssClass="form-control"/>
        </div>

        <div class="form-group">
            <label>Description</label>
            <form:textarea path="description" cssClass="form-control"/>
        </div>

        <div class="form-group">
            <label>Content</label>
            <form:textarea path="content" cssClass="form-control content-area"/>
        </div>

        <div class="form-group">
            <label>Category</label>

            <form:select
                path="category.id"
                cssClass="form-control"
                id="categorySelect">

                <c:forEach items="${categorylist}" var="c">
                    <form:option value="${c.id}">
                        ${c.name}
                    </form:option>
                </c:forEach>

            </form:select>
        </div>

        <div class="form-group">
            <label>Visibility</label>

            <form:select path="visibility" cssClass="form-control">
                <form:option value="PUBLIC">PUBLIC</form:option>
                <form:option value="PRIVATE">PRIVATE</form:option>
                <form:option value="FRIEND-ONLY">FRIEND-ONLY</form:option>
            </form:select>
        </div>

        <div class="form-group">
            <label>Tags</label>

            <div id="tagContainer">

                <c:forEach items="${taglist}" var="t">

                    <c:set var="checked" value="false"/>

                    <c:forEach items="${cheatsheet.tags}" var="selectedTag">
                        <c:if test="${selectedTag.id == t.id}">
                        <c:set var="checked" value="true"/>
                        </c:if>
                    </c:forEach>

                    <label class="tag-box">
                        <input type="checkbox"
                               name="tagIds"
                               value="${t.id}"
                               <c:if test="${checked}">checked</c:if>>
                        ${t.name}
                    </label>

                </c:forEach>

            </div>
        </div>

        <button type="submit" class="btn">
            Update Cheatsheet
        </button>

    </form:form>

    <a href="${pageContext.request.contextPath}/cheatsheet/list" class="back-link">
        Back to List
    </a>

</div>

<script>
document.getElementById("categorySelect").addEventListener("change", function(){

    let categoryId = this.value;

    if(categoryId === ""){
        document.getElementById("tagContainer").innerHTML = "Select category first";
        return;
    }

    fetch("${pageContext.request.contextPath}/cheatsheet/tags-by-category/" + categoryId)
        .then(response => response.text())
        .then(data => {
            document.getElementById("tagContainer").innerHTML = data;
        });
});
</script>

</body>
</html>