<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Cheatsheet</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        body {
            background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* Glassmorphism Containers */
        .glass-box {
            background: rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            padding: 24px;
        }

        /* Form Controls */
        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.8);
            border-radius: 8px;
            padding: 12px;
            color: #495057;
            transition: all 0.2s;
        }
        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.8);
            border-color: #ff3366;
            box-shadow: 0 0 0 0.25rem rgba(255, 51, 102, 0.25);
            outline: none;
        }
        label {
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
            margin-bottom: 6px;
            display: block;
        }

        /* Section Title (Left Border) */
        .section-title {
            border-left: 4px solid #ff3366;
            padding-left: 12px;
            font-size: 1.25rem;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 20px;
        }

        /* Buttons */
        .btn-primary { background-color: #ff3366; border-color: #ff3366; font-weight: 600; padding: 12px 24px; border-radius: 8px; }
        .btn-primary:hover { background-color: #e62e5c; border-color: #e62e5c; }
        .btn-secondary { background-color: #e2e8f0; border-color: #e2e8f0; color: #495057; font-weight: 600; padding: 12px 24px; border-radius: 8px; }
        .btn-secondary:hover { background-color: #cbd5e1; border-color: #cbd5e1; color: #1e293b; }

        .header-banner {
            background: rgba(255, 255, 255, 0.45);
            backdrop-filter: blur(16px);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 24px;
            border: 1px solid rgba(255, 255, 255, 0.6);
            border-left: 8px solid #ff3366;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container py-5" style="max-width: 960px;">
    
    <!-- Top Banner -->
    <div class="header-banner shadow-sm">
        <h2 class="fw-bold text-dark mb-2">Create Cheatsheet</h2>
        <p class="text-muted m-0">Create cheatsheet with category, tags, cover photo and cheatsheet content.</p>
    </div>
    <form:form modelAttribute="cheatsheet" action="${pageContext.request.contextPath}/cheatsheet/save" method="post" id="createForm" enctype="multipart/form-data">
        
        <div class="row g-4">
            
            <!-- Full Width Container (12 Columns) -->
            <div class="col-12">
                
                <div class="glass-box mb-4">
                    <div class="section-title">Cheatsheet Information</div>
                    
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label>Category</label>
                            <form:select path="category.id" cssClass="form-select" id="categorySelect" required="true">
                                <form:option value="">-- Select Category --</form:option>
                                <c:forEach items="${categorylist}" var="c">
                                    <form:option value="${c.id}">${c.name}</form:option>
                                </c:forEach>
                            </form:select>
                        </div>
                        <div class="col-md-6">
                            <label>Cover Photo</label>
                            <input type="file" name="imageFile" class="form-control" accept="image/*" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label>Title</label>
                        <form:input path="title" cssClass="form-control" id="titleInput" placeholder="Enter title" required="true" />
                    </div>

                    <div class="mb-3">
                        <label>Description</label>
                        <form:textarea path="description" cssClass="form-control" rows="3" placeholder="Write a short cheatsheet description..." />
                    </div>
                </div>

                <div class="glass-box mb-4">
                    <div class="section-title">Publication Settings</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label>Visibility</label>
                            <form:select path="visibility" cssClass="form-select" id="visibilitySelect">
                                <form:option value="PUBLIC">PUBLIC</form:option>
                                <form:option value="FRIEND-ONLY">FRIEND-ONLY</form:option>
                                <form:option value="PRIVATE">PRIVATE</form:option>
                            </form:select>
                        </div>
                        <div class="col-md-6">
                            <label>Publish Status</label>
                            <form:select path="status" cssClass="form-select" id="statusSelect">
                                <form:option value="active">Public Post</form:option>
                                <form:option value="draft">Draft Post</form:option>
                            </form:select>
                        </div>
                    </div>
                </div>

                <div class="glass-box mb-4">
                    <div class="section-title">Tags Association Hub</div>
                    <div id="tagContainer" class="mb-2">
                        <span class="text-muted small">Select category first to see available tags.</span>
                    </div>
                </div>

                <div class="glass-box mb-4">
                    <div class="section-title">Cheatsheet Content</div>
                    <div class="mb-3">
                        <label>Code / Text Content</label>
                        <form:textarea path="content" cssClass="form-control" id="contentInput" rows="12" placeholder="Write your cheat sheet syntax, code snippets, or documentation details here..." style="font-family: monospace; font-size: 0.95rem; line-height: 1.5;" required="true" />
                    </div>
                </div>
                <!-- Form Submit Actions -->
                <div class="d-flex gap-3 mb-5">
                    <a href="${pageContext.request.contextPath}/cheatsheet/list" class="btn btn-secondary w-50 d-flex align-items-center justify-content-center">Cancel</a>
                    <button type="button" class="btn btn-primary w-50" onclick="submitForm()">Save Cheatsheet</button>
                </div>

            </div>

        </div> <!-- /row -->

    </form:form>

</div>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

    const titleInput = document.getElementById('titleInput');
    const categorySelect = document.getElementById('categorySelect');
    const contentInput = document.getElementById('contentInput');

    categorySelect.addEventListener('change', function() {
        let categoryId = this.value;
        if(categoryId == "") {
            document.getElementById("tagContainer").innerHTML = '<span class="text-muted small">Select category first to see available tags.</span>';
            return;
        }

        fetch("${pageContext.request.contextPath}/cheatsheet/tags-by-category/" + categoryId)
            .then(response => response.text())
            .then(data => {
                document.getElementById("tagContainer").innerHTML = data;
            });
    });

    // Handle Form Submission
    function submitForm() {
        const titleVal = titleInput.value.trim();
        const categoryVal = categorySelect.value;
        const contentVal = contentInput.value.trim();
        
        if(!categoryVal) {
            alert('Please select a Category.');
            return;
        }
        if(!titleVal) {
            alert('Please enter a Title.');
            return;
        }
        if(!contentVal) {
            alert('Please fill out the Cheatsheet Content.');
            return;
        }
        
        document.getElementById('createForm').submit();
    }

</script>

</body>
</html>