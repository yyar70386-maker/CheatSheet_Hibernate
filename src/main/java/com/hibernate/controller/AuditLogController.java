package com.hibernate.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.hibernate.entity.User;
import com.hibernate.service.AuditLogService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AuditLogController {

    private final AuditLogService auditLogService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/admin/audit-logs")
    public String list(
            @RequestParam(value = "q", defaultValue = "") String keyword,
            @RequestParam(value = "entityType", defaultValue = "") String entityType,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        int pageSize = 15;
        long total = auditLogService.countSearch(keyword, entityType);
        model.addAttribute("logs", auditLogService.search(keyword, entityType, page, pageSize));
        model.addAttribute("keyword", keyword);
        model.addAttribute("entityType", entityType);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));
        return "audit-log-list";
    }

    @GetMapping("/admin/audit-logs/{id}")
    public String detail(@PathVariable Integer id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        model.addAttribute("log", auditLogService.findById(id));
        return "audit-log-detail";
    }
}
