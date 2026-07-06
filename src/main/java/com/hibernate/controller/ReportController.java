package com.hibernate.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.ReportEntity;
import com.hibernate.entity.User;
import com.hibernate.service.ReportService;
import com.hibernate.websocket.NotificationSocketService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;
    private final NotificationSocketService notificationSocketService;
    private final com.hibernate.service.CheatsheetService cheatsheetService;
    private final com.hibernate.repository.UserRepository userRepository;
    private final com.hibernate.service.CommentServiceImpl commentService;

    public static class ReportDisplay {
        private final ReportEntity report;
        private final String reportedUsername;
        private final String targetTitle;
        private final String targetUrl;

        public ReportDisplay(ReportEntity report, String reportedUsername, String targetTitle, String targetUrl) {
            this.report = report;
            this.reportedUsername = reportedUsername;
            this.targetTitle = targetTitle;
            this.targetUrl = targetUrl;
        }

        public ReportEntity getReport() { return report; }
        public String getReportedUsername() { return reportedUsername; }
        public String getTargetTitle() { return targetTitle; }
        public String getTargetUrl() { return targetUrl; }
    }

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
        
        java.util.List<ReportEntity> reports = reportService.search(keyword, status, targetType, page, pageSize);
        java.util.List<ReportDisplay> displayList = new java.util.ArrayList<>();
        for (ReportEntity r : reports) {
            String reportedUsername = "Unknown";
            String targetTitle = "N/A";
            String targetUrl = "#";
            
            if ("CHEATSHEET".equalsIgnoreCase(r.getTargetType())) {
                if (r.getTargetId() != null) {
                    com.hibernate.entity.CheatsheetEntity sheet = cheatsheetService.findById(r.getTargetId());
                    if (sheet != null) {
                        reportedUsername = (sheet.getAuthor() != null) ? sheet.getAuthor().getUsername() : "Unknown";
                        targetTitle = sheet.getTitle();
                        targetUrl = "/cheatsheet/detail/" + sheet.getObfuscatedId();
                    }
                }
            } else if ("COMMENT".equalsIgnoreCase(r.getTargetType())) {
                if (r.getTargetId() != null) {
                    com.hibernate.entity.CommentEntity comment = commentService.getCommentById(r.getTargetId());
                    if (comment != null) {
                        reportedUsername = (comment.getUser() != null) ? comment.getUser().getUsername() : "Unknown";
                        targetTitle = comment.getContent();
                        if (comment.getCheatSheet() != null) {
                            targetUrl = "/cheatsheet/detail/" + comment.getCheatSheet().getObfuscatedId();
                        }
                    }
                }
            } else if ("USER".equalsIgnoreCase(r.getTargetType())) {
                if (r.getTargetId() != null) {
                    User targetUser = userRepository.findById(r.getTargetId());
                    if (targetUser != null) {
                        reportedUsername = targetUser.getUsername();
                        targetTitle = targetUser.getFullName();
                        targetUrl = "/profile/" + targetUser.getObfuscatedId();
                    }
                }
            }
            displayList.add(new ReportDisplay(r, reportedUsername, targetTitle, targetUrl));
        }
        
        model.addAttribute("reports", displayList);
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
        ReportEntity report = reportService.findById(id);
        if (report != null) {
            String reportedUsername = "Unknown";
            String targetTitle = "N/A";
            String targetUrl = "#";
            
            if ("CHEATSHEET".equalsIgnoreCase(report.getTargetType())) {
                if (report.getTargetId() != null) {
                    com.hibernate.entity.CheatsheetEntity sheet = cheatsheetService.findById(report.getTargetId());
                    if (sheet != null) {
                        reportedUsername = (sheet.getAuthor() != null) ? sheet.getAuthor().getUsername() : "Unknown";
                        targetTitle = sheet.getTitle();
                        targetUrl = "/cheatsheet/detail/" + sheet.getObfuscatedId();
                    }
                }
            } else if ("COMMENT".equalsIgnoreCase(report.getTargetType())) {
                if (report.getTargetId() != null) {
                    com.hibernate.entity.CommentEntity comment = commentService.getCommentById(report.getTargetId());
                    if (comment != null) {
                        reportedUsername = (comment.getUser() != null) ? comment.getUser().getUsername() : "Unknown";
                        targetTitle = comment.getContent();
                        if (comment.getCheatSheet() != null) {
                            targetUrl = "/cheatsheet/detail/" + comment.getCheatSheet().getObfuscatedId();
                        }
                    }
                }
            } else if ("USER".equalsIgnoreCase(report.getTargetType())) {
                if (report.getTargetId() != null) {
                    User targetUser = userRepository.findById(report.getTargetId());
                    if (targetUser != null) {
                        reportedUsername = targetUser.getUsername();
                        targetTitle = targetUser.getFullName();
                        targetUrl = "/profile/" + targetUser.getObfuscatedId();
                    }
                }
            }
            model.addAttribute("report", report);
            model.addAttribute("reportedUsername", reportedUsername);
            model.addAttribute("targetTitle", targetTitle);
            model.addAttribute("targetUrl", targetUrl);
        }
        return "report-detail";
    }

    @PostMapping("/admin/reports/{id}/status/{status}")
    public String updateStatus(@PathVariable Integer id, @PathVariable String status, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        NotificationDto notification = reportService.updateStatus(id, status, currentUser);
        if (notification != null && notification.getUserId() != null) {
            notificationSocketService.broadcastToUser(notification.getUserId(), notification);
        }
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
        if ("CHEATSHEET".equalsIgnoreCase(targetType)) {
            String encodedId = com.hibernate.util.IdObfuscator.encode(targetId);
            return "redirect:/cheatsheet/detail/" + encodedId;
        }
        return "redirect:/home";
    }
}
