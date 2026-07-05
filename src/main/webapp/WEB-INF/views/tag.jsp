<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Tag - CheatSheet Library</title>
    
    <!-- Design & Styling အတွက် Bootstrap 5 နှင့် Icons ပေါင်းစပ်ခြင်း -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <style>
        body {
            background-color: #f4f8ff;
            font-family: Arial, sans-serif;
        }
        .form-container {
            max-width: 600px;
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 25px rgba(21, 101, 192, 0.1);
            margin: 60px auto;
        }
        .form-title {
            color: #1565c0;
            font-weight: bold;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .btn-submit {
            background-color: #1976d2;
            color: white;
            font-weight: bold;
            padding: 10px 24px;
            border-radius: 8px;
            border: none;
            transition: background 0.2s ease;
        }
        .btn-submit:hover {
            background-color: #0d47a1;
            color: white;
        }
        .btn-cancel {
            background-color: #f1f3f5;
            color: #495057;
            font-weight: bold;
            padding: 10px 24px;
            border-radius: 8px;
            text-decoration: none;
            transition: background 0.2s ease;
        }
        .btn-cancel:hover {
            background-color: #e2e8f0;
            color: #212529;
        }
    </style>
</head>
<body>

    <%-- Include Header Component (ရှိလျှင် သုံးရန်) --%>
    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="form-container">
            
            <h2 class="form-title">
                <i class="bi bi-bookmark-plus-fill"></i> Create New Tag
            </h2>
            <p class="text-secondary small mb-4">Add a new keyword tag to filter and group your developer cheat sheets system structurally.</p>
            
            <hr class="mb-4" style="color: #dee2e6;">

            <!-- Controller ၏ /tag/save POST mapping သို့ ဒေတာလှမ်းပို့မည့် Form -->
            <form action="${pageContext.request.contextPath}/tag/save" method="post">
                
                <!-- ၁။ Tag Name Input Field -->
                <div class="mb-4">
                    <label for="tagName" class="form-label fw-bold text-dark">Tag Name</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-secondary"><i class="bi bi-hash"></i></span>
                        <input type="text" 
                               class="form-control" 
                               id="tagName" 
                               name="name" 
                               placeholder="e.g., spring-boot, exception-handling" 
                               required>
                    </div>
                    <div class="form-text text-muted">Use clear, short keywords (preferably lower-case with dashes).</div>
                </div>

                <!-- ၂။ Category Selection Dropdown -->
                <div class="mb-4">
                    <label for="categorySelect" class="form-label fw-bold text-dark">Assign Category</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light text-secondary"><i class="bi bi-layers-half"></i></span>
                        <select class="form-select" id="categorySelect" name="category.id" required>
                            <option value="" disabled selected>-- Select Target Category --</option>
                            <c:forEach items="${categorylist}" var="cat">
                                <option value="${cat.id}">${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-text text-muted">Select which structural category this tag belongs to.</div>
                </div>

                <!-- ၃။ Status Static Value (Default as Active) -->
                <input type="hidden" name="status" value="active">

                <hr class="mt-5 mb-4" style="color: #dee2e6;">

                <!-- Form Action Buttons -->
                <div class="d-flex justify-content-end gap-3">
                    <!-- 🌟 [CANCEL FIX] Cancel နှိပ်လျှင် ဗြောင် View သို့မသွားဘဲ Admin Panel မျက်နှာပြင်ထဲသို့ တိုက်ရိုက်ပြန်လှည့်ခိုင်းခြင်း -->
                    <a href="${pageContext.request.contextPath}/admin/tags" class="btn btn-cancel d-flex align-items-center gap-1">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-submit d-flex align-items-center gap-1">
                        <i class="bi bi-check-circle-fill"></i> Save Tag
                    </button>
                </div>
                
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>