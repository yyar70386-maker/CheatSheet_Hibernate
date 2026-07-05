<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Reset Password</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
*{
	margin:0;
	padding:0;
	box-sizing:border-box;
	font-family:"Segoe UI",sans-serif;
}

body{
	min-height:100vh;
	display:flex;
	justify-content:center;
	align-items:center;
	background:linear-gradient(135deg,#4facfe,#00c6fb);
	padding:20px;
}

.reset-card{
	width:100%;
	max-width:460px;
	background:rgba(255,255,255,.95);
	border:none;
	border-radius:22px;
	padding:35px;
	box-shadow:0 20px 45px rgba(0,0,0,.18);
	animation:fadeIn .5s ease;
}

.logo{
	width:85px;
	height:85px;
	margin:auto;
	margin-bottom:20px;
	border-radius:50%;
	background:linear-gradient(135deg,#0d6efd,#4facfe);
	display:flex;
	justify-content:center;
	align-items:center;
	color:white;
	font-size:35px;
	box-shadow:0 10px 20px rgba(13,110,253,.3);
}

h3{
	text-align:center;
	font-weight:700;
	color:#222;
	margin-bottom:8px;
}

.subtitle{
	text-align:center;
	color:#6c757d;
	font-size:14px;
	margin-bottom:25px;
}

.form-label{
	font-weight:600;
	color:#495057;
	margin-bottom:6px;
}

.input-group-text{
	background:#f8f9fa;
	border-right:none;
	border-radius:12px 0 0 12px;
}

.form-control{
	height:50px;
	border-left:none;
	border-radius:0 12px 12px 0;
	background:#f8f9fa;
}

.form-control:focus{
	background:#fff;
	box-shadow:none;
	border-color:#0d6efd;
}

.btn-reset{
	height:50px;
	border:none;
	border-radius:12px;
	background:linear-gradient(135deg,#0d6efd,#4facfe);
	color:white;
	font-weight:600;
	transition:.3s;
}

.btn-reset:hover:not(:disabled){
	transform:translateY(-2px);
	box-shadow:0 12px 20px rgba(13,110,253,.3);
}

.btn-reset:disabled {
    background: #a5b1c2;
    cursor: not-allowed;
}

.btn-login{
	height:50px;
	border-radius:12px;
}

.alert{
	border-radius:12px;
}

.toggle-btn{
	border-left:none;
	background:#f8f9fa;
}

.toggle-btn:hover{
	background:#e9ecef;
}

/* 🌟 Real-time Validation UI 🌟 */
.req-list {
    font-size: 0.85rem;
    font-weight: 600;
    margin-top: 8px;
    padding-left: 5px;
}
.req-item {
    transition: 0.3s ease;
    margin-bottom: 4px;
}

@keyframes fadeIn{
	from{ opacity:0; transform:translateY(25px); }
	to{ opacity:1; transform:translateY(0); }
}
</style>
</head>

<body>

<div class="reset-card">

	<div class="logo">
		<i class="bi bi-shield-lock-fill"></i>
	</div>

	<h3>Create New Password</h3>
	<p class="subtitle">Your new password must be different from your previous password.</p>

	<c:if test="${not empty error}">
		<div class="alert alert-danger text-center">
			<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
		</div>
	</c:if>

	<form action="${pageContext.request.contextPath}/reset-password" method="POST">
		<input type="hidden" name="token" value="${token}">

		<div class="mb-3">
			<label class="form-label">New Password</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
				<input type="password" name="password" id="password" class="form-control" placeholder="Enter new password" required>
				<button type="button" class="btn toggle-btn" onclick="togglePassword('password','eye1')">
					<i class="bi bi-eye" id="eye1"></i>
				</button>
			</div>
            
            <div class="req-list">
                <div id="req-length" class="req-item text-danger"><i class="bi bi-x-circle me-1"></i> At least 6 characters</div>
                <div id="req-format" class="req-item text-danger"><i class="bi bi-x-circle me-1"></i> Letters and numbers only</div>
            </div>
		</div>

		<div class="mb-3">
			<label class="form-label">Confirm Password</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock"></i></span>
				<input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Confirm password" required>
				<button type="button" class="btn toggle-btn" onclick="togglePassword('confirmPassword','eye2')">
					<i class="bi bi-eye" id="eye2"></i>
				</button>
			</div>
			<div id="matchError" class="text-danger small mt-2 fw-bold" style="display:none;">
				<i class="bi bi-exclamation-circle me-1"></i> Passwords do not match!
			</div>
		</div>

		<div class="d-grid gap-2 mt-4">
			<button type="submit" class="btn btn-reset" id="submitBtn" disabled>
				<i class="bi bi-check-circle-fill me-2"></i>Reset Password
			</button>
			<a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary btn-login d-flex align-items-center justify-content-center">
				<i class="bi bi-arrow-left me-2"></i>Back to Login
			</a>
		</div>

	</form>

</div>

<script>
// 👁️ Show/Hide Password Toggle
function togglePassword(inputId, eyeId){
	let input = document.getElementById(inputId);
	let eye = document.getElementById(eyeId);
	if(input.type === "password"){
		input.type = "text";
		eye.classList.remove("bi-eye");
		eye.classList.add("bi-eye-slash");
	} else {
		input.type = "password";
		eye.classList.remove("bi-eye-slash");
		eye.classList.add("bi-eye");
	}
}

// 🛡️ Real-time Form Validation
const passwordInput = document.getElementById('password');
const confirmInput = document.getElementById('confirmPassword');
const reqLength = document.getElementById('req-length');
const reqFormat = document.getElementById('req-format');
const matchError = document.getElementById('matchError');
const submitBtn = document.getElementById('submitBtn');

// စာသားနှင့် ဂဏန်းသာ (Special Character မပါရ)
const formatRegex = /^[a-zA-Z0-9]+$/;

function updateRequirement(element, isValid, text) {
    if(isValid) {
        element.className = "req-item text-success";
        element.innerHTML = `<i class="bi bi-check-circle-fill me-1"></i> ${text}`;
    } else {
        element.className = "req-item text-danger";
        element.innerHTML = `<i class="bi bi-x-circle me-1"></i> ${text}`;
    }
}

function validateRealTime() {
    const pVal = passwordInput.value;
    const cVal = confirmInput.value;

    // ၁။ Length စစ်ဆေးခြင်း
    const isValidLength = pVal.length >= 6;
    updateRequirement(reqLength, isValidLength);

    // ၂။ Format စစ်ဆေးခြင်း 
    const isValidFormat = pVal.length > 0 && formatRegex.test(pVal);
    updateRequirement(reqFormat, isValidFormat);

    // ၃။ Match စစ်ဆေးခြင်း
    const isMatch = (pVal === cVal && cVal.length > 0);
    
    if (cVal.length > 0 && !isMatch) {
        matchError.style.display = "block";
    } else {
        matchError.style.display = "none";
    }

    // လိုအပ်ချက် အားလုံးပြည့်စုံမှ Submit ကို ဖွင့်ပေးမည်
    if (isValidLength && isValidFormat && isMatch) {
        submitBtn.disabled = false;
    } else {
        submitBtn.disabled = true;
    }
}

// ရိုက်နေစဉ် ချက်ချင်း အလုပ်လုပ်စေရန် Event Listener များ တပ်ဆင်ခြင်း
passwordInput.addEventListener('input', validateRealTime);
confirmInput.addEventListener('input', validateRealTime);

</script>

</body>
</html>