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
    background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
    min-height: 100vh;
}

.container{
    width:900px;
    margin:40px auto;
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    padding:40px;
    border-radius:20px;
    border: 1px solid rgba(255, 255, 255, 0.6);
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
}

.form-icon{
    text-align:center;
    font-size:55px;
    color: #ff3366;
    margin-bottom:15px;
}

h1{
    text-align:center;
    color: #ff3366;
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
    color: #333;
    font-size:18px;
}

.form-control{
    width:100%;
    padding:15px;
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius:12px;
    font-size:17px;
    outline:none;
    background: rgba(255, 255, 255, 0.5);
    backdrop-filter: blur(5px);
}

.form-control:focus{
    border-color: #ff3366;
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
    background: #ff3366;
    color:white;
    border:none;
    padding:17px;
    border-radius:12px;
    font-size:20px;
    font-weight:bold;
    cursor:pointer;
    transition: background 0.3s;
}

.btn:hover{
    background: #e62e5c;
}

#tagContainer{
    margin-top:15px;
    min-height:45px;
    padding:15px;
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius:12px;
    background: rgba(255, 255, 255, 0.5);
}

.tag-box{
    display:inline-block;
    margin:6px;
    padding:9px 14px;
    background: rgba(255, 255, 255, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius:20px;
    color: #333;
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
    color: #ff3366;
    text-decoration:none;
    font-weight:bold;
}

.back-link:hover{
    text-decoration:underline;
}
</style>

</head>
<body>
<jsp:include page="header.jsp" />

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

<jsp:include page="footer.jsp" />
</body>
</html>