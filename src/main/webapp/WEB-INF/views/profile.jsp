<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
body {
    background: radial-gradient(circle at 50% 50%, #fef3f6 0%, #e8dbe5 100%);
    min-height: 100vh;
    font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    padding-top: 70px;
}

.custom-navbar {
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border-bottom: 1px solid rgba(255, 255, 255, 0.6);
    z-index: 1030;
}

.profile-card {
    border: 1px solid rgba(255, 255, 255, 0.6);
    border-radius: 16px;
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
    overflow: hidden;
    background: rgba(255, 255, 255, 0.45);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
}

.cover-photo {
    height: 160px;
    background: linear-gradient(135deg, rgba(255, 51, 102, 0.8), rgba(255, 102, 153, 0.8));
    position: relative;
}

.profile-avatar-container {
    position: relative;
    width: 120px;
    height: 120px;
    display: inline-block;
    margin-top: -60px;
    z-index: 2;
}

.profile-avatar-img {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.15);
    border: 4px solid #ffffff !important;
    background-color: #ffffff;
    cursor: pointer;
    transition: transform 0.2s ease-in-out;
}

.profile-avatar-img:hover {
    transform: scale(1.02);
}

.camera-overlay-btn {
    position: absolute;
    bottom: 5px;
    right: 5px;
    background-color: #e4e6eb;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
    border: 2px solid #ffffff;
    transition: all 0.2s ease;
}

.camera-overlay-btn:hover {
    background-color: #d8dadf;
    transform: scale(1.1);
}

.stat-badge {
    background: #f8f9fa;
    color: #495057;
    border: 1px solid #e9ecef;
    padding: 8px 16px;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 600;
    transition: all 0.2s ease;
}

.stat-badge:hover {
    background: #e9ecef;
    transform: translateY(-2px);
}

.custom-tabs {
    border-bottom: 2px solid #f0f2f5;
    margin-bottom: 20px;
}

.custom-tabs .nav-link {
    color: #6c757d;
    font-weight: 600;
    border: none;
    padding: 12px 20px;
    background: transparent;
    position: relative;
}

.custom-tabs .nav-link:hover {
    color: #ff3366;
}

.custom-tabs .nav-link.active {
    color: #ff3366;
    border: none;
    background: transparent;
}

.custom-tabs .nav-link.active::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 100%;
    height: 3px;
    background-color: #ff3366;
    border-radius: 3px 3px 0 0;
}

.form-control {
    border-radius: 8px;
    padding: 10px 15px;
    border: 1px solid #ced4da;
}

.form-control:focus {
    box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
}

/* 🌟 CheatSheet Card Layout & Typography Styles */
.cheatsheet-card {
    border: 1px solid #e2e8f0;
    border-radius: 20px;
    padding: 30px;
    background: white;
    box-shadow: 0 4px 15px rgba(0,0,0,0.02);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
}
.cheatsheet-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
}
.description-text {
    display: -webkit-box;
    -webkit-line-clamp: 3; 
    -webkit-box-orient: vertical;  
    overflow: hidden;
    transition: all 0.3s ease;
}
.description-text.expanded {
    display: block;
    -webkit-line-clamp: unset;
}
.see-more-btn {
    color: #1976d2;
    cursor: pointer;
    font-weight: bold;
    font-size: 14px;
    text-decoration: none;
    display: inline-block;
    margin-top: 5px;
}
.see-more-btn:hover {
    text-decoration: underline;
}
.card-meta-item {
    color: #666;
    font-size: 14px;
    margin-bottom: 6px;
    display: flex;
    align-items: center;
    gap: 10px;
}
.tag-badge-link {
    background-color: #e2e8f0;
    color: #333;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: bold;
    text-decoration: none;
    display: inline-block;
}
.tag-badge-link:hover {
    background-color: #1976d2;
    color: white;
}
.stats-section {
    font-size: 14px;
    color: #555;
    display: flex;
    gap: 20px;
    margin-top: 15px;
}

/* 🌟 Visibility Pill Badges Styles */
.visibility-pill {
    font-size: 11px;
    font-weight: 700;
    padding: 4px 10px;
    border-radius: 50px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    text-transform: capitalize;
}
.pill-public {
    background-color: #d1e7dd;
    color: #0f5132;
}
.pill-friends {
    background-color: #cff4fc;
    color: #055160;
}
.pill-private {
    background-color: #f8d7da;
    color: #842029;
}
</style>
</head>
<body>

    <nav class="navbar custom-navbar px-4 shadow-sm fixed-top">
        <a href="${pageContext.request.contextPath}/home" class="navbar-brand mb-0 h1 fw-bold" style="color: #ff3366;"> 
            <i class="bi bi-code-square me-2"></i>Cheatsheet
        </a> 
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4 rounded-pill fw-bold shadow-sm d-flex align-items-center">
            <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
        </a>
    </nav>

    <div class="container mb-5" style="max-width: 800px;">

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show rounded-4 border-0 shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-4 border-0 shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="profile-card">

            <div class="cover-photo"></div>

            <div class="card-body px-4 pb-4">

                <div class="d-flex justify-content-between align-items-end mb-3">
                    <form id="profileAvatarForm" action="${pageContext.request.contextPath}/profile/upload-avatar" method="POST" enctype="multipart/form-data">
                        <div class="profile-avatar-container">
                            <c:choose>
                                <c:when test="${not empty user.avatarPath}">
                                    <img src="${pageContext.request.contextPath}/profile/avatar/${user.avatarPath}"
                                         class="profile-avatar-img" data-bs-toggle="modal" data-bs-target="#avatarViewModal" style="cursor: pointer;" title="Click to view full image">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" class="profile-avatar-img" data-bs-toggle="modal" data-bs-target="#avatarViewModal" title="Click to view full image">
                                </c:otherwise>
                            </c:choose>

                            <label for="avatarFile" class="camera-overlay-btn" title="Change Profile Picture"> 
                                <i class="bi bi-camera-fill text-dark fs-6"></i>
                            </label> 
                            <input type="file" id="avatarFile" name="avatarFile" accept="image/*" style="display: none;" required>
                        </div>
                    </form>

                    <div class="d-flex gap-2 pb-2">
                        <a href="${pageContext.request.contextPath}/profile/show/followers" class="stat-badge"> 
                            <i class="bi bi-people-fill text-primary me-1"></i> 
                            <span class="fs-5">${followersCount != null ? followersCount : 0}</span>
                            <span class="text-muted small">Followers</span>
                        </a> 
                        <a href="${pageContext.request.contextPath}/profile/show/following" class="stat-badge"> 
                            <i class="bi bi-person-plus-fill text-success me-1"></i> 
                            <span class="fs-5">${followingCount != null ? followingCount : 0}</span>
                            <span class="text-muted small">Following</span>
                        </a>
                    </div>
                </div>

                <div id="fileError" class="text-danger small mb-3 fw-bold" style="display: none;"></div>

                <div class="mb-4">
                    <h3 class="fw-bold text-dark mb-1">${user.fullName}</h3>
                    <c:if test="${user.role == 1}">
                        <span class="badge bg-danger rounded-pill px-3 py-2 shadow-sm">
                            <i class="bi bi-shield-lock-fill me-1"></i> Administrator
                        </span>
                    </c:if>
                </div>
                
                <ul class="nav nav-tabs custom-tabs" id="profileTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link ${param.tab != 'security' ? 'active' : ''}" id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane" type="button" role="tab">
                            <i class="bi bi-person-lines-fill me-2"></i>About Me
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link ${param.tab == 'security' ? 'active' : ''}" id="security-tab" data-bs-toggle="tab" data-bs-target="#security-pane" type="button" role="tab">
                            <i class="bi bi-shield-lock-fill me-2"></i>Security
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="profileTabContent">

                    <div class="tab-pane fade ${param.tab != 'security' ? 'show active' : ''}" id="info-pane" role="tabpanel">

                        <form action="${pageContext.request.contextPath}/profile/update" method="POST" class="p-4 rounded-4 mb-4 border border-white shadow-sm" style="background: rgba(255, 255, 255, 0.5);">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-pencil-square me-2 text-muted"></i>Edit Details
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label text-muted small fw-bold">Full Name</label> 
                                    <input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-muted small fw-bold">Email Address</label> 
                                    <input type="email" name="email" value="${user.email}" class="form-control" required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label text-muted small fw-bold">Bio / About Me</label>
                                    <textarea name="bio" class="form-control" rows="3" placeholder="Tell us about yourself..."><c:out value="${user.bio}" /></textarea>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end pt-4">
                                <button type="submit" class="btn btn-primary px-4 rounded-pill fw-bold shadow-sm d-flex align-items-center">
                                    <i class="bi bi-save me-2"></i> Save Changes
                                </button>
                            </div>
                        </form>

                        <div class="mt-5">
                            <h5 class="fw-bold text-dark mb-4 border-bottom pb-2">
                                <i class="bi bi-file-earmark-code-fill me-2 text-primary"></i>My Published Cheat Sheets
                            </h5>

                            <c:choose>
                                <%-- 🎨 မင်းထည့်သွင်းထားသော အဆင့်မြင့် Glassmorphic Empty State Component --%>
                                <c:when test="${empty cheatSheetsList}">
                                    <div class="text-center text-muted py-5 bg-light rounded-4 border border-dashed mb-4">
                                        <i class="bi bi-folder2-open display-4 d-block mb-3 text-secondary opacity-50"></i>
                                        <h6 class="fw-bold">No cheat sheets found</h6>
                                        <p class="small mb-0">You haven't published any cheat sheets yet.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <%-- 📐 မင်းရဲ့ ပိုမိုကျယ်ဝန်းတဲ့ row g-4 Grid System အား သုံးထားပါတယ် --%>
                                    <div class="row g-4 mb-4">
                                        <c:forEach items="${cheatSheetsList}" var="sheet">
                                            <div class="col-md-6">
                                                <div class="cheatsheet-card">
                                                    <div>
                                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                                            <h5 class="fw-bold m-0">
                                                                <a href="${pageContext.request.contextPath}/cheatsheet/detail/${sheet.obfuscatedId}" class="text-dark text-decoration-none hover-underline fs-5">
                                                                    ${sheet.title}
                                                                </a>
                                                            </h5>
                                                            
                                                            <c:choose>
                                                                <c:when test="${sheet.visibility == 'PUBLIC'}">
                                                                    <span class="visibility-pill pill-public">
                                                                        <i class="bi bi-globe"></i> Public
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${sheet.visibility == 'FRIEND-ONLY'}">
                                                                    <span class="visibility-pill pill-friends">
                                                                        <i class="bi bi-people-fill"></i> Friends
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="visibility-pill pill-private">
                                                                        <i class="bi bi-lock-fill"></i> Private
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        
                                                        <div class="description-container mb-3">
                                                            <p class="text-secondary description-text mb-0">${sheet.description}</p>
                                                            <span class="see-more-btn" onclick="toggleDescription(this)">See More</span>
                                                        </div>
                                                        
                                                        <div class="card-meta-item">
                                                            <i class="bi bi-person-fill"></i> ${sheet.author != null ? sheet.author.username : 'Unknown'}
                                                        </div>
                                                        <div class="card-meta-item">
                                                            <i class="bi bi-folder-fill"></i> ${sheet.category.name} Cheat Sheets
                                                        </div>
                                                        <div class="card-meta-item">
                                                            <i class="bi bi-calendar-plus"></i> Created: <fmt:formatDate value="${sheet.createdAt}" pattern="yyyy-MM-dd"/>
                                                        </div>
                                                        <div class="card-meta-item">
                                                            <i class="bi bi-calendar-event"></i> Updated: <fmt:formatDate value="${sheet.updatedAt}" pattern="yyyy-MM-dd"/>
                                                        </div>
                                                        
                                                        <div class="d-flex flex-wrap gap-2 my-3">
                                                            <c:forEach items="${sheet.tags}" var="tag">
                                                                <a href="${pageContext.request.contextPath}/cheatsheet/tag/${tag.id}" class="tag-badge-link">#${tag.name}</a>
                                                            </c:forEach>
                                                        </div>
                                                    </div>

                                                    <div class="stats-section mt-auto d-flex justify-content-between align-items-center border-top pt-3">
                                                        <div class="d-flex gap-3">
                                                            <span><i class="bi bi-eye-fill me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</span>
                                                            <span><i class="bi bi-download me-1"></i> ${sheet.downloadCount != null ? sheet.downloadCount : 0}</span>
                                                        </div>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/cheatsheet/view-pdf/${sheet.id}" 
                                                               target="_blank" 
                                                               class="btn btn-sm btn-outline-danger px-2 py-1 d-flex align-items-center gap-1"
                                                               style="border-radius: 6px; font-size: 12px; font-weight: bold;"
                                                               title="View PDF Document">
                                                                 <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <%-- Shared Cheat Sheets Block --%>
                            <h5 class="fw-bold text-dark mb-3 pt-3 border-top">
                                <i class="bi bi-share-fill me-2 text-success"></i>Shared Cheat Sheets
                            </h5>
                            
                            <c:choose>
                                <c:when test="${empty sharedCheatSheetsList}">
                                    <div class="text-center text-muted py-4 bg-white rounded-3 border border-dashed mb-4">
                                        <i class="bi bi-share display-6 d-block mb-2 text-secondary"></i>
                                        This place is show my share cheat sheets.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="row g-4">
                                        <c:forEach items="${sharedCheatSheetsList}" var="item">
                                            <div class="col-md-6">
                                                <div class="cheatsheet-card border-success-subtle shadow-sm">
                                                    <h6 class="fw-bold mb-1">
                                                        <a href="${pageContext.request.contextPath}/cheatsheet/detail/${item.cheatsheet.obfuscatedId}" class="text-decoration-none text-dark">
                                                            <c:out value="${item.cheatsheet.title}"/>
                                                        </a>
                                                    </h6>
                                                    <p class="text-secondary small text-truncate mb-2"><c:out value="${item.cheatsheet.description}"/></p>
                                                    
                                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">
                                                            by <c:out value="${item.cheatsheet.author.fullName}"/>
                                                        </span>
                                                        <small class="text-muted"><i class="bi bi-eye me-1"></i> ${item.cheatsheet.viewCount != null ? item.cheatsheet.viewCount : 0}</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- Security Tab Content --%>
                    <div class="tab-pane fade ${param.tab == 'security' ? 'show active' : ''}" id="security-pane" role="tabpanel">
                        <div class="p-4 rounded-4 border border-white shadow-sm mt-2" style="background: rgba(255, 255, 255, 0.5);">
                            <h5 class="text-danger fw-bold mb-2">
                                <i class="bi bi-shield-lock-fill me-2"></i>Change Password
                            </h5>
                            <p class="text-muted small mb-4 pb-2 border-bottom">Ensure your account is using a long, random password to stay secure.</p>

                            <form action="${pageContext.request.contextPath}/profile/change-password" method="POST" style="max-width: 500px;">
                                <div class="mb-3">
                                    <label class="form-label text-muted small fw-bold">Current Password</label> 
                                    <input type="password" name="oldPassword" class="form-control" placeholder="Enter current password" required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label text-muted small fw-bold">New Password</label> 
                                    <input type="password" name="newPassword" class="form-control" placeholder="At least 6 characters" required>
                                </div>

                                <div>
                                    <button type="submit" class="btn btn-dark px-4 rounded-pill fw-bold shadow-sm">
                                        <i class="bi bi-key-fill me-2"></i>Update Password
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                </div> <%-- /tab-content --%>
            </div> <%-- /card-body --%>
        </div> <%-- /profile-card --%>
    </div> <%-- /container --%>

    <%-- Avatar Modal --%>
    <div class="modal fade" id="avatarViewModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content bg-transparent border-0">
                <div class="modal-header border-0 pb-0 justify-content-end">
                    <button type="button" class="btn-close btn-close-white fs-4" data-bs-toggle="modal" data-bs-target="#avatarViewModal" aria-label="Close"></button>
                </div>
                <div class="modal-dialog modal-dialog-centered modal-xl">
                    <c:choose>
                        <c:when test="${not empty user.avatarPath}">
                            <img src="${pageContext.request.contextPath}/uploads/${user.avatarPath}" class="img-fluid shadow-lg rounded" style="max-width: 100%; max-height: 80vh;" alt="Profile Image">
                        </c:when>
                        <c:otherwise>
                            <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" class="img-fluid shadow-lg rounded" style="max-width: 100%; max-height: 80vh;" alt="Default Profile">
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        document.getElementById('avatarFile').addEventListener('change', function() {
            const file = this.files[0];
            const errorDiv = document.getElementById('fileError');
            const form = document.getElementById('profileAvatarForm');

            if (file) {
                if (!file.type.startsWith('image/')) {
                    errorDiv.innerHTML = "<i class='bi bi-x-circle-fill me-1'></i> Invalid file! Please select an image file (JPG, PNG) only.";
                    errorDiv.style.display = "block";
                    this.value = "";
                } else {
                    errorDiv.style.display = "none";
                    form.submit();
                }
            }
        });

        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 3000);
    </script>
    
    <script>
    function toggleDescription(btn) {
        var textEl = btn.previousElementSibling;
        textEl.classList.toggle('expanded');
        
        if (textEl.classList.contains('expanded')) {
            btn.innerText = 'See Less';
        } else {
            btn.innerText = 'See More';
        }
    }
    </script>
</body>
</html>