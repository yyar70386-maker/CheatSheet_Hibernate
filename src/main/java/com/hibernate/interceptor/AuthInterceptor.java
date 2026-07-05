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
	    HttpSession session = request.getSession();
	    
	    // 🌟 ၁။ CSS, JS, Images စတဲ့ Static Resource တွေနဲ့ မလိုလားအပ်တဲ့ Loop ပတ်တာတွေကို ကျော်ခိုင်းမယ်
	    if (uri.contains("/resources/") || uri.contains("/static/") || uri.endsWith(".css") || uri.endsWith(".js")) {
	        return true;
	    }
	    
	    // 🌟 ၂။ Public Pages (Login, Register, Home) တွေကို ခွင့်ပြုမယ်
	    if (uri.endsWith("/login") || uri.endsWith("/register") || uri.endsWith(request.getContextPath() + "/")) {
	        return true;
	    }

	    User user = (User) session.getAttribute("currentUser");

	    // 🌟 ၃။ Login မဝင်ထားဘဲ URL ကနေ လှမ်းဝင်လာပါက
	    if (user == null) {
	        // Session ထဲမှာ Error Message ကို သိမ်းလိုက်မယ် (JSP က ${error} ဆိုပြီး တန်းဖတ်လို့ရပါတယ်)
	        session.setAttribute("error", "Please log in first to access this page!");
	        
	        // Login Page သို့ Redirect လုပ်မည်
	        response.sendRedirect(request.getContextPath() + "/login");
	        return false;
	    }

	    // 🌟 ၄။ Role စစ်ဆေးခြင်း (Admin Page တွေကို ရိုးရိုး User ဝင်မရအောင် တားဆီးခြင်း)
	    if (uri.contains("/admin") && user.getRole() != 1) {
	        session.setAttribute("error", "Access Denied! Admins only.");
	        response.sendRedirect(request.getContextPath() + "/profile?tab=security"); // သို့မဟုတ် /login သို့ ပြန်မောင်းထုတ်နိုင်သည်
	        return false;
	    }

	    return true;
	}
}