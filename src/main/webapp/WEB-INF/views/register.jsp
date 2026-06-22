<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Register</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" 
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center"
	style="height: 100vh;">
	<div class="card p-4 shadow" style="width: 400px;">
		<h3 class="text-center mb-4">Create Account</h3>

		<c:if test="${not empty error}">
			<div class="alert alert-danger alert-dismissible fade show"
				role="alert">
				<i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
		</c:if>

		<form action="${pageContext.request.contextPath}/register"
			method="POST" onsubmit="return validateForm()">
			
			<div class="mb-3">
				<label class="form-label">Username</label> 
				<input type="text" id="username" name="username" class="form-control" required>
			</div>
			
			<div class="mb-3">
				<label class="form-label">Email Address</label> 
				<input type="email" id="email" name="email" class="form-control" required>
				<div id="emailError" class="text-danger small mt-1" style="display:none;">Invalid email format!</div>
			</div>
			
			<div class="mb-3">
				<label class="form-label">Full Name</label> 
				<input type="text" id="fullName" name="fullName" class="form-control" required>
				<div id="nameError" class="text-danger small mt-1" style="display:none;">Full Name should contain only letters and spaces!</div>
			</div>
			
			<div class="mb-3">
				<label class="form-label">Password</label>
				<input type="password" id="password" name="password" class="form-control" 
					   placeholder="Move pointer here to auto-generate" required>
				<div id="passwordError" class="text-danger small mt-1" style="display:none;">Password must be at least 8 characters long!</div>
			</div>
			
			<div class="mb-3">
				<label class="form-label">Confirm Password</label> 
				<input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
				<div id="matchError" class="text-danger small mt-1" style="display:none;">Passwords do not match!</div>
			</div>
			
			<div class="d-flex gap-2 mt-4">
				<button type="submit" class="btn btn-primary w-50">Sign Up</button>
				<a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary w-50 d-flex align-items-center justify-content-center">
					Cancel
				</a>
			</div>
		</form>
		
		<p class="text-center mt-3 small">
			Already have an account? <a href="login">Login</a>
		</p>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script>
	const passInput = document.getElementById("password");
	const confirmInput = document.getElementById("confirmPassword");

	// ✨ ၁။ Pointer တင်လိုက်ရင် Auto-Generate လုပ်ပေးမည့် စနစ်
	passInput.addEventListener("mouseenter", handleAutoPassword);
	passInput.addEventListener("focus", handleAutoPassword);

	function handleAutoPassword() {
		// ကွက်လပ်က အလွတ်ဖြစ်နေမှသာ အော်တိုထုတ်ပေးမည်
		if (passInput.value === "") {
			autoGeneratePassword();
		}
	}

	// 🎲 Password အော်တို ထုတ်ပေးသည့် လုပ်ဆောင်ချက်
	function autoGeneratePassword() {
		const uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		const lowercase = "abcdefghijklmnopqrstuvwxyz";
		const numbers = "0123456789";
		const symbols = "!@#$%^&*()";
		
		const allChars = uppercase + lowercase + numbers + symbols;
		let password = "";
		
		password += uppercase[Math.floor(Math.random() * uppercase.length)];
		password += lowercase[Math.floor(Math.random() * lowercase.length)];
		password += numbers[Math.floor(Math.random() * numbers.length)];
		password += symbols[Math.floor(Math.random() * symbols.length)];
		
		for (let i = 0; i < 8; i++) {
			password += allChars[Math.floor(Math.random() * allChars.length)];
		}
		
		password = password.split('').sort(() => 0.5 - Math.random()).join('');

		passInput.value = password;
		confirmInput.value = password;

		// ဖွင့်ပြထားရန် Type ကို Text ပြောင်းခြင်း
		passInput.setAttribute("type", "text");
		confirmInput.setAttribute("type", "text");
	}

	// 🔒 ၂။ ဖြည့်စွက်ချက် - User ကိုယ်တိုင် လက်နဲ့ စာရိုက်လျှင် အော်တို ပြန်ဖျောက် (Hide) ပေးမည့် စနစ်
	passInput.addEventListener("input", function() {
		// User က ကိုယ်တိုင် စာရိုက်တာ သို့မဟုတ် ပြင်တာနဲ့ ကွက်လပ်ကို password ပြန်ပြောင်းပြီး ဖျောက်မည်
		passInput.setAttribute("type", "password");
	});

	confirmInput.addEventListener("input", function() {
		// Confirm Password ကွက်လပ်ကိုလည်း ထို့အတူ ပြန်ဖျောက်မည်
		confirmInput.setAttribute("type", "password");
	});


	// 🔍 ၃။ Form Validation စစ်ဆေးခြင်း
	function validateForm() {
		let isValid = true;

		const email = document.getElementById("email").value;
		const fullName = document.getElementById("fullName").value;
		const password = passInput.value;
		const confirmPassword = confirmInput.value;

		const emailError = document.getElementById("emailError");
		const nameError = document.getElementById("nameError");
		const passwordError = document.getElementById("passwordError");
		const matchError = document.getElementById("matchError");

		emailError.style.display = "none";
		nameError.style.display = "none";
		passwordError.style.display = "none";
		matchError.style.display = "none";

		// Email Format
		const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
		if (!emailPattern.test(email)) {
			emailError.style.display = "block";
			isValid = false;
		}

		// Full Name (စာလုံးနှင့် Space သာ)
		const namePattern = /^[a-zA-Z\s]+$/;
		if (!namePattern.test(fullName)) {
			nameError.style.display = "block";
			isValid = false;
		}

		// Password Length
		if (password.length < 8) {
			passwordError.style.display = "block";
			isValid = false;
		}

		// Password Match
		if (password !== confirmPassword) {
			matchError.style.display = "block";
			isValid = false;
		}

		return isValid;
	}
	</script>
</body>
</html>