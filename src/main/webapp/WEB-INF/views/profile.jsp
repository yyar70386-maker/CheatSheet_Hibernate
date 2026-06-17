<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Profile</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
</style>
</head>
<body>

	<nav class="navbar navbar-dark bg-dark px-4 shadow-sm">
		<a href="${pageContext.request.contextPath}/home"
			class="navbar-brand mb-0 h1"> <i class="bi bi-speedometer2 me-2"></i>Dashboard
		</a> <a href="${pageContext.request.contextPath}/logout"
			class="btn btn-outline-danger btn-sm">Logout</a>
	</nav>

	<div class="container mt-5" style="max-width: 700px;">

		<c:if test="${not empty message}">
			<div class="alert alert-success alert-dismissible fade show"
				role="alert">
				<i class="bi bi-check-circle-fill me-2"></i>${message}
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
		</c:if>
		<c:if test="${not empty error}">
			<div class="alert alert-danger alert-dismissible fade show"
				role="alert">
				<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
		</c:if>

		<div class="card shadow border-0 rounded-3">

			<div class="card-header bg-white border-0 pt-3 px-4">
				<ul class="nav nav-tabs card-header-tabs" id="profileTab"
					role="tablist">
					<li class="nav-item" role="presentation">
						<button
							class="nav-link ${param.tab != 'security' ? 'active' : ''}"
							id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane"
							type="button" role="tab">
							<i class="bi bi-person-vcard me-2"></i>Profile Info
						</button>
					</li>
					<li class="nav-item" role="presentation">
						<button
							class="nav-link ${param.tab == 'security' ? 'active' : ''}"
							id="security-tab" data-bs-toggle="tab"
							data-bs-target="#security-pane" type="button" role="tab">
							<i class="bi bi-shield-lock me-2"></i>Change Password
						</button>
					</li>
				</ul>
			</div>

			<div class="card-body p-4">
				<div class="tab-content" id="profileTabContent">

					<div
						class="tab-pane fade ${param.tab != 'security' ? 'show active' : ''}"
						id="info-pane" role="tabpanel">

						<form
							action="${pageContext.request.contextPath}/profile/upload-avatar"
							method="POST" enctype="multipart/form-data"
							class="mb-4 pb-4 border-bottom">
							<div class="d-flex align-items-center">
								<c:choose>
									<c:when test="${not empty user.avatarPath}">
										<img
											src="${pageContext.request.contextPath}/uploads/${user.avatarPath}"
											class="rounded-circle me-4 shadow-sm"
											style="width: 80px; height: 80px; object-fit: cover; border: 3px solid #0d6efd;">
									</c:when>
									<c:otherwise>
										<img
											src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
											class="rounded-circle me-4 shadow-sm"
											style="width: 80px; height: 80px; object-fit: cover; border: 3px solid #ccc;">
									</c:otherwise>
								</c:choose>

								<div class="flex-grow-1">
									<label class="form-label text-muted small fw-bold">Change
										Profile Picture</label>
									<div class="input-group input-group-sm"
										style="max-width: 350px;">
										<input type="file" name="avatarFile" class="form-control"
											accept="image/*" required>
										<button class="btn btn-dark" type="submit">
											<i class="bi bi-upload me-1"></i>Upload
										</button>
									</div>
									<div class="form-text small text-muted">Accepts JPG, PNG
										images.</div>
								</div>
							</div>
						</form>

						<div class="d-flex align-items-center mb-4">
							<h5 class="card-title text-secondary mb-0">Personal Details</h5>
							<span
								class="badge ${user.role == 1 ? 'bg-danger' : 'bg-primary'} ms-3">
								<c:out value="${user.role == 1 ? 'Admin' : 'Regular User'}" />
							</span>
						</div>

						<form action="${pageContext.request.contextPath}/profile/update"
							method="POST">
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Full
									Name</label> <input type="text" name="fullName"
									value="${user.fullName}" class="form-control" required>
							</div>
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Email
									Address</label> <input type="email" name="email" value="${user.email}"
									class="form-control" required>
							</div>
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Bio /
									About Me</label>
								<textarea name="bio" class="form-control" rows="3"
									placeholder="Tell us about yourself..."><c:out
										value="${user.bio}" /></textarea>
							</div>
							<div class="text-end pt-2">
								<a href="${pageContext.request.contextPath}/"
									class="btn btn-primary px-4 btn-sm"> <i
									class="bi bi-arrow-left me-1"></i> Back to Home Dashboard
								</a>
								<button type="submit" class="btn btn-primary px-4 btn-sm">
									<i class="bi bi-save me-2"></i>Update Profile
								</button>

							</div>
						</form>
					</div>

					<div
						class="tab-pane fade ${param.tab == 'security' ? 'show active' : ''}"
						id="security-pane" role="tabpanel">
						<h5 class="card-title text-danger mb-2">Account Security</h5>
						<p class="text-muted small mb-4">Please type your current
							password to authorize changing to a new password.</p>

						<form
							action="${pageContext.request.contextPath}/profile/change-password"
							method="POST">
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">Old
									Password</label> <input type="password" name="oldPassword"
									class="form-control" placeholder="Enter current password"
									required>
							</div>
							<div class="mb-3">
								<label class="form-label text-muted small fw-bold">New
									Password</label> <input type="password" name="newPassword"
									class="form-control" placeholder="At least 6 characters"
									required>
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

		<div class="d-flex justify-content-end align-items-center gap-3 mt-4">



		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>