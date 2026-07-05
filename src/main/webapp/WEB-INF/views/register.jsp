<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Register</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
body{
	min-height:100vh;
	display:flex;
	justify-content:center;
	align-items:center;
	background:linear-gradient(135deg,#4facfe,#00c6fb);
	font-family:"Segoe UI",sans-serif;
	padding:20px;
}

.card-box{
	width:100%;
	max-width:450px;
	background:rgba(255,255,255,0.95);
	border-radius:20px;
	padding:35px;
	box-shadow:0 25px 50px rgba(0,0,0,0.15);
}

h3{
	font-weight:bold;
	text-align:center;
}

.sub{
	text-align:center;
	font-size:14px;
	color:#666;
	margin-bottom:20px;
}

.input-group-text{
	background:#fff;
	border-right:none;
}

.form-control{
	height:48px;
	border-left:none;
}

.form-control:focus {
	background:#fff;
	box-shadow:none;
	border-color:#0d6efd;
}

.btn-primary{
	height:48px;
	border-radius:12px;
	background:linear-gradient(135deg,#0d6efd,#4facfe);
	border:none;
	font-weight:600;
}

.btn-primary:hover:not(:disabled){
	transform:translateY(-2px);
	box-shadow:0 10px 20px rgba(13,110,253,.3);
}

.btn-primary:disabled {
    background: #a5b1c2;
    cursor: not-allowed;
}

/* 🌟 Improved Error Message Styling */
.error{
	color: #dc3545;
	font-size: 13px;
	font-weight: 600;
	display: none;
	margin-top: 5px;
}
.error i {
	margin-right: 4px;
}
</style>
</head>

<body>

<div class="card-box">

	<h3>Create Account</h3>
	<p class="sub">Join Cheat Sheet System</p>

	<c:if test="${not empty error}">
		<div class="alert alert-danger text-center small fw-bold">
			<i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
		</div>
	</c:if>

	<form action="${pageContext.request.contextPath}/register" method="POST" id="regForm">

		<div class="mb-3">
			<label class="form-label small fw-bold text-muted">Username</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-person"></i></span>
				<input type="text" id="username" name="username" class="form-control" placeholder="Enter username" required>
			</div>
			<div id="usernameError" class="error"><i class="bi bi-exclamation-circle"></i>Username is required</div>
		</div>

		<div class="mb-3">
			<label class="form-label small fw-bold text-muted">Email</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-envelope"></i></span>
				<input type="email" id="email" name="email" class="form-control" placeholder="example@gmail.com" required>
			</div>
			<div id="emailError" class="error"><i class="bi bi-exclamation-circle"></i>Invalid email format!</div>
		</div>

		<div class="mb-3">
			<label class="form-label small fw-bold text-muted">Full Name</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-card-text"></i></span>
				<input type="text" id="fullName" name="fullName" class="form-control" placeholder="Enter full name" required>
			</div>
			<div id="nameError" class="error"><i class="bi bi-exclamation-circle"></i>Only letters and spaces allowed!</div>
		</div>

		<div class="mb-3">
			<label class="form-label small fw-bold text-muted">Password</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock"></i></span>
				<input type="password" id="password" name="password" class="form-control" placeholder="Hover to auto-generate" required>
				<button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">
					<i class="bi bi-eye" id="eyeIcon"></i>
				</button>
			</div>
			<div id="passwordError" class="error"><i class="bi bi-exclamation-circle"></i>Must be at least 6 characters (Letters & Numbers only)!</div>
		</div>

		<div class="mb-3">
			<label class="form-label small fw-bold text-muted">Confirm Password</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
				<input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Retype password" required>
			</div>
			<div id="matchError" class="error"><i class="bi bi-exclamation-circle"></i>Passwords do not match!</div>
		</div>

		<div class="d-grid gap-2 mt-4">
			<button type="submit" id="submitBtn" class="btn btn-primary" disabled>
				Sign Up
			</button>
			<a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary d-flex align-items-center justify-content-center fw-bold">
				Cancel
			</a>
		</div>

	</form>

</div>

<script>
const usernameInput = document.getElementById("username");
const emailInput = document.getElementById("email");
const nameInput = document.getElementById("fullName");
const passInput = document.getElementById("password");
const confirmInput = document.getElementById("confirmPassword");
const submitBtn = document.getElementById("submitBtn");

// Errors
const usernameError = document.getElementById("usernameError");
const emailError = document.getElementById("emailError");
const nameError = document.getElementById("nameError");
const passwordError = document.getElementById("passwordError");
const matchError = document.getElementById("matchError");

// Regex Validation Pattern များ
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const nameRegex = /^[a-zA-Z\s]+$/;
const passwordRegex = /^[a-zA-Z0-9]{6,}$/; // 🌟 စာသားနှင့်ဂဏန်းသာ၊ အနည်းဆုံး ၆ လုံး

let done = false;

// 🌟 Auto Generate Logic (Special character မပါ၊ အလုံး ၆ လုံးစည်းမျဉ်းဖြင့် ပြင်ဆင်ထားသည်)
passInput.addEventListener("mouseenter", generateOnce);
passInput.addEventListener("focus", generateOnce);

function generateOnce(){
	if(done) return;
	done = true;

	let p = generateRandomPassword();

	passInput.value = p;
	confirmInput.value = p;

	passInput.type = "text";
	confirmInput.type = "text";
    
    validateFormRealTime();
}

function generateRandomPassword(){
	const u = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const l = "abcdefghijklmnopqrstuvwxyz";
	const n = "0123456789";

	let all = u + l + n;
	let p = "";

	// စည်းမျဉ်းပြည့်စုံရန် အနည်းဆုံး တစ်လုံးစီအရင်ထည့်မည်
	p += u[Math.floor(Math.random() * u.length)];
	p += l[Math.floor(Math.random() * l.length)];
	p += n[Math.floor(Math.random() * n.length)];

	// စုစုပေါင်း ၆ လုံးပြည့်အောင် ဖြည့်မည်
	for(let i = 0; i < 3; i++){
		p += all[Math.floor(Math.random() * all.length)];
	}

	return p.split('').sort(() => 0.5 - Math.random()).join('');
}

// User စာရိုက်လျှင် password ပြန်ဖျောက်ရန်
passInput.addEventListener("input", () => {
	passInput.type = "password";
	confirmInput.type = "password";
	done = true;
});

confirmInput.addEventListener("input", () => {
	confirmInput.type = "password";
});

// Toggle Show/Hide Password
function togglePassword(){
	const eye = document.getElementById("eyeIcon");
	if(passInput.type === "password"){
		passInput.type = "text";
		confirmInput.type = "text";
		eye.classList.replace("bi-eye", "bi-eye-slash");
	} else {
		passInput.type = "password";
		confirmInput.type = "password";
		eye.classList.replace("bi-eye-slash", "bi-eye");
	}
}

// 🛡️ Real-time Keyboard Form Validation စနစ်
function validateFormRealTime(){
	let isFormValid = true;

	// ၁။ Username Validation
	if(usernameInput.value.trim() === "") {
		usernameError.style.display = "block";
		isFormValid = false;
	} else {
		usernameError.style.display = "none";
	}

	// ၂။ Email Validation
	if(emailInput.value !== "" && !emailRegex.test(emailInput.value)){
		emailError.style.display = "block";
		isFormValid = false;
	} else {
		emailError.style.display = "none";
		if(emailInput.value === "") isFormValid = false;
	}

	// ၃။ Full Name Validation
	if(nameInput.value !== "" && !nameRegex.test(nameInput.value)){
		nameError.style.display = "block";
		isFormValid = false;
	} else {
		nameError.style.display = "none";
		if(nameInput.value === "") isFormValid = false;
	}

	// ၄။ Password Format Validation
	if(passInput.value !== "" && !passwordRegex.test(passInput.value)){
		passwordError.style.display = "block";
		isFormValid = false;
	} else {
		passwordError.style.display = "none";
		if(passInput.value === "") isFormValid = false;
	}

	// ၅။ Confirm Password Match Validation
	let isMatch = (passInput.value === confirmInput.value);
	if(confirmInput.value !== "" && !isMatch){
		matchError.style.display = "block";
		isFormValid = false;
	} else {
		matchError.style.display = "none";
		if(confirmInput.value === "") isFormValid = false;
	}

	// အားလုံးမှန်ကန်မှ Sign Up ခလုတ်ကို နှိပ်ခွင့်ပြုမည်
	submitBtn.disabled = !isFormValid;
}

// Event Listeners များ တပ်ဆင်ခြင်း
usernameInput.addEventListener('input', validateFormRealTime);
emailInput.addEventListener('input', validateFormRealTime);
nameInput.addEventListener('input', validateFormRealTime);
passInput.addEventListener('input', validateFormRealTime);
confirmInput.addEventListener('input', validateFormRealTime);

</script>

</body>
</html>