package com.hibernate.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.service.CommentServiceImpl;
import com.hibernate.websocket.NotificationSocketService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminCommentController {

    private final CommentServiceImpl commentService;
    private final NotificationSocketService notificationSocketService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/admin/comments")
    public String list(
            @RequestParam(value = "q", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "status", required = false, defaultValue = "") String status,
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }

        int pageSize = 10;
        model.addAttribute("comments", commentService.searchComments(keyword, status, page, pageSize));
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("currentPage", page);

        long total = commentService.countSearchComments(keyword, status);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));

        return "admin-comments";
    }

    @PostMapping("/admin/comments/{id}/ban")
    public String ban(@PathVariable Integer id, @RequestParam("reason") String reason, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        if (reason == null || reason.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMsg", "Ban reason is required!");
            return "redirect:/admin/comments";
        }
        NotificationDto notification = commentService.banComment(id, reason, currentUser, request.getRemoteAddr());
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
        redirectAttributes.addFlashAttribute("successMsg", "Comment banned successfully.");
        return "redirect:/admin/comments";
    }

    @PostMapping("/admin/comments/{id}/restore")
    public String restore(@PathVariable Integer id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        NotificationDto notification = commentService.restoreComment(id, currentUser, request.getRemoteAddr());
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
        redirectAttributes.addFlashAttribute("successMsg", "Comment restored successfully.");
        return "redirect:/admin/comments";
    }

    @PostMapping("/admin/comments/{id}/delete")
    public String delete(@PathVariable Integer id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        commentService.deleteComment(id, currentUser, request.getRemoteAddr());
        redirectAttributes.addFlashAttribute("successMsg", "Comment deleted successfully.");
        return "redirect:/admin/comments";
    }
}
