package com.hibernate.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

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
    public String list(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        model.addAttribute("logs", auditLogService.findRecent(50));
        return "audit-log-list";
    }
}
