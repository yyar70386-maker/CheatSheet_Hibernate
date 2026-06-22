<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Create Cheatsheet</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    background:#f4f8ff;
}

.container{
    width:900px;
    margin:40px auto;
    background:white;
    padding:40px;
    border-radius:15px;
    box-shadow:0 4px 15px rgba(0,0,0,.1);
}

h1{
    text-align:center;
    color:#1976d2;
    margin-bottom:30px;
}

.form-group{
    margin-bottom:20px;
}

label{
    display:block;
    margin-bottom:8px;
    font-weight:bold;
}

.form-control{
    width:100%;
    padding:12px;
    border:1px solid #ccc;
    border-radius:8px;
}

textarea{
    min-height:250px;
}

.btn{
    width:100%;
    background:#1976d2;
    color:white;
    border:none;
    padding:15px;
    border-radius:8px;
    cursor:pointer;
}

#tagContainer{
    margin-top:15px;
}

.tag-box{
    display:inline-block;
    margin:5px;
    padding:8px 12px;
    background:#e3f2fd;
    border-radius:20px;
}

</style>

</head>
<body>

<div class="container">

<h1>Create Cheatsheet</h1>

<form:form
modelAttribute="cheatsheet"
action="${pageContext.request.contextPath}/cheatsheet/save"
method="post">

<div class="form-group">

<label>Title</label>

<form:input
path="title"
cssClass="form-control"/>

</div>

<div class="form-group">

<label>Description</label>

<form:textarea
path="description"
cssClass="form-control"/>

</div>

<div class="form-group">

<label>Content</label>

<form:textarea
path="content"
cssClass="form-control"/>

</div>

<div class="form-group">

<label>Category</label>

<form:select
path="category.id"
cssClass="form-control"
id="categorySelect">

<form:option value="">
-- Select Category --
</form:option>

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

Select category first

</div>

</div>

<button class="btn">
Create Cheatsheet
</button>

</form:form>

</div>

<script>

document
.getElementById("categorySelect")
.addEventListener("change", function(){

let categoryId=this.value;

if(categoryId==""){
document.getElementById("tagContainer").innerHTML="";
return;
}

fetch(
"${pageContext.request.contextPath}/cheatsheet/tags-by-category/"
+categoryId
)

.then(response=>response.text())

.then(data=>{

document.getElementById(
"tagContainer"
).innerHTML=data;

});

});

</script>

</body>
</html>