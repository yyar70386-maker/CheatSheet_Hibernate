package com.hibernate.controller;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
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
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.dto.NotificationDto;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.CategoryService;
import com.hibernate.websocket.NotificationSocketService;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import net.sf.jasperreports.engine.design.JRDesignBand;
import net.sf.jasperreports.engine.design.JRDesignExpression;
import net.sf.jasperreports.engine.design.JRDesignField;
import net.sf.jasperreports.engine.design.JRDesignSection;
import net.sf.jasperreports.engine.design.JRDesignStaticText;
import net.sf.jasperreports.engine.design.JRDesignTextField;
import net.sf.jasperreports.engine.design.JasperDesign;

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

    private boolean isUserSubmitted(CheatsheetEntity sheet) {
        return sheet != null && sheet.getAuthor() != null && sheet.getAuthor().getRole() != 1;
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
        CheatsheetEntity sheet = cheatsheetService.findById(id);
        if (isUserSubmitted(sheet)) {
            redirectAttributes.addFlashAttribute("errorMsg", "User-created CheatSheets cannot be deleted by admins. Use Ban/Restore instead.");
            return "redirect:/admin/cheatsheets";
        }
        cheatsheetService.delete(id);
        redirectAttributes.addFlashAttribute("successMsg", "CheatSheet deleted successfully.");
        return "redirect:/admin/cheatsheets";
    }

    @GetMapping("/admin/cheatsheets/reports/{period}")
    public void report(@PathVariable String period, HttpServletResponse response, HttpSession session) throws Exception {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            response.sendRedirect("../login");
            return;
        }

        LocalDate today = LocalDate.now();
        LocalDate startDate = "monthly".equalsIgnoreCase(period)
                ? today.withDayOfMonth(1)
                : today.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
        LocalDate endDate = "monthly".equalsIgnoreCase(period)
                ? startDate.plusMonths(1)
                : startDate.plusWeeks(1);

        List<CheatsheetEntity> sheets = cheatsheetService.findPublicCreatedBetween(
                Timestamp.valueOf(startDate.atStartOfDay()),
                Timestamp.valueOf(endDate.atStartOfDay()));

        List<Map<String, ?>> rows = new ArrayList<>();
        for (CheatsheetEntity sheet : sheets) {
            Map<String, Object> row = new HashMap<>();
            row.put("title", sheet.getTitle());
            row.put("author", sheet.getAuthor() != null ? sheet.getAuthor().getUsername() : "Unknown");
            row.put("category", sheet.getCategory() != null ? sheet.getCategory().getName() : "Uncategorized");
            row.put("views", sheet.getViewCount() != null ? sheet.getViewCount() : 0);
            row.put("createdAt", sheet.getCreatedAt() != null ? sheet.getCreatedAt().toString() : "");
            rows.add(row);
        }

        JasperDesign design = buildReportDesign("monthly".equalsIgnoreCase(period) ? "Monthly CheatSheet Report" : "Weekly CheatSheet Report");
        JasperReport jasperReport = JasperCompileManager.compileReport(design);
        Map<String, Object> parameters = new HashMap<>();
        parameters.put("ReportRange", startDate + " to " + endDate.minusDays(1));
        parameters.put("GeneratedAt", LocalDateTime.now().toString());
        JasperPrint print = JasperFillManager.fillReport(jasperReport, parameters, new JRMapCollectionDataSource(rows));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=\"" + period.toLowerCase() + "-cheatsheet-report.pdf\"");
        JasperExportManager.exportReportToPdfStream(print, response.getOutputStream());
    }

    private JasperDesign buildReportDesign(String title) throws Exception {
        JasperDesign design = new JasperDesign();
        design.setName("cheatsheet_report");
        design.setPageWidth(595);
        design.setPageHeight(842);
        design.setColumnWidth(515);
        design.setLeftMargin(40);
        design.setRightMargin(40);
        design.setTopMargin(30);
        design.setBottomMargin(30);

        addField(design, "title", String.class);
        addField(design, "author", String.class);
        addField(design, "category", String.class);
        addField(design, "views", Integer.class);
        addField(design, "createdAt", String.class);

        JRDesignBand titleBand = new JRDesignBand();
        titleBand.setHeight(70);
        titleBand.addElement(staticText(title, 0, 0, 515, 28, 18, true));
        titleBand.addElement(textField("\"Range: \" + $P{ReportRange}", 0, 34, 320, 18));
        titleBand.addElement(textField("\"Generated: \" + $P{GeneratedAt}", 0, 52, 320, 18));
        design.setTitle(titleBand);

        JRDesignBand header = new JRDesignBand();
        header.setHeight(24);
        header.addElement(staticText("Title", 0, 0, 180, 20, 10, true));
        header.addElement(staticText("Author", 185, 0, 95, 20, 10, true));
        header.addElement(staticText("Category", 285, 0, 95, 20, 10, true));
        header.addElement(staticText("Views", 385, 0, 45, 20, 10, true));
        header.addElement(staticText("Created", 435, 0, 80, 20, 10, true));
        design.setColumnHeader(header);

        JRDesignBand detail = new JRDesignBand();
        detail.setHeight(24);
        detail.addElement(textField("$F{title}", 0, 0, 180, 20));
        detail.addElement(textField("$F{author}", 185, 0, 95, 20));
        detail.addElement(textField("$F{category}", 285, 0, 95, 20));
        detail.addElement(textField("$F{views}", 385, 0, 45, 20));
        detail.addElement(textField("$F{createdAt}", 435, 0, 80, 20));

        // Add the detail band to the report's detail section
        ((JRDesignSection) design.getDetailSection()).addBand(detail);

        return design;
    }

    private void addField(JasperDesign design, String name, Class<?> type) throws Exception {
        JRDesignField field = new JRDesignField();
        field.setName(name);
        field.setValueClass(type);
        design.addField(field);
    }

    private JRDesignStaticText staticText(String text, int x, int y, int width, int height, int fontSize, boolean bold) {
        JRDesignStaticText element = new JRDesignStaticText();
        element.setText(text);
        element.setX(x);
        element.setY(y);
        element.setWidth(width);
        element.setHeight(height);
        element.setFontSize((float) fontSize);
        element.setBold(bold);
        return element;
    }

    private JRDesignTextField textField(String expression, int x, int y, int width, int height) {
        JRDesignTextField element = new JRDesignTextField();
        element.setX(x);
        element.setY(y);
        element.setWidth(width);
        element.setHeight(height);
        element.setFontSize(9f);
        JRDesignExpression exp = new JRDesignExpression();
        exp.setText(expression);
        element.setExpression(exp);
        return element;
    }
}
