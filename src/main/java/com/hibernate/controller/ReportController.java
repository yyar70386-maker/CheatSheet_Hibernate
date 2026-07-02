package com.hibernate.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hibernate.entity.ReportEntity;
import com.hibernate.entity.User;
import com.hibernate.service.ReportService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/admin/reports")
    public String list(
            @RequestParam(value = "q", defaultValue = "") String keyword,
            @RequestParam(value = "status", defaultValue = "") String status,
            @RequestParam(value = "targetType", defaultValue = "") String targetType,
            @RequestParam(value = "page", defaultValue = "1") int page,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        int pageSize = 15;
        long total = reportService.countSearch(keyword, status, targetType);
        model.addAttribute("reports", reportService.search(keyword, status, targetType, page, pageSize));
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("targetType", targetType);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));
        return "report-list";
    }

    @GetMapping("/admin/reports/{id}")
    public String detail(@PathVariable Integer id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        model.addAttribute("report", reportService.findById(id));
        return "report-detail";
    }

    @PostMapping("/admin/reports/{id}/status/{status}")
    public String updateStatus(@PathVariable Integer id, @PathVariable String status, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        reportService.updateStatus(id, status, currentUser);
        return "redirect:/admin/reports";
    }

    @PostMapping("/admin/reports/{id}/delete")
    public String delete(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        reportService.delete(id, currentUser);
        return "redirect:/admin/reports";
    }

    @PostMapping("/reports/create")
    public String create(
            @RequestParam("targetType") String targetType,
            @RequestParam("targetId") Integer targetId,
            @RequestParam("reason") String reason,
            @RequestParam(value = "description", defaultValue = "") String description,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        ReportEntity report = new ReportEntity();
        report.setTargetType(targetType);
        report.setTargetId(targetId);
        if ("CHEATSHEET".equalsIgnoreCase(targetType)) {
            report.setSheetId(targetId);
        }
        report.setReason(reason);
        report.setDescription(description);
        reportService.create(report, currentUser.getId());
        redirectAttributes.addFlashAttribute("message", "Report submitted successfully.");
        return "redirect:/home";
    }
}
