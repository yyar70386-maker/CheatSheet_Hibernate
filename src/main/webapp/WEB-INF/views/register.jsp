<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

<title>Register</title>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

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

.btn-primary{
	height:48px;
	border-radius:12px;
	background:linear-gradient(135deg,#0d6efd,#4facfe);
	border:none;
	font-weight:600;
}

.btn-primary:hover{
	transform:translateY(-2px);
	box-shadow:0 10px 20px rgba(13,110,253,.3);
}

.error{
	color:red;
	font-size:12px;
	display:none;
	margin-top:5px;
}

</style>

</head>

<body>

<div class="card-box">

	<h3>Create Account</h3>
	<p class="sub">Join Cheat Sheet System</p>

	<c:if test="${not empty error}">
		<div class="alert alert-danger text-center">
			${error}
		</div>
	</c:if>

	<form action="${pageContext.request.contextPath}/register"
		method="POST"
		onsubmit="return validateForm()">

		<!-- Username -->
		<div class="mb-3">
			<label>Username</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-person"></i></span>
				<input type="text" id="username" name="username" class="form-control">
			</div>
			<div id="usernameError" class="error">Username is required</div>
		</div>

		<!-- Email -->
		<div class="mb-3">
			<label>Email</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-envelope"></i></span>
				<input type="text" id="email" name="email" class="form-control">
			</div>
			<div id="emailError" class="error">Invalid email</div>
		</div>

		<!-- Full Name -->
		<div class="mb-3">
			<label>Full Name</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-card-text"></i></span>
				<input type="text" id="fullName" name="fullName" class="form-control">
			</div>
			<div id="nameError" class="error">Only letters allowed</div>
		</div>

		<!-- Password -->
		<div class="mb-3">
			<label>Password</label>

			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock"></i></span>

				<input type="password"
					   id="password"
					   name="password"
					   class="form-control"
					   placeholder="Hover to auto-generate">

				<button type="button"
					   class="btn btn-outline-secondary"
					   onclick="togglePassword()">

					<i class="bi bi-eye" id="eyeIcon"></i>

				</button>
			</div>

			<div id="passwordError" class="error">Min 6 characters, numbers and letters only</div>
		</div>

		<!-- Confirm -->
		<div class="mb-3">
			<label>Confirm Password</label>

			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock-fill"></i></span>

				<input type="password"
					   id="confirmPassword"
					   name="confirmPassword"
					   class="form-control">
			</div>

			<div id="matchError" class="error">Password does not match</div>
		</div>

		<!-- Buttons -->
		<div class="d-grid gap-2 mt-4">
			<button type="submit" class="btn btn-primary">
				Sign Up
			</button>

			<a href="${pageContext.request.contextPath}/"
			   class="btn btn-outline-secondary">
				Cancel
			</a>
		</div>

	</form>

</div>

<script>

const pass=document.getElementById("password");
const confirm=document.getElementById("confirmPassword");
const username=document.getElementById("username");
const email=document.getElementById("email");
const fullName=document.getElementById("fullName");

const usernameError=document.getElementById("usernameError");
const emailError=document.getElementById("emailError");
const nameError=document.getElementById("nameError");
const passwordError=document.getElementById("passwordError");
const matchError=document.getElementById("matchError");

let done=false;

// auto generate once
pass.addEventListener("mouseenter",generateOnce);
pass.addEventListener("focus",generateOnce);

function generateOnce(){
	if(done) return;
	done=true;

	let p=generate();

	pass.value=p;
	confirm.value=p;

	pass.type="text";
	confirm.type="text";
	
	// Trigger live validation immediately after generation
	validatePasswordLive();
	validateConfirmPasswordLive();
}

function generate(){
	const u="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const l="abcdefghijklmnopqrstuvwxyz";
	const n="0123456789";

	let all=u+l+n;
	let p="";

	p+=u[Math.floor(Math.random()*u.length)];
	p+=l[Math.floor(Math.random()*l.length)];
	p+=n[Math.floor(Math.random()*n.length)];

	for(let i=0;i<5;i++){
		p+=all[Math.floor(Math.random()*all.length)];
	}

	return p.split('').sort(()=>0.5-Math.random()).join('');
}

// user type -> stop auto
pass.addEventListener("input",()=>{
	pass.type="password";
	confirm.type="password";
	done=true;
	validatePasswordLive();
});

confirm.addEventListener("input",()=>{
	confirm.type="password";
	validateConfirmPasswordLive();
});

username.addEventListener("input", validateUsernameLive);
email.addEventListener("input", validateEmailLive);
fullName.addEventListener("input", validateFullNameLive);

// Live Validation Functions
function validateUsernameLive() {
	const val = username.value.trim();
	if (val === "") {
		usernameError.innerText = "Username is required";
		usernameError.style.display = "block";
		return false;
	} else if (!/^[a-zA-Z0-9_]{3,20}$/.test(val)) {
		usernameError.innerText = "Min 3 characters, alphanumeric & underscores only";
		usernameError.style.display = "block";
		return false;
	} else {
		usernameError.style.display = "none";
		return true;
	}
}

function validateEmailLive() {
	const val = email.value.trim();
	if (val === "") {
		emailError.innerText = "Email is required";
		emailError.style.display = "block";
		return false;
	} else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
		emailError.innerText = "Invalid email format";
		emailError.style.display = "block";
		return false;
	} else {
		emailError.style.display = "none";
		return true;
	}
}

function validateFullNameLive() {
	const val = fullName.value.trim();
	if (val === "") {
		nameError.innerText = "Full Name is required";
		nameError.style.display = "block";
		return false;
	} else if (!/^[a-zA-Z\s]+$/.test(val)) {
		nameError.innerText = "Only letters and spaces allowed";
		nameError.style.display = "block";
		return false;
	} else {
		nameError.style.display = "none";
		return true;
	}
}

function validatePasswordLive() {
	const val = pass.value;
	if (val === "") {
		passwordError.innerText = "Password is required";
		passwordError.style.display = "block";
		return false;
	} else if (val.length < 6) {
		passwordError.innerText = "Password must be at least 6 characters";
		passwordError.style.display = "block";
		return false;
	} else if (!/^[a-zA-Z0-9]+$/.test(val)) {
		passwordError.innerText = "Letters and numbers only. Special characters not allowed";
		passwordError.style.display = "block";
		return false;
	} else {
		passwordError.style.display = "none";
		return true;
	}
}

function validateConfirmPasswordLive() {
	const val = confirm.value;
	if (val === "") {
		matchError.innerText = "Confirm password is required";
		matchError.style.display = "block";
		return false;
	} else if (pass.value !== val) {
		matchError.innerText = "Passwords do not match";
		matchError.style.display = "block";
		return false;
	} else {
		matchError.style.display = "none";
		return true;
	}
}

// toggle show/hide
function togglePassword(){
	const eye=document.getElementById("eyeIcon");
	if(pass.type==="password"){
		pass.type="text";
		confirm.type="text";
		eye.classList.replace("bi-eye","bi-eye-slash");
	}else{
		pass.type="password";
		confirm.type="password";
		eye.classList.replace("bi-eye-slash","bi-eye");
	}
}

// Form Submission validation
function validateForm(){
	let isUsernameValid = validateUsernameLive();
	let isEmailValid = validateEmailLive();
	let isFullNameValid = validateFullNameLive();
	let isPasswordValid = validatePasswordLive();
	let isConfirmValid = validateConfirmPasswordLive();

	return isUsernameValid && isEmailValid && isFullNameValid && isPasswordValid && isConfirmValid;
}

</script>

</body>
</html>