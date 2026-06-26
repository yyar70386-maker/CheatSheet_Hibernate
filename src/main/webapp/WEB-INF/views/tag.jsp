<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Tag Management</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <style>
        /* 📌 ၁။ Window Scroll မဖြစ်အောင် ချုပ်ခြင်း */
        html, body {
            height: 100vh;
            overflow: hidden; 
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* 📌 ၂။ Navbar အမြင့် ပုံသေထားခြင်း */
        .navbar {
            height: 56px;
            z-index: 1030;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05) !important;
        }

        /* 📌 ၃။ Sidebar နဲ့ Content Wrapper (ဒါပါမှ ဘေးချင်းယှဉ်မှာပါ) */
        .app-container {
            display: flex;
            height: calc(100vh - 56px); 
            width: 100%;
        }

        /* 📌 ၄။ Sidebar Width သတ်မှတ်ခြင်း */
        .admin-sidebar {
            width: 280px;
            height: 100%;
            flex-shrink: 0;
            overflow-y: auto; 
        }

        /* 📌 ၅။ ညာဘက် Content Area သီးသန့် Scroll စနစ် */
        .main-content-area {
            flex-grow: 1;
            height: 100%;
            overflow-y: auto; 
            min-width: 0;
            padding: 24px;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="bg-light">

    <%-- 🧩 Navbar Include လုပ်ခြင်း --%>
    <jsp:include page="header.jsp" />

    <%-- 🌐 App Container Wrapper --%>
    <div class="app-container">

        <%-- 🛠️ ဘယ်ဘက်ခြမ်း - SIDEBAR COMPONENT --%>
        <jsp:include page="sidebar.jsp">
            <jsp:param name="activePage" value="tags" />
        </jsp:include>

        <%-- 📂 ညာဘက်ခြမ်း MAIN CONTENT AREA --%>
        <div class="main-content-area">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold text-dark m-0">Tag Management</h2>
                    <p class="text-muted m-0 small">Manage your system tags and keywords.</p>
                </div>
            </div>

            <%-- Tag ပြသမည့် နေရာ (ဒီအောက်မှာ Table ကုဒ်တွေ ဆက်ရေးလို့ရပါပြီ) --%>
            <div class="card border-0 shadow-sm rounded-3 p-4">
                <p class="text-muted">You can manage tags right here.</p>
            </div>
            
        </div> <%-- /main-content-area --%>
    </div> <%-- /app-container --%>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>