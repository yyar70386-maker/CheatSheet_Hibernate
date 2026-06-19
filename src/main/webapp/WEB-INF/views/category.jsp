<%@ page language="java" contentType="text/html; charset=ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>

<!DOCTYPE html>
<html>
<head>
<title>Create Category</title>

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

.form-container{
    width:700px;
    margin:60px auto;
    background:white;
    padding:50px;
    border-radius:20px;
    border:2px solid #bbdefb;
    box-shadow:0 4px 20px rgba(21,101,192,0.15);
}

.form-icon{
    text-align:center;
    font-size:55px;
    color:#1976d2;
    margin-bottom:20px;
}

.form-title{
    text-align:center;
    color:#1565c0;
    margin-bottom:40px;
    font-size:42px;
    font-weight:bold;
}

.form-group{
    margin-bottom:30px;
}

.form-group label{
    display:block;
    margin-bottom:12px;
    font-weight:bold;
    color:#0d47a1;
    font-size:20px;
}

.form-control{
    width:100%;
    padding:17px;
    border:2px solid #90caf9;
    border-radius:12px;
    font-size:18px;
    outline:none;
}

.form-control:focus{
    border-color:#1976d2;
}

.btn-primary{
    width:100%;
    padding:18px;
    border:none;
    border-radius:12px;
    background:#1976d2;
    color:white;
    font-size:20px;
    font-weight:bold;
    cursor:pointer;
}

.btn-primary:hover{
    background:#0d47a1;
}
</style>

</head>
<body>

<div class="form-container">


    <h1 class="form-title">Create Category</h1>

    <form:form method="post"
               action="${pageContext.request.contextPath}/category/save"
               modelAttribute="category">

        <div class="form-group">
            <label>Category Name</label>
            <form:input path="name"
                        cssClass="form-control"
                        placeholder="Enter category name..."/>
        </div>

        <input type="submit" value="Create Category" class="btn-primary"/>

    </form:form>

</div>

</body>
</html>