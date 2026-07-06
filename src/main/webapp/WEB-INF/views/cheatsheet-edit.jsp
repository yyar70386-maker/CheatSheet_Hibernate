<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Cheatsheet</title>

<!-- Bootstrap & Bootstrap Icons CDN လင့်ခ်များ ထည့်သွင်းခြင်း (Layout ညီသွားစေရန် အဓိက လိုအပ်ချက်) -->
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

/* Glassmorphism Box style အား Bootstrap Container နှင့် ကိုက်ညီအောင် ညှိထားခြင်း */
.glass-box {
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border: 1px solid rgba(255, 255, 255, 0.6);
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
    padding: 40px;
    margin-bottom: 40px;
}

h1{
    color: #ff3366;
    font-size: 32px;
    font-weight: bold;
    border-bottom: 2px solid rgba(255, 51, 102, 0.2);
    padding-bottom: 15px;
}

label{
    font-weight: bold;
    color: #333;
    font-size: 16px;
}

.form-control, .form-select {
    padding: 12px 15px;
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius: 10px;
    font-size: 16px;
    background: rgba(255, 255, 255, 0.5);
    backdrop-filter: blur(5px);
}

.form-control:focus, .form-select:focus {
    border-color: #ff3366;
    box-shadow: 0 0 0 0.25px rgba(255, 51, 102, 0.25);
    background: rgba(255, 255, 255, 0.7);
}

textarea.form-control {
    min-height: 120px;
    resize: vertical;
}

.content-area {
    min-height: 220px !important;
}

.btn-submit {
    width: 100%;
    background: #ff3366;
    color: white;
    border: none;
    padding: 14px;
    border-radius: 10px;
    font-size: 18px;
    font-weight: bold;
    cursor: pointer;
    transition: background 0.3s;
}

.btn-submit:hover {
    background: #e62e5c;
    color: white;
}

#tagContainer {
    min-height: 45px;
    padding: 12px;
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius: 10px;
    background: rgba(255, 255, 255, 0.5);
}

.tag-box {
    display: inline-block;
    margin: 4px;
    padding: 6px 12px;
    background: rgba(255, 255, 255, 0.6);
    border: 1px solid rgba(255, 255, 255, 0.8);
    border-radius: 20px;
    color: #333;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
}

.tag-box input {
    margin-right: 6px;
}

.back-link {
    display: block;
    text-align: center;
    margin-top: 20px;
    color: #ff3366;
    text-decoration: none;
    font-weight: bold;
}

.back-link:hover {
    text-decoration: underline;
    color: #e62e5c;
}
</style>

</head>
<body>
<jsp:include page="header.jsp" />

<!-- Bootstrap row/col စနစ်သုံးပြီး အလယ်တည့်တည့်မှာ ညီညီညာညာ ဖြစ်အောင် ထိန်းထားပါသည် -->
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-9 col-md-11">
            
            <div class="glass-box">
                <h1 class="mb-4 text-center">Edit Cheatsheet</h1>

                <form:form
                    modelAttribute="cheatsheet"
                    action="${pageContext.request.contextPath}/cheatsheet/update"
                    method="post"
                    enctype="multipart/form-data">

                    <form:hidden path="id"/>

                    <div class="form-group mb-4">
                        <label class="form-label">Title</label>
                        <form:input path="title" cssClass="form-control"/>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Description</label>
                        <form:textarea path="description" cssClass="form-control"/>
                    </div>
                    <div class="form-group mb-4">
                        <label class="form-label">Content</label>
                        <form:textarea path="content" cssClass="form-control content-area"/>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Cover Photo</label>
                        <c:if test="${not empty cheatsheet.imagePath}">
                            <div class="mb-2">
                                <img src="${pageContext.request.contextPath}${cheatsheet.imagePath}" style="max-height: 150px; border-radius: 8px;" alt="Current Cover"/>
                            </div>
                        </c:if>
                        <input type="file" name="imageFile" class="form-control" accept="image/*" />
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Category</label>
                        <form:select
                            path="category.id"
                            cssClass="form-select"
                            id="categorySelect">
                            <c:forEach items="${categorylist}" var="c">
                                <form:option value="${c.id}">
                                    ${c.name}
                                </form:option>
                            </c:forEach>
                        </form:select>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Visibility</label>
                        <form:select path="visibility" cssClass="form-select">
                            <form:option value="PUBLIC">PUBLIC</form:option>
                            <form:option value="PRIVATE">PRIVATE</form:option>
                            <form:option value="FRIEND-ONLY">FRIEND-ONLY</form:option>
                        </form:select>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Publish Status</label>
                        <form:select path="status" cssClass="form-select">
                            <form:option value="active">Public Post</form:option>
                            <form:option value="draft">Draft Post</form:option>
                        </form:select>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label">Tags</label>
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

                    <button type="submit" class="btn-submit mt-2">
                        <i class="bi bi-check-circle me-1"></i> Update Cheatsheet
                    </button>

                </form:form>

                <a href="${pageContext.request.contextPath}/cheatsheet/list" class="back-link">
                    <i class="bi bi-arrow-left me-1"></i> Back to List
                </a>
            </div>

        </div>
    </div>
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

<!-- Bootstrap Bundle JS ထည့်သွင်းခြင်း -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>