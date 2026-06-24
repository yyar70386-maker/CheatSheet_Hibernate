<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
body {
	background-color: #f8f9fa;
}

.nav-tabs .nav-link {
	color: #495057;
	font-weight: 500;
}

.nav-tabs .nav-link.active {
	font-weight: bold;
	color: #0d6efd;
}
.badge-link {
	text-decoration: none;
	transition: all 0.2s ease;
}
.badge-link:hover {
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(0,0,0,0.08) !important;
}
.cheatsheet-card {
	border: 1px solid #e2e8f0;
	border-radius: 14px;
	padding: 20px;
	background: white;
	box-shadow: 0 4px 15px rgba(0,0,0,0.01);
	transition: transform 0.2s ease;
}
.cheatsheet-card:hover {
	transform: translateY(-2px);
	box-shadow: 0 6px 18px rgba(0,0,0,0.06);
}
</style>
</head>
<body>

	<nav class="navbar navbar-dark bg-dark px-4 shadow-sm">
		<a href="${pageContext.request.contextPath}/home" class="navbar-brand mb-0 h1"> 
			<i class="bi bi-speedometer2 me-2"></i>Dashboard
		</a> 
		<a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
	</nav>

	<div class="container mt-5" style="max-width: 700px;">

		<c:if test="${not empty message}">
			<div class="alert alert-success alert-dismissible fade show" role="alert">
				<i class="bi bi-check-circle-fill me-2"></i>${message}
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</c:if>
		<c:if test="${not empty error}">
			<div class="alert alert-danger alert-dismissible fade show" role="alert">
				<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</c:if>

		<div class="card shadow border-0 rounded-3">

			<div class="card-header bg-white border-0 pt-3 px-4">
				<ul class="nav nav-tabs card-header-tabs" id="profileTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link ${param.tab != 'security' ? 'active' : ''}"
							id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane" type="button" role="tab">
							<i class="bi bi-person-vcard me-2"></i>Profile Info
						</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link ${param.tab == 'security' ? 'active' : ''}"
							id="security-tab" data-bs-toggle="tab" data-bs-target="#security-pane" type="button" role="tab">
							<i class="bi bi-shield-lock me-2"></i>Change Password
						</button>
					</li>
				</ul>
			</div>

			<div class="card-body p-4">
				<div class="tab-content" id="profileTabContent">

					<div class="tab-pane fade ${param.tab != 'security' ? 'show active' : ''}" id="info-pane" role="tabpanel">

						<form action="${pageContext.request.contextPath}/profile/upload-avatar" method="POST" enctype="multipart/form-data" class="mb-4 pb-4 border-bottom">
							<div class="d-flex align-items-center">
								<c:choose>
								    <c:when test="${not empty user.avatarPath}">
								        <img src="${pageContext.request.contextPath}/profile/avatar/${user.avatarPath}"
								            class="rounded-circle me-4 shadow-sm"
								            style="width: 80px; height: 80px; object-fit: cover; border: 3px solid #0d6efd;">
								    </c:when>
								    <c:otherwise>
								        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
								            class="rounded-circle me-4 shadow-sm"
								            style="width: 80px; height: 80px; object-fit: cover; border: 3px solid #ccc;">
								    </c:otherwise>
								</c:choose>

								<div class="flex-grow-1">
									<label class="form-label text-muted small fw-bold">Change Profile Picture</label>

									<div class="input-group input-group-sm" style="max-width: 350px;">
										<input type="file" id="avatarFile" name="avatarFile" class="form-control" accept="image/*" required>
										<button class="btn btn-dark" id="uploadBtn" type="submit">
											<i class="bi bi-upload me-1"></i>Upload
										</button>
									</div>

									<div id="fileError" class="text-danger small mt-1 fw-bold" style="display: none;"></div>
									<div class="form-text small text-muted">Accepts JPG, PNG images.</div>
								</div>
							</div>
						</form>

						<div class="d-flex align-items-center justify-content-between mb-4">
							<div class="d-flex align-items-center">
								<h5 class="card-title text-secondary mb-0">Personal Details</h5>
								<span class="badge ${user.role == 1 ? 'bg-danger' : 'bg-primary'} ms-3">
									<c:out value="${user.role == 1 ? 'Admin' : 'Regular User'}" />
								</span>
							</div>
							
							<div class="d-flex gap-2">
							    <a href="${pageContext.request.contextPath}/profile/show/followers" class="badge bg-light text-dark border py-2 px-3 badge-link shadow-sm text-hover-primary">
							        <i class="bi bi-people-fill text-primary me-1"></i> <strong>${followersCount != null ? followersCount : 0}</strong> Followers
							    </a>
							    
							    <a href="${pageContext.request.contextPath}/profile/show/following" class="badge bg-light text-dark border py-2 px-3 badge-link shadow-sm text-hover-success">
							        <i class="bi bi-person-plus-fill text-success me-1"></i> <strong>${followingCount != null ? followingCount : 0}</strong> Following
							    </a>
							</div>
						</div>
						
						<form action="${pageContext.request.contextPath}/profile/update" method="POST" class="border-bottom pb-4 mb-4">
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Full Name</label> 
								<input type="text" name="fullName" value="${user.fullName}" class="form-control" required>
							</div>
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Email Address</label> 
								<input type="email" name="email" value="${user.email}" class="form-control" required>
							</div>
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Bio / About Me</label>
								<textarea name="bio" class="form-control" rows="3" placeholder="Tell us about yourself..."><c:out value="${user.bio}" /></textarea>
							</div>
							
							<div class="d-flex justify-content-between pt-2">
								<a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-3 btn-sm"> 
									<i class="bi bi-arrow-left me-1"></i> Back to Dashboard
								</a>
								<button type="submit" class="btn btn-primary px-4 btn-sm">
									<i class="bi bi-save me-2"></i>Update Profile
								</button>
							</div>
						</form>

						<div class="mt-4">
							<h5 class="fw-bold text-dark mb-3">
								<i class="bi bi-file-earmark-code me-2 text-primary"></i>My Cheat Sheets
							</h5>
							
							<c:choose>
								<c:when test="${empty cheatSheetsList}">
									<div class="text-center text-muted py-4 bg-white rounded-3 border border-dashed">
										<i class="bi bi-folder2-open display-6 d-block mb-2 text-secondary"></i>
										You haven't published any cheat sheets yet.
									</div>
								</c:when>
								<c:otherwise>
									<div class="row g-3">
										<c:forEach items="${cheatSheetsList}" var="sheet">
											<div class="col-md-6">
												<div class="cheatsheet-card">
													<h6 class="fw-bold mb-1 text-dark">${sheet.title}</h6>
													<p class="text-secondary small text-truncate mb-2">${sheet.description}</p>
													<div class="d-flex justify-content-between align-items-center mt-2">
														<span class="badge bg-light text-dark border rounded-pill">${sheet.category.name}</span>
														<small class="text-muted"><i class="bi bi-eye me-1"></i> ${sheet.viewCount != null ? sheet.viewCount : 0}</small>
													</div>
												</div>
											</div>
										</c:forEach>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						</div>

					<div class="tab-pane fade ${param.tab == 'security' ? 'show active' : ''}" id="security-pane" role="tabpanel">
						<h5 class="card-title text-danger mb-2">Account Security</h5>
						<p class="text-muted small mb-4">Please type your current password to authorize changing to a new password.</p>

						<form action="${pageContext.request.contextPath}/profile/change-password" method="POST">
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Old Password</label> 
								<input type="password" name="oldPassword" class="form-control" placeholder="Enter current password" required>
							</div>
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">New Password</label> 
								<input type="password" name="newPassword" class="form-control" placeholder="At least 6 characters" required>
							</div>
							<div class="text-end pt-2">
								<button type="submit" class="btn btn-dark px-4 btn-sm">
									<i class="bi bi-key me-2"></i>Change Password
								</button>
							</div>
						</form>
					</div>

				</div>
			</div>

		</div>
	</div>

	<script>
	document.getElementById('avatarFile').addEventListener('change', function() {
	    const file = this.files[0];
	    const errorDiv = document.getElementById('fileError');
	    const uploadBtn = document.getElementById('uploadBtn');
	    const previewImg = document.querySelector('.tab-pane.active img');

	    if (file) {
	        if (!file.type.startsWith('image/')) {
	            errorDiv.textContent = "❌ Invalid file! Please select an image file (JPG, PNG) only.";
	            errorDiv.style.display = "block";
	            this.value = "";
	            uploadBtn.disabled = true;
	        } else {
	            errorDiv.style.display = "none";
	            uploadBtn.disabled = false;
	            
	            const reader = new FileReader();
	            reader.onload = function(e) {
	                previewImg.src = e.target.result;
	            }
	            reader.readAsDataURL(file);
	        }
	    }
	});
	</script>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>