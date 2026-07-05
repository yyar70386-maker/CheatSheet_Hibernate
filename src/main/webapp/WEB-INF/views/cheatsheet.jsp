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

        /* Liquid Glass Card (Preview) */
        .glass-card {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .glass-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(255,51,102,0.1) 0%, rgba(255,255,255,0) 100%);
            z-index: -1;
        }

        .terminal-box {
            background-color: #1e1e1e;
            border-radius: 8px;
            padding: 10px;
            min-height: 120px;
            margin-bottom: 15px;
            box-shadow: inset 0 2px 10px rgba(0,0,0,0.5);
            border: 1px dashed rgba(255,255,255,0.2);
        }
        .terminal-header {
            display: flex;
            gap: 5px;
            margin-bottom: 8px;
        }
        .terminal-dot {
            width: 10px; height: 10px; border-radius: 50%;
        }
        .dot-red { background: #ff5f56; }
        .dot-yellow { background: #ffbd2e; }
        .dot-green { background: #27c93f; }

        /* Buttons */
        .btn-primary { background-color: #ff3366; border-color: #ff3366; font-weight: 600; padding: 12px 24px; border-radius: 8px; }
        .btn-primary:hover { background-color: #e62e5c; border-color: #e62e5c; }
        .btn-secondary { background-color: #e2e8f0; border-color: #e2e8f0; color: #495057; font-weight: 600; padding: 12px 24px; border-radius: 8px; }
        .btn-secondary:hover { background-color: #cbd5e1; border-color: #cbd5e1; color: #1e293b; }
        
        .btn-outline {
            border: 1px dashed #ced4da;
            color: #6c757d;
            background: rgba(255,255,255,0.5);
            font-weight: 600;
        }
        .btn-outline:hover {
            background: rgba(255,255,255,0.8);
            border-color: #adb5bd;
            color: #495057;
        }
        .btn-remove {
            background-color: rgba(255, 51, 102, 0.1);
            color: #ff3366;
            border: none;
            border-radius: 6px;
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-remove:hover {
            background-color: #ff3366;
            color: white;
        }

        /* Tree Builder Sub-box */
        .builder-box {
            border: 1px dashed #ced4da;
            border-radius: 12px;
            padding: 20px;
            background: rgba(255,255,255,0.3);
            margin-bottom: 20px;
        }

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

<div class="container py-5">
    
    <!-- Top Banner -->
    <div class="header-banner shadow-sm">
        <h2 class="fw-bold text-dark mb-2">Create Cheatsheet</h2>
        <p class="text-muted m-0">Create cheatsheet with category, tags, color, cover photo and sections.</p>
    </div>

    <form:form modelAttribute="cheatsheet" action="${pageContext.request.contextPath}/cheatsheet/save" method="post" id="createForm">
        
        <!-- Main Two Column Layout -->
        <div class="row g-4">
            
            <!-- Left Column: Form Elements -->
            <div class="col-lg-8">
                
                <div class="glass-box mb-4">
                    <div class="section-title">Cheatsheet Information</div>
                    
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label>Parent Category</label>
                            <form:select path="category.id" cssClass="form-select" id="categorySelect">
                                <form:option value="">-- Select Category --</form:option>
                                <c:forEach items="${categorylist}" var="c">
                                    <form:option value="${c.id}">${c.name}</form:option>
                                </c:forEach>
                            </form:select>
                        </div>
                        <div class="col-md-6">
                            <label>Child Category</label>
                            <select class="form-select">
                                <option>-- Select Child --</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label>Title</label>
                        <form:input path="title" cssClass="form-control" id="titleInput" placeholder="Enter title" />
                    </div>

                    <div class="mb-3">
                        <label>Description</label>
                        <form:textarea path="description" cssClass="form-control" rows="4" placeholder="Write cheatsheet description" />
                    </div>

                    <!-- Visual Only Fields (Theme Color, Cover Photo) -->
                    <div class="row g-3 mb-3 align-items-end">
                        <div class="col-md-6">
                            <label>Theme Color</label>
                            <div class="d-flex align-items-center gap-3">
                                <input type="color" class="form-control form-control-color" value="#ff3366" title="Choose your color" style="width: 50px; padding: 5px;">
                                <span class="text-muted small">Choose your custom color</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Cover Photo</label>
                            <input type="file" class="form-control" />
                        </div>
                    </div>

                    <!-- Hidden actual content and visibility -->
                    <form:hidden path="content" id="hiddenContent" value="" />
                    <form:hidden path="visibility" id="hiddenVisibility" value="PUBLIC" />
                </div>

                <div class="glass-box mb-4">
                    <div class="section-title">Tags Association Hub</div>
                    
                    <div id="tagContainer" class="mb-3">
                        <span class="text-muted small">Select category first to see available tags.</span>
                    </div>

                    <label class="mt-3">Request Custom Tag</label>
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="e.g. django">
                        <button class="btn btn-primary" type="button" style="padding: 10px 20px;"><i class="bi bi-plus me-1"></i> Request Tag</button>
                    </div>
                </div>

                <div class="glass-box mb-4">
                    <div class="section-title">Cheatsheet Tree Data Layout Builder</div>
                    
                    <!-- Builder Area (UI only) -->
                    <div class="builder-box">
                        <div class="mb-3">
                            <label>Section Header Name</label>
                            <input type="text" class="form-control" placeholder="Section Title">
                        </div>

                        <!-- Sample Row -->
                        <div class="d-flex gap-2 mb-3 align-items-end">
                            <div class="flex-grow-1">
                                <label>Row Title</label>
                                <input type="text" class="form-control" placeholder="e.g. Variables">
                            </div>
                            <div class="flex-grow-1">
                                <label>Syntax / Code</label>
                                <input type="text" class="form-control" placeholder="Code block">
                            </div>
                            <div class="flex-grow-1">
                                <label>Output / Rule</label>
                                <input type="text" class="form-control" placeholder="Description">
                            </div>
                            <button type="button" class="btn-remove"><i class="bi bi-dash"></i></button>
                        </div>

                        <!-- Sample Note -->
                        <div class="d-flex gap-2 mb-3 align-items-center">
                            <div style="flex: 1;">
                                <label>Note Title</label>
                                <input type="text" class="form-control h-100">
                            </div>
                            <div style="flex: 3;">
                                <label>Note Statement</label>
                                <textarea class="form-control" rows="2" placeholder="Add helpful note statement..."></textarea>
                            </div>
                            <button type="button" class="btn-remove align-self-end h-auto p-2" style="height: 62px !important;"><i class="bi bi-dash"></i></button>
                        </div>

                        <div class="d-flex gap-2 mb-2">
                            <button type="button" class="btn btn-outline btn-sm px-3 rounded-pill"><i class="bi bi-plus me-1"></i>Row</button>
                            <button type="button" class="btn btn-outline btn-sm px-3 rounded-pill"><i class="bi bi-plus me-1"></i>Note</button>
                        </div>
                    </div>

                    <button type="button" class="btn btn-outline w-100 rounded"><i class="bi bi-plus me-1"></i> Add Section</button>
                </div>

                <!-- Form Submit Actions -->
                <div class="d-flex gap-3">
                    <button type="button" class="btn btn-secondary w-50" onclick="submitForm('PRIVATE')">Draft Cheatsheet</button>
                    <button type="button" class="btn btn-primary w-50" onclick="submitForm('PUBLIC')">Public Cheatsheet</button>
                </div>

            </div>

            <!-- Right Column: Preview & Tag Queue -->
            <div class="col-lg-4">
                
                <div class="glass-card mb-4" id="previewCard">
                    <div class="terminal-box">
                        <div class="terminal-header">
                            <div class="terminal-dot dot-red"></div>
                            <div class="terminal-dot dot-yellow"></div>
                            <div class="terminal-dot dot-green"></div>
                        </div>
                        <div class="text-white small" style="font-family: monospace; opacity: 0.5;">// Code preview</div>
                    </div>
                    
                    <h4 class="fw-bold text-dark mb-1" id="previewTitle">My Cheat Sheet</h4>
                    <div class="text-muted small mb-2" id="previewCategory">Category: Help</div>
                    <div class="fw-semibold text-dark small mb-3">Section Layer</div>
                    <div class="text-muted small" style="font-size: 0.8rem;">Selected tags will appear after choosing category</div>
                </div>

                <div class="glass-box p-3">
                    <h6 class="fw-bold text-danger mb-3 border-bottom pb-2">Requested Tag Queue</h6>
                    <table class="table table-borderless table-sm small mb-0">
                        <thead>
                            <tr class="text-muted">
                                <th>Tag</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="3" class="text-center text-muted py-3">No pending tags in queue.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>

        </div> <!-- /row -->

    </form:form>

</div>

<jsp:include page="footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>

    // Dynamic Preview Updating
    const titleInput = document.getElementById('titleInput');
    const categorySelect = document.getElementById('categorySelect');
    const previewTitle = document.getElementById('previewTitle');
    const previewCategory = document.getElementById('previewCategory');

    titleInput.addEventListener('input', function() {
        previewTitle.textContent = this.value || 'My Cheat Sheet';
    });

    categorySelect.addEventListener('change', function() {
        const selectedText = this.options[this.selectedIndex].text;
        previewCategory.textContent = this.value ? 'Category: ' + selectedText : 'Category: Help';
        
        // Load tags
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
    function submitForm(visibility) {
        document.getElementById('hiddenVisibility').value = visibility;
        
        // Normally you'd gather Tree Layout data and stringify into JSON to store in hiddenContent.
        // For now, we just pass dummy content if empty so the backend doesn't reject it.
        const contentInput = document.getElementById('hiddenContent');
        if(!contentInput.value) {
            contentInput.value = '<p>Content generated via Layout Builder.</p>';
        }
        
        document.getElementById('createForm').submit();
    }

</script>

</body>
</html>