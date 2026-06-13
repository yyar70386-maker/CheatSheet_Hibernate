<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CheatSheet - Login</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f8f9fa; }
        .login-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 350px; }
        h2 { margin-top: 0; font-size: 28px; font-weight: bold; text-align: center; }
        label { display: block; margin-top: 15px; font-weight: 500; }
        .input-field { width: 100%; padding: 12px; margin-top: 8px; border: 1px solid #ced4da; border-radius: 6px; box-sizing: border-box; }
        .error-msg { color: #dc3545; font-size: 14px; margin-top: 10px; text-align: center; }
        .sign-in-btn { width: 100%; padding: 12px; background-color: #007bff; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>
<div class="login-card">
    <h2>UserLogin</h2>
    
    <% if (request.getAttribute("error") != null) { %>
        <p class="error-msg"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="UserLogin" method="post">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" class="input-field" placeholder="Enter username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" class="input-field" placeholder="Enter password" required>

        <button type="submit" class="sign-in-btn">Sign In</button>
    </form>
    <p style="text-align:center; margin-top:15px; font-size:14px;">
        Don't have an account? <a href="RegisterLogin.jsp">Register here</a>
    </p>
</div>
</body>
</html>