<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        /* 1. Login Page နှင့် တူညီသော Soft Light Pinkish Background */
        body {
            background: #f4eaee; 
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        /* 2. White Card Style with Soft Shadow */
        .glass-card {
            background: #ffffff;
            border: none;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            transition: all 0.4s ease;
        }

        /* Form styling */
        .form-label {
            color: #4a4a4a;
            font-size: 0.9rem;
        }

        .form-control {
            background: #fff;
            border: 1px solid #e0e0e0;
            color: #333;
            border-radius: 12px;
            padding: 12px;
            transition: all 0.3s ease;
        }

        /* Login page အတိုင်း Focus ဖြတ်ရင် Pinkish Glow ထွက်အောင် ပြုလုပ်ခြင်း */
        .form-control:focus {
            background: #fff;
            border-color: #ff527b;
            color: #333;
            box-shadow: 0 0 0 0.25rem rgba(255, 82, 123, 0.15);
        }

        .form-control::placeholder {
            color: #b0b0b0;
        }

        .input-group-text {
            background: #fff;
            border: 1px solid #e0e0e0;
            color: #888;
            border-radius: 12px;
            cursor: pointer;
        }

        /* Password Strength Meter Background */
        .strength-meter {
            height: 6px;
            border-radius: 3px;
            background-color: #f0f0f0;
            transition: all 0.4s ease;
        }

        /* Real-time checklist requirements box */
        .req-box {
            background: #fdf8fa;
            border: 1px solid #f5e6ec;
        }
        
        .req-item {
            font-size: 0.8rem;
            color: #888;
            transition: all 0.3s ease;
        }
        /* စည်းကမ်းချက်ကိုက်ညီရင် ပြောင်းမယ့် အရောင် (Pink-Red core theme နှင့် လိုက်ဖက်သော Green) */
        .req-item.valid {
            color: #2ecc71 !important; 
        }
        .req-item i {
            margin-right: 5px;
        }

        /* 3. Login Button နှင့် တူညီသော Pink/Magenta Gradient Button */
        .btn-submit {
            background: linear-gradient(90deg, #ff527b 0%, #ff406c 100%);
            border: none;
            padding: 12px;
            font-weight: 600;
            border-radius: 12px;
            color: white;
            transition: all 0.3s ease;
        }
        .btn-submit:hover:not([disabled]) {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(255, 82, 123, 0.3);
            background: linear-gradient(90deg, #ff406c 0%, #e6325c 100%);
        }

        /* 4. Back Home Button ပုံစံမျိုး White Outlined Button Style */
        .btn-back-login {
            display: block;
            width: 100%;
            padding: 11px;
            color: #4a4a4a;
            text-decoration: none;
            font-size: 0.95rem;
            border: 1px solid #cccccc;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s;
            text-align: center;
        }
        .btn-back-login:hover {
            background-color: #f9f9f9;
            color: #111;
            border-color: #999;
        }

        /* Success Animation Overlay (ဒီဇိုင်းအရောင်ပြောင်း) */
        .success-overlay {
            display: none;
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 24px;
            z-index: 10;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.5s ease forwards;
        }
        
        .success-checkmark {
            width: 80px; height: 80px;
            border-radius: 50%;
            background: #2ecc71;
            display: flex; justify-content: center; align-items: center;
            font-size: 40px; color: white;
            box-shadow: 0 0 20px rgba(46, 204, 113, 0.3);
            animation: scaleUp 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
        }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes scaleUp { from { transform: scale(0); } to { transform: scale(1); } }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center p-3">

    <div class="card glass-card p-4 p-sm-5 position-relative" style="width: 100%; max-width: 440px;">
        
        <div class="success-overlay" id="successOverlay">
            <div class="success-checkmark mb-3">
                <i class="bi bi-check-lg"></i>
            </div>
            <h4 class="text-dark fw-bold">Success!</h4>
            <p class="text-muted text-center px-3 small">Your password has been changed successfully. Redirecting to login...</p>
        </div>

        <div class="text-center mb-4">
            <div class="display-6 mb-2" style="color: #ff527b;">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <h4 class="fw-bold text-dark mb-1">CheatSheet</h4>
            <p class="fw-medium text-dark-50 mb-1" style="font-size: 1.15rem;">Setup New Password</p>
            <p class="text-muted small">Please choose a strong password to continue.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger bg-danger bg-opacity-10 border-danger text-danger d-flex align-items-center small mb-4" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset-password" method="POST" id="resetForm" onsubmit="handleFormSubmit(event)">
            <input type="hidden" name="token" value="${token}">

            <div class="mb-3">
                <label class="form-label fw-medium">New Password</label>
                <div class="input-group">
                    <input type="password" name="password" id="password" class="form-control" placeholder="Enter new password" required autocomplete="new-password">
                    <span class="input-group-text" onclick="togglePassword('password', 'eyeIcon1')">
                        <i class="bi bi-eye" id="eyeIcon1"></i>
                    </span>
                </div>
                
                <div class="progress mt-2" style="height: 6px;">
                    <div id="strengthBar" class="progress-bar strength-meter" role="progressbar" style="width: 0%"></div>
                </div>
                <div class="d-flex justify-content-between align-items-center mt-1">
                    <span class="small text-muted" style="font-size: 0.75rem;">Password Strength:</span>
                    <span id="strengthText" class="badge bg-secondary text-capitalize" style="font-size: 0.7rem;">None</span>
                </div>
            </div>

            <div class="p-3 rounded req-box mb-3">
                <div class="row g-2">
                    <div class="col-6 req-item" id="reqLength"><i class="bi bi-circle"></i>8+ Characters</div>
                    <div class="col-6 req-item" id="reqUpper"><i class="bi bi-circle"></i>Uppercase (A-Z)</div>
                    <div class="col-6 req-item" id="reqLower"><i class="bi bi-circle"></i>Lowercase (a-z)</div>
                    <div class="col-6 req-item" id="reqNumber"><i class="bi bi-circle"></i>Number (0-9)</div>
                    <div class="col-12 req-item" id="reqSpecial"><i class="bi bi-circle"></i>Special Character (@$!%*?&)</div>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-medium">Confirm New Password</label>
                <div class="input-group">
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Repeat your password" required disabled>
                    <span class="input-group-text" onclick="togglePassword('confirmPassword', 'eyeIcon2')">
                        <i class="bi bi-eye" id="eyeIcon2"></i>
                    </span>
                </div>
                <div id="matchFeedback" class="small mt-1 d-none"></div>
            </div>

            <button type="submit" id="submitBtn" class="btn btn-submit w-100 shadow-sm mb-3" disabled>
                <i class="bi bi-check2-circle me-1"></i> Update Password
            </button>

            <div>
                <a href="${pageContext.request.contextPath}/login" class="btn-back-login">
                    <i class="bi bi-arrow-left me-1"></i> Back to Login
                </a>
            </div>
        </form>
    </div>

    <script>
        const passwordInput = document.getElementById('password');
        const confirmInput = document.getElementById('confirmPassword');
        const submitBtn = document.getElementById('submitBtn');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const matchFeedback = document.getElementById('matchFeedback');

        const regexRequirements = {
            length: /.{8,}/,
            upper: /[A-Z]/,
            lower: /[a-z]/,
            number: /[0-9]/,
            special: /[@$!%*?&]/
        };

        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.replace('bi-eye', 'bi-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.replace('bi-eye-slash', 'bi-eye');
            }
        }

        passwordInput.addEventListener('input', function() {
            const val = passwordInput.value;
            let score = 0;

            score += updateCriterion('reqLength', regexRequirements.length.test(val));
            score += updateCriterion('reqUpper', regexRequirements.upper.test(val));
            score += updateCriterion('reqLower', regexRequirements.lower.test(val));
            score += updateCriterion('reqNumber', regexRequirements.number.test(val));
            score += updateCriterion('reqSpecial', regexRequirements.special.test(val));

            if(val.length === 0) {
                updateStrengthBar(0, 'None', 'bg-secondary');
                confirmInput.disabled = true;
            } else if (score <= 2) {
                updateStrengthBar(33, 'Weak ❌', 'bg-danger');
                confirmInput.disabled = true;
            } else if (score <= 4) {
                updateStrengthBar(66, 'Medium ⚠️', 'bg-warning text-dark');
                confirmInput.disabled = true;
            } else if (score === 5) {
                updateStrengthBar(100, 'Strong ✅', 'bg-success');
                confirmInput.disabled = false;
            }
            
            checkPasswordsMatch();
        });

        function updateCriterion(id, isValid) {
            const el = document.getElementById(id);
            if(isValid) {
                el.classList.add('valid');
                el.querySelector('i').className = 'bi bi-check-circle-fill';
                return 1;
            } else {
                el.classList.remove('valid');
                el.querySelector('i').className = 'bi bi-circle';
                return 0;
            }
        }

        function updateStrengthBar(percent, label, bgClass) {
            strengthBar.style.width = percent + '%';
            strengthBar.className = `progress-bar ${bgClass}`;
            strengthText.innerText = label;
            strengthText.className = `badge ${bgClass}`;
        }

        confirmInput.addEventListener('input', checkPasswordsMatch);

        function checkPasswordsMatch() {
            if(confirmInput.disabled || confirmInput.value.length === 0) {
                matchFeedback.className = 'd-none';
                submitBtn.disabled = true;
                return;
            }

            matchFeedback.className = 'small mt-1 d-block';
            if(passwordInput.value === confirmInput.value) {
                matchFeedback.innerText = '✓ Passwords match successfully.';
                matchFeedback.className = 'small mt-1 d-block text-success';
                submitBtn.disabled = false;
            } else {
                matchFeedback.innerText = '✕ Passwords do not match yet.';
                matchFeedback.className = 'small mt-1 d-block text-danger';
                submitBtn.disabled = true;
            }
        }

        function handleFormSubmit(e) {
            e.preventDefault();
            document.getElementById('successOverlay').style.display = 'flex';
            setTimeout(() => {
                document.getElementById('resetForm').submit();
            }, 1800);
        }
    </script>
</body>
</html>