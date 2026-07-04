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
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.CategoryService;
import com.hibernate.websocket.NotificationSocketService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminCheatsheetController {

    private final CheatsheetService cheatsheetService;
    private final CategoryService categoryService;
    private final NotificationSocketService notificationSocketService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/admin/cheatsheets")
    public String list(
            @RequestParam(value = "q", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "categoryId", required = false, defaultValue = "") String categoryId,
            @RequestParam(value = "status", required = false, defaultValue = "") String status,
            @RequestParam(value = "banned", required = false, defaultValue = "") String banned,
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }

        int pageSize = 10;
        model.addAttribute("cheatsheets", cheatsheetService.searchAll(keyword, categoryId, status, banned, page, pageSize));
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("status", status);
        model.addAttribute("banned", banned);
        model.addAttribute("currentPage", page);
        model.addAttribute("categories", categoryService.findAll());

        long total = cheatsheetService.countSearchAll(keyword, categoryId, status, banned);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));

        return "admin-cheatsheets";
    }

    @PostMapping("/admin/cheatsheets/{id}/ban")
    public String ban(@PathVariable Integer id, @RequestParam("reason") String reason, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        if (reason == null || reason.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMsg", "Ban reason is required!");
            return "redirect:/admin/cheatsheets";
        }
        NotificationDto notification = cheatsheetService.banCheatsheet(id, reason, currentUser, request.getRemoteAddr());
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
        redirectAttributes.addFlashAttribute("successMsg", "CheatSheet banned successfully.");
        return "redirect:/admin/cheatsheets";
    }

    @PostMapping("/admin/cheatsheets/{id}/restore")
    public String restore(@PathVariable Integer id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        NotificationDto notification = cheatsheetService.restoreCheatsheet(id, currentUser, request.getRemoteAddr());
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
        redirectAttributes.addFlashAttribute("successMsg", "CheatSheet restored successfully.");
        return "redirect:/admin/cheatsheets";
    }

    @PostMapping("/admin/cheatsheets/{id}/approve")
    public String approve(@PathVariable Integer id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        NotificationDto notification = cheatsheetService.approveCheatsheet(id, currentUser, request.getRemoteAddr());
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
        redirectAttributes.addFlashAttribute("successMsg", "CheatSheet approved successfully.");
        return "redirect:/admin/cheatsheets";
    }

    @PostMapping("/admin/cheatsheets/{id}/reject")
    public String reject(@PathVariable Integer id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        NotificationDto notification = cheatsheetService.rejectCheatsheet(id, currentUser, request.getRemoteAddr());
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
        redirectAttributes.addFlashAttribute("successMsg", "CheatSheet rejected successfully.");
        return "redirect:/admin/cheatsheets";
    }

    @PostMapping("/admin/cheatsheets/{id}/delete")
    public String delete(@PathVariable Integer id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        cheatsheetService.delete(id);
        redirectAttributes.addFlashAttribute("successMsg", "CheatSheet deleted successfully.");
        return "redirect:/admin/cheatsheets";
    }
}
