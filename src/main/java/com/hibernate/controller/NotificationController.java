package com.hibernate.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.entity.User;
import com.hibernate.service.NotificationService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    @GetMapping("/notifications")
    public String list(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("notifications", notificationService.findByUserId(currentUser.getId()));
        return "notifications";
    }

    @GetMapping("/notifications/recent")
    @ResponseBody
    public Map<String, Object> recent(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        Map<String, Object> response = new HashMap<>();
        if (currentUser == null) {
            response.put("unreadCount", 0);
            response.put("notifications", java.util.Collections.emptyList());
            return response;
        }

        response.put("unreadCount", notificationService.countUnreadByUserId(currentUser.getId()));
        response.put("notifications", notificationService.findRecentByUserId(currentUser.getId(), 5));
        return response;
    }

    @GetMapping("/notifications/unread-count")
    @ResponseBody
    public Map<String, Long> unreadCount(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        long count = currentUser != null ? notificationService.countUnreadByUserId(currentUser.getId()) : 0;
        return java.util.Collections.singletonMap("count", count);
    }

    @PostMapping("/notifications/{id}/read")
    public ModelAndView markAsRead(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }

        notificationService.markAsRead(id, currentUser.getId());
        return new ModelAndView("redirect:/notifications");
    }

    @PostMapping("/notifications/read-all")
    public ModelAndView markAllAsRead(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }

        notificationService.markAllAsRead(currentUser.getId());
        return new ModelAndView("redirect:/notifications");
    }
}
