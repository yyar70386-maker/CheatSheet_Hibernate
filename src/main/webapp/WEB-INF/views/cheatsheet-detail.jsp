<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${sheet.title}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #ffffff;
        }
        .detail-container {
            max-width: 900px;
            margin: 60px auto;
            padding: 0 20px;
        }
        .sheet-title {
            font-size: 48px;
            font-weight: 800;
            color: #222222;
            display: inline-block;
        }
        .author-text {
            font-size: 22px;
            color: #777777;
            font-weight: bold;
            margin-left: 10px;
        }
        .description-text {
            font-size: 18px;
            color: #444444;
            margin-top: 25px;
            margin-bottom: 35px;
            line-height: 1.6;
        }
        
        /* 🌟 နမူနာပုံစံအတိုင်း လှပသပ်ရပ်ပြီး အရောင်မပါသော Code Block Style */
        .code-container-box {
            background-color: #f8f5f2; 
            border-radius: 14px;
            padding: 25px 30px;
            margin-bottom: 35px;
        }
        .plain-code-text {
            font-family: 'Courier New', Courier, monospace;
            font-size: 18px;
            line-height: 1.5;
            color: #333333; /* 🌟 အရောင်မထည့်ဘဲ စာသားရိုးရိုးအတိုင်း ပြသခြင်း */
            margin: 0;
            white-space: pre-wrap; 
            word-break: break-all;
        }
        
        .tag-badge {
            background-color: #e2e8f0;
            color: #333;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
        }
        .tag-badge:hover {
            background-color: #1976d2;
            color: white;
        }
    </style>
</head>
<body>

    <%-- Include Header Component --%>
    <jsp:include page="header.jsp" />

    <div class="detail-container">
        
        <%-- ၁။ Title & Author (by Kelvin ပုံစံ) --%>
        <%-- <div>
            <h1 class="sheet-title">${sheet.title}</h1>
            <span class="author-text">by ${sheet.author != null ? sheet.author.username : 'Unknown'}</span>
        </div>
 --%>
 <div>
    <h1 class="sheet-title">${sheet.title}</h1>
    <span class="author-text">by 
        <c:choose>
            <c:when test="${sheet.author != null}">
                <a href="${pageContext.request.contextPath}/profile/${sheet.author.id}" 
                   class="text-dark fw-bold text-decoration-none" 
                   style="border-bottom: 2px solid #0d6efd; padding-bottom: 2px;">
                    <c:out value="${sheet.author.username}" />
                </a>
            </c:when>
            <c:otherwise>
                <span class="text-muted fw-normal">Unknown</span>
            </c:otherwise>
        </c:choose>
    </span>
</div>
 
        <%-- ၂။ Description Section --%>
        <p class="description-text">
            ${sheet.description}
        </p>

        <%-- ၃။ Content / Code Block Section (Plain Text) --%>
        <div class="code-container-box">
            <pre class="plain-code-text"><c:out value="${sheet.content}" /></pre>
        </div>

        <%-- ၄။ Tags List --%>
        <div class="d-flex flex-wrap gap-2">
            <c:forEach items="${sheet.tags}" var="tag">
                <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge">
                    #${tag.name}
                </a>
            </c:forEach>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>