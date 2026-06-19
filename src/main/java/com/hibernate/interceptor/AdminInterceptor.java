package com.hibernate.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.hibernate.entity.User;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        
        // 1. Session မရှိရင် သို့မဟုတ် Session ထဲမှာ User data မရှိရင် Login Page ကို ပြန်လွှတ်မယ်
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return false;
        }
        
        // 2. Session ထဲက User ရဲ့ Role ကို စစ်ဆေးမယ် (Role 1 = Admin, Role 0 = User)
        User user = (User) session.getAttribute("currentUser");
        if (user.getRole() != 1) { 
            // Admin မဟုတ်ရင် Home Page (သို့) Access Denied Page ကို မောင်းထုတ်မယ်
            response.sendRedirect(request.getContextPath() + "/home?error=access-denied");
            return false;
        }
        
        return true; // Admin ဟုတ်မှသာ Dashboard ထဲ ပေးဝင်မယ်
    }
}