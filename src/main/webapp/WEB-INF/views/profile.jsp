<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
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
	background-color: #f0f2f5;
	font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
	padding-top: 70px;
}

/* 🌟 Navbar Styling (Fixed & High Z-Index) */
.custom-navbar {
	background: #ffffff;
	border-bottom: 1px solid #e4e6eb;
	z-index: 1030;
	/* Profile ပုံတွေ၊ Modal တွေရဲ့ အောက်ကို ရောက်မသွားအောင် */
}

/* 🌟 Profile Card & Cover Photo */
.profile-card {
	border: none;
	border-radius: 16px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
	overflow: hidden;
	background: #ffffff;
}

.cover-photo {
	height: 160px;
	background: linear-gradient(135deg, #0d6efd 0%, #6610f2 100%);
	position: relative;
}

/* 🌟 Avatar Container */
.profile-avatar-container {
	position: relative;
	width: 120px;
	height: 120px;
	display: inline-block;
	margin-top: -60px; /* Pull up to overlap cover photo */
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

/* 🌟 Stats Badges */
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

/* 🌟 Custom Tabs */
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
	color: #0d6efd;
}

.custom-tabs .nav-link.active {
	color: #0d6efd;
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
	background-color: #0d6efd;
	border-radius: 3px 3px 0 0;
}

/* 🌟 Form Controls */
.form-control {
	border-radius: 8px;
	padding: 10px 15px;
	border: 1px solid #ced4da;
}

.form-control:focus {
	box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
}

/* 🌟 CheatSheet Cards */
.cheatsheet-card {
	border: 1px solid #e2e8f0;
	border-radius: 12px;
	padding: 20px;
	background: #ffffff;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
	transition: all 0.3s ease;
	height: 100%;
}

.cheatsheet-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
	border-color: #0d6efd;
}
</style>
</head>
<body>


	<nav class="navbar custom-navbar px-4 shadow-sm fixed-top">
		<a href="${pageContext.request.contextPath}/home"
			class="navbar-brand mb-0 h1 fw-bold text-primary"> <i
			class="bi bi-code-square me-2"></i>DevHub
		</a> <a href="${pageContext.request.contextPath}/home"
			class="btn btn-outline-secondary px-4 rounded-pill fw-bold shadow-sm d-flex align-items-center">
			<i class="bi bi-arrow-left me-2"></i> Back to Dashboard
		</a>

	</nav>

	<div class="container mb-5" style="max-width: 800px;">

		<!-- Alerts -->
		<c:if test="${not empty message}">
			<div
				class="alert alert-success alert-dismissible fade show rounded-4 border-0 shadow-sm"
				role="alert">
				<i class="bi bi-check-circle-fill me-2"></i>${message}
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
		</c:if>
		<c:if test="${not empty error}">
			<div
				class="alert alert-danger alert-dismissible fade show rounded-4 border-0 shadow-sm"
				role="alert">
				<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
		</c:if>

		<!-- 🃏 Profile Main Card -->
		<div class="profile-card">

			<!-- 🎨 Cover Photo -->
			<div class="cover-photo"></div>

			<div class="card-body px-4 pb-4">

				<!-- 👤 Avatar & Stats Header -->
				<div class="d-flex justify-content-between align-items-end mb-3">

					<!-- Avatar Upload Form -->
					<form id="profileAvatarForm"
						action="${pageContext.request.contextPath}/profile/upload-avatar"
						method="POST" enctype="multipart/form-data">
						<div class="profile-avatar-container">
							<c:choose>
								<c:when test="${not empty user.avatarPath}">
									<img
										src="${pageContext.request.contextPath}/profile/avatar/${user.avatarPath}"
										class="profile-avatar-img" data-bs-toggle="modal"
										data-bs-target="#avatarViewModal" style="cursor: pointer;"
										title="Click to view full image">
								</c:when>
								<c:otherwise>
									<img
										src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
										class="profile-avatar-img" data-bs-toggle="modal"
										data-bs-target="#avatarViewModal"
										title="Click to view full image">
								</c:otherwise>
							</c:choose>

							<label for="avatarFile" class="camera-overlay-btn"
								title="Change Profile Picture"> <i
								class="bi bi-camera-fill text-dark fs-6"></i>
							</label> <input type="file" id="avatarFile" name="avatarFile"
								accept="image/*" style="display: none;" required>
						</div>
					</form>

					<!-- Stats Badges -->
					<div class="d-flex gap-2 pb-2">
						<a
							href="${pageContext.request.contextPath}/profile/show/followers"
							class="stat-badge"> <i
							class="bi bi-people-fill text-primary me-1"></i> <span
							class="fs-5">${followersCount != null ? followersCount : 0}</span>
							<span class="text-muted small">Followers</span>
						</a> <a
							href="${pageContext.request.contextPath}/profile/show/following"
							class="stat-badge"> <i
							class="bi bi-person-plus-fill text-success me-1"></i> <span
							class="fs-5">${followingCount != null ? followingCount : 0}</span>
							<span class="text-muted small">Following</span>
						</a>
					</div>
				</div>

				<div id="fileError" class="text-danger small mb-3 fw-bold"
					style="display: none;"></div>

				<!-- 📛 User Info Name -->
				<div class="mb-4">
					<h3 class="fw-bold text-dark mb-1">${user.fullName}</h3>

					<c:if test="${user.role == 1}">
						<span class="badge bg-danger rounded-pill px-3 py-2 shadow-sm">
							<i class="bi bi-shield-lock-fill me-1"></i> Administrator
						</span>
					</c:if>
				</div>
				<!-- 📑 Profile Tabs -->
				<ul class="nav nav-tabs custom-tabs" id="profileTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button
							class="nav-link ${param.tab != 'security' ? 'active' : ''}"
							id="info-tab" data-bs-toggle="tab" data-bs-target="#info-pane"
							type="button" role="tab">
							<i class="bi bi-person-lines-fill me-2"></i>About Me
						</button>
					</li>
					<li class="nav-item" role="presentation">
						<button
							class="nav-link ${param.tab == 'security' ? 'active' : ''}"
							id="security-tab" data-bs-toggle="tab"
							data-bs-target="#security-pane" type="button" role="tab">
							<i class="bi bi-shield-lock-fill me-2"></i>Security
						</button>
					</li>
				</ul>

				<!-- 📝 Tab Contents -->
				<div class="tab-content" id="profileTabContent">

					<!-- Tab 1: Info Pane -->
					<div
						class="tab-pane fade ${param.tab != 'security' ? 'show active' : ''}"
						id="info-pane" role="tabpanel">

						<form action="${pageContext.request.contextPath}/profile/update"
							method="POST"
							class="bg-light p-4 rounded-4 mb-4 border border-white shadow-sm">
							<h5 class="fw-bold mb-3">
								<i class="bi bi-pencil-square me-2 text-muted"></i>Edit Details
							</h5>
							<div class="row g-3">
								<div class="col-md-6">
									<label class="form-label text-muted small fw-bold">Full
										Name</label> <input type="text" name="fullName"
										value="${user.fullName}" class="form-control" required>
								</div>
								<div class="col-md-6">
									<label class="form-label text-muted small fw-bold">Email
										Address</label> <input type="email" name="email" value="${user.email}"
										class="form-control" required>
								</div>
								<div class="col-12">
									<label class="form-label text-muted small fw-bold">Bio
										/ About Me</label>
									<textarea name="bio" class="form-control" rows="3"
										placeholder="Tell us about yourself..."><c:out
											value="${user.bio}" /></textarea>
								</div>
							</div>


							<div class="d-flex justify-content-end pt-4">
								<button type="submit"
									class="btn btn-primary px-4 rounded-pill fw-bold shadow-sm d-flex align-items-center">
									<i class="bi bi-save me-2"></i> Save Changes
								</button>
							</div>
						</form>

						<!-- My Cheat Sheets Section -->
						<div class="mt-5">
							<h5 class="fw-bold text-dark mb-4 border-bottom pb-2">
								<i class="bi bi-file-earmark-code-fill me-2 text-primary"></i>My
								Published Cheat Sheets
							</h5>

							<c:choose>
								<c:when test="${empty cheatSheetsList}">
									<div
										class="text-center text-muted py-5 bg-light rounded-4 border border-dashed">
										<i
											class="bi bi-folder2-open display-4 d-block mb-3 text-secondary opacity-50"></i>
										<h6 class="fw-bold">No cheat sheets found</h6>
										<p class="small mb-0">You haven't published any cheat
											sheets yet.</p>
									</div>
								</c:when>
								<c:otherwise>
									<div class="row g-4">
										<c:forEach items="${cheatSheetsList}" var="sheet">
											<div class="col-md-6">
												<div class="cheatsheet-card d-flex flex-column">
													<h6 class="fw-bold text-dark mb-2">${sheet.title}</h6>
													<p class="text-secondary small mb-3 flex-grow-1">${sheet.description}</p>
													<div
														class="d-flex justify-content-between align-items-center pt-3 border-top">
														<span
															class="badge bg-primary bg-opacity-10 text-primary border border-primary-subtle rounded-pill px-3 py-2">
															${sheet.category.name} </span> <span
															class="text-muted fw-bold small"><i
															class="bi bi-eye-fill me-1 text-secondary"></i>
															${sheet.viewCount != null ? sheet.viewCount : 0}</span>
													</div>
												</div>
											</div>
										</c:forEach>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>

					<!-- Tab 2: Security Pane -->
					<div
						class="tab-pane fade ${param.tab == 'security' ? 'show active' : ''}"
						id="security-pane" role="tabpanel">
						<div
							class="bg-light p-4 rounded-4 border border-white shadow-sm mt-2">
							<h5 class="text-danger fw-bold mb-2">
								<i class="bi bi-shield-lock-fill me-2"></i>Change Password
							</h5>
							<p class="text-muted small mb-4 pb-2 border-bottom">Ensure
								your account is using a long, random password to stay secure.</p>

							<c:if test="${not empty error}">
								<div
									class="alert alert-danger alert-dismissible fade show rounded-3 small fw-bold mb-3"
									role="alert">
									<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>
							<c:if test="${not empty message}">
								<div
									class="alert alert-success alert-dismissible fade show rounded-3 small fw-bold mb-3"
									role="alert">
									<i class="bi bi-check-circle-fill me-2"></i>${message}
									<button type="button" class="btn-close" data-bs-dismiss="alert"
										aria-label="Close"></button>
								</div>
							</c:if>

							<form
								action="${pageContext.request.contextPath}/profile/change-password"
								method="POST" style="max-width: 500px;">

								<div class="mb-3">
									<label class="form-label text-muted small fw-bold">Current
										Password</label> <input type="password" id="oldPassword"
										name="oldPassword" class="form-control"
										placeholder="Enter current password" required>
								</div>

								<div class="mb-3">
									<label class="form-label text-muted small fw-bold">New
										Password</label> <input type="password" id="newPassword"
										name="newPassword" class="form-control"
										placeholder="At least 6 characters (Letters & Numbers only)"
										pattern="^[a-zA-Z0-9]{6,}$"
										title="Must be at least 6 characters long and contain only letters and numbers"
										required>

									<div id="passwordFormatError"
										class="text-danger small mt-1 fw-bold" style="display: none;">
										Must be at least 6 characters (Letters & Numbers only)!</div>

									<div id="sameAsOldError" class="text-danger small mt-1 fw-bold"
										style="display: none;">New password cannot be the same
										as current password!</div>
								</div>

								<div class="mb-4">
									<label class="form-label text-muted small fw-bold">Confirm
										New Password</label> <input type="password" id="confirmPassword"
										name="confirmPassword" class="form-control"
										placeholder="Retype new password" required>
									<div id="passwordMatchError"
										class="text-danger small mt-1 fw-bold" style="display: none;">
										Passwords do not match!</div>
								</div>

								<div>
									<button type="submit" id="submitBtn"
										class="btn btn-dark px-4 rounded-pill fw-bold shadow-sm"
										disabled>
										<i class="bi bi-key-fill me-2"></i>Update Password
									</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 📷 Avatar View Modal -->
	<div class="modal fade" id="avatarViewModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content bg-transparent border-0">
				<div class="modal-header border-0 pb-0 justify-content-end">
					<button type="button" class="btn-close btn-close-white fs-4"
						data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-dialog modal-dialog-centered modal-xl">
					<c:choose>
						<c:when test="${not empty user.avatarPath}">
							<img
								src="${pageContext.request.contextPath}/profile/avatar/${user.avatarPath}"
								class="img-fluid shadow-lg rounded"
								style="max-width: 100%; max-height: 80vh;" alt="Profile Image">
						</c:when>
						<c:otherwise>
							<img src="https://cdn-icons-png.flaticon.com/512/149/149071.png"
								class="img-fluid shadow-lg rounded"
								style="max-width: 100%; max-height: 80vh;" alt="Default Profile">
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</div>

	<!-- 🌟 Scripts -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

	<script>
		// Avatar File Upload Validation Script
		document
				.getElementById('avatarFile')
				.addEventListener(
						'change',
						function() {
							const file = this.files[0];
							const errorDiv = document
									.getElementById('fileError');
							const form = document
									.getElementById('profileAvatarForm');

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

		document
				.addEventListener(
						"DOMContentLoaded",
						function() {
							const oldPassword = document
									.getElementById('oldPassword'); // 🌟 အသစ်ထည့်ထားသည်
							const newPassword = document
									.getElementById('newPassword');
							const confirmPassword = document
									.getElementById('confirmPassword');

							const matchErrorMsg = document
									.getElementById('passwordMatchError');
							const formatErrorMsg = document
									.getElementById('passwordFormatError');
							const sameAsOldErrorMsg = document
									.getElementById('sameAsOldError'); // 🌟 အသစ်ထည့်ထားသည်
							const submitBtn = document
									.getElementById('submitBtn');

							// Regex: စာသားနှင့် ဂဏန်းသာ၊ အနည်းဆုံး ၆ လုံး
							const passwordRegex = /^[a-zA-Z0-9]{6,}$/;

							function validateProfilePassword() {
								let isValidFormat = passwordRegex
										.test(newPassword.value);
								let isMatch = confirmPassword.value === ""
										|| newPassword.value === confirmPassword.value;
								let isSameAsOld = (oldPassword.value !== "" && newPassword.value === oldPassword.value); // 🌟 အသစ်ထည့်ထားသည်

								// ၁။ Format စစ်ဆေးခြင်း
								if (newPassword.value !== "" && !isValidFormat) {
									formatErrorMsg.style.display = 'block';
								} else {
									formatErrorMsg.style.display = 'none';
								}

								// ၂။ အဟောင်းနှင့် အသစ် တူ/မတူ စစ်ဆေးခြင်း
								if (newPassword.value !== "" && isSameAsOld) {
									sameAsOldErrorMsg.style.display = 'block';
								} else {
									sameAsOldErrorMsg.style.display = 'none';
								}

								// ၃။ Confirm Password ကိုက်ညီမှု ရှိ/မရှိ စစ်ဆေးခြင်း
								if (confirmPassword.value !== "" && !isMatch) {
									matchErrorMsg.style.display = 'block';
								} else {
									matchErrorMsg.style.display = 'none';
								}

								// ၄။ သတ်မှတ်ချက် အကုန်ကိုက်ညီမှ (နှင့် အဟောင်းနဲ့မတူမှ) ခလုတ်ကို ဖွင့်ပေးမည်
								if (isValidFormat && isMatch && !isSameAsOld
										&& newPassword.value !== ""
										&& confirmPassword.value !== ""
										&& oldPassword.value !== "") {
									submitBtn.disabled = false;
								} else {
									submitBtn.disabled = true;
								}
							}

							// Field သုံးခုလုံးကို Event Listener တပ်ထားပါမည်
							oldPassword.addEventListener('keyup',
									validateProfilePassword);
							newPassword.addEventListener('keyup',
									validateProfilePassword);
							confirmPassword.addEventListener('keyup',
									validateProfilePassword);
						});
	</script>
</body>
</html>