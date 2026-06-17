package com.hibernate.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.hibernate.entity.User;

public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        
        // Allow public pages
        if (uri.endsWith("login") || uri.endsWith("register")) {
            return true;
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        // If not logged in, redirect to login page
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        // Role-based URL protection
        if (uri.contains("/admin") && !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins Only");
            return false;
        }

        return true;
    }
}
