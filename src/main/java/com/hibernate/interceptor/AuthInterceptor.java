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
	    User user = (User) session.getAttribute("currentUser");

	    
	    if (user == null) {
	        response.sendRedirect(request.getContextPath() + "/login?error=login_required");
	        return false;
	    }

	    
		    if (uri.contains("/admin") && user.getRole() != 1) {
	        response.sendRedirect(request.getContextPath() + "/login?error=admin_only");
	        return false;
	    }

	    return true;
	}
}
