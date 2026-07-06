package com.hibernate.controller;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.hibernate.entity.AppealEntity;
import com.hibernate.service.AppealService;
import com.hibernate.entity.User;

@Controller
@RequestMapping("/appeals")
public class AppealController {

    @Autowired
    private AppealService appealService;

    @PostMapping("/submit")
    public String submitAppeal(@RequestParam("targetType") String targetType,
                               @RequestParam("targetId") Integer targetId,
                               @RequestParam("reason") String reason,
                               HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/login";
        }
        appealService.createAppeal(user.getId(), targetType, targetId, reason);
        return "redirect:/profile?appealSubmitted=true";
    }

    @GetMapping("/admin")
    public String viewAppeals(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || user.getRole() != 1) {
            return "redirect:/";
        }
        List<AppealEntity> appeals = appealService.getAllPendingAppeals();
        model.addAttribute("appeals", appeals);
        return "admin-appeals";
    }

    @PostMapping("/admin/resolve")
    public String resolveAppeal(@RequestParam("appealId") Integer appealId,
                                @RequestParam("status") String status,
                                HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null || user.getRole() != 1) {
            return "redirect:/";
        }
        appealService.resolveAppeal(appealId, status);
        return "redirect:/appeals/admin?resolved=true";
    }
}
