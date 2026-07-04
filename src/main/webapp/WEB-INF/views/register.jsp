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
				<input type="text" name="username" class="form-control" required>
			</div>
		</div>

		<!-- Email -->
		<div class="mb-3">
			<label>Email</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-envelope"></i></span>
				<input type="email" id="email" name="email" class="form-control" required>
			</div>
			<div id="emailError" class="error">Invalid email</div>
		</div>

		<!-- Full Name -->
		<div class="mb-3">
			<label>Full Name</label>
			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-card-text"></i></span>
				<input type="text" id="fullName" name="fullName" class="form-control" required>
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
					   placeholder="Hover to auto-generate"
					   required>

				<button type="button"
						class="btn btn-outline-secondary"
						onclick="togglePassword()">

					<i class="bi bi-eye" id="eyeIcon"></i>

				</button>
			</div>

			<div id="passwordError" class="error">Min 8 characters</div>
		</div>

		<!-- Confirm -->
		<div class="mb-3">
			<label>Confirm Password</label>

			<div class="input-group">
				<span class="input-group-text"><i class="bi bi-lock-fill"></i></span>

				<input type="password"
					   id="confirmPassword"
					   name="confirmPassword"
					   class="form-control"
					   required>
			</div>

			<div id="matchError" class="error">Password not match</div>
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
}

function generate(){

	const u="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const l="abcdefghijklmnopqrstuvwxyz";
	const n="0123456789";
	const s="!@#$%^&*()";

	let all=u+l+n+s;
	let p="";

	p+=u[Math.floor(Math.random()*u.length)];
	p+=l[Math.floor(Math.random()*l.length)];
	p+=n[Math.floor(Math.random()*n.length)];
	p+=s[Math.floor(Math.random()*s.length)];

	for(let i=0;i<6;i++){
		p+=all[Math.floor(Math.random()*all.length)];
	}

	return p.split('').sort(()=>0.5-Math.random()).join('');
}

// user type -> stop auto
pass.addEventListener("input",()=>{
	pass.type="password";
	confirm.type="password";
	done=true;
});

confirm.addEventListener("input",()=>{
	confirm.type="password";
});

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

// validation
function validateForm(){

	let ok=true;

	const email=document.getElementById("email").value;
	const full=document.getElementById("fullName").value;

	const emailError=document.getElementById("emailError");
	const nameError=document.getElementById("nameError");
	const passwordError=document.getElementById("passwordError");
	const matchError=document.getElementById("matchError");

	emailError.style.display="none";
	nameError.style.display="none";
	passwordError.style.display="none";
	matchError.style.display="none";

	if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)){
		emailError.style.display="block";
		ok=false;
	}

	if(!/^[a-zA-Z\s]+$/.test(full)){
		nameError.style.display="block";
		ok=false;
	}

	if(pass.value.length<8){
		passwordError.style.display="block";
		ok=false;
	}

	if(pass.value!==confirm.value){
		matchError.style.display="block";
		ok=false;
	}

	return ok;
}

</script>

</body>
</html>