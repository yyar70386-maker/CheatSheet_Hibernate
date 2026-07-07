package com.hibernate.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.User;
import com.hibernate.service.NotificationService;
import com.hibernate.websocket.NotificationSocketService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;
    private final NotificationSocketService notificationSocketService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/notifications")
    public String list(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("notifications", notificationService.findByUserId(currentUser.getId()));
        return "notifications";
    }

    @GetMapping(value = "/notifications/recent", produces = "application/json")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRecentNotifications(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        long unread = notificationService.countUnreadByUserId(currentUser.getId());
        List<NotificationDto> list = notificationService.findByUserId(currentUser.getId());

        Map<String, Object> response = new HashMap<>();
        // 🟢 ဤနေရာရှိ Key Name သည် ဂျာဗားစခရစ်ထဲက ဒေတာနှင့် ကွက်တိတူရပါမည်
        response.put("unreadCount", unread); 
        response.put("notifications", list);

        return ResponseEntity.ok(response);
    }

    @GetMapping("/notifications/unread-count")
    @ResponseBody
    public Map<String, Long> unreadCount(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        long count = currentUser != null ? notificationService.countUnreadByUserId(currentUser.getId()) : 0;
        return java.util.Collections.singletonMap("count", count);
    }

    @PostMapping("/notifications/{id}/read")
    public ModelAndView markAsRead(
            @PathVariable Integer id,
            @RequestParam(value = "redirect", required = false) String redirectUrl,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }

        notificationService.markAsRead(id, currentUser.getId());
        String targetRedirect = (redirectUrl != null && !redirectUrl.isEmpty()) ? redirectUrl : "/notifications";
        return new ModelAndView("redirect:" + targetRedirect);
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

    @PostMapping("/notifications/{id}/delete")
    public ModelAndView delete(
            @PathVariable Integer id,
            @RequestParam(value = "redirect", required = false) String redirectUrl,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }
        notificationService.delete(id, currentUser.getId());
        String targetRedirect = (redirectUrl != null && !redirectUrl.isEmpty()) ? redirectUrl : "/notifications";
        return new ModelAndView("redirect:" + targetRedirect);
    }

    @GetMapping("/admin/notifications")
    public String adminForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        return "admin-notifications";
    }

    @PostMapping("/admin/notifications/send")
    public String send(
            @RequestParam(value = "userId", required = false) Integer userId,
            @RequestParam("title") String title,
            @RequestParam("message") String message,
            HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        if (userId == null) {
            java.util.List<NotificationDto> notifications = notificationService.broadcast(
                    currentUser.getId(), title, message, "ADMIN", "/notifications");
            notificationSocketService.broadcastNotifications(notifications);
        } else {
            NotificationDto notification = notificationService.createNotification(
                    userId, currentUser.getId(), title, message, "ADMIN", "/notifications");
            notificationSocketService.broadcastToUser(userId, notification);
        }
        return "redirect:/admin/notifications";
    }
}
