<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { background: #f0f2f5; }
        .profile-list-card {
            border: 1px solid #e4e6eb;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 1px 2px rgba(0,0,0,.05);
        }
        .avatar-xl {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            object-fit: cover;
        }
        .text-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />

<main class="container py-4" style="max-width: 920px;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">${pageTitle}</h3>
            <div class="text-muted small">People connected to this profile</div>
        </div>
        <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary btn-sm">
            <i class="bi bi-arrow-left me-1"></i> Back
        </a>
    </div>

    <c:choose>
        <c:when test="${empty profileUsers}">
            <div class="text-center bg-white border rounded-4 py-5">
                <i class="bi bi-people display-5 text-muted d-block mb-2"></i>
                <div class="fw-semibold">No users found</div>
                <div class="text-muted small">This list is empty right now.</div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-grid gap-3">
                <c:forEach items="${profileUsers}" var="u">
                    <div class="profile-list-card p-3">
                        <div class="d-flex flex-column flex-md-row gap-3 align-items-md-center justify-content-between">
                            <div class="d-flex gap-3 align-items-start align-items-md-center">
                                <c:choose>
                                    <c:when test="${not empty u.avatarPath}">
                                        <img src="${pageContext.request.contextPath}/profile/avatar/${u.avatarPath}" class="avatar-xl" alt="Avatar">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" class="avatar-xl" alt="Avatar">
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <a href="${pageContext.request.contextPath}/profile/${u.obfuscatedId}" class="text-decoration-none text-dark fw-bold fs-5">
                                        ${u.username}
                                    </a>
                                    <div class="text-muted">${u.fullName}</div>
                                    <div class="text-muted small text-clamp-2 mt-1">
                                        <c:out value="${u.bio}" />
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex gap-2 align-items-center">
                                <a href="${pageContext.request.contextPath}/profile/${u.obfuscatedId}" class="btn btn-outline-primary btn-sm">
                                    View Profile
                                </a>
                                <c:if test="${sessionScope.currentUser.id != u.id}">
                                    <c:choose>
                                        <c:when test="${u.following}">
                                            <form action="${pageContext.request.contextPath}/unfollow/${u.obfuscatedId}" method="post">
                                                <button class="btn btn-outline-secondary btn-sm" type="submit">
                                                    Unfollow
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/follow/${u.obfuscatedId}" method="post">
                                                <button class="btn btn-primary btn-sm" type="submit">
                                                    Follow back
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
