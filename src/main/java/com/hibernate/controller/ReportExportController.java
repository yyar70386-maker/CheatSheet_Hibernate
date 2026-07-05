package com.hibernate.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.hibernate.entity.CheatSheetReportEntity;
import com.hibernate.entity.User;
import com.hibernate.service.CheatsheetService;

import lombok.RequiredArgsConstructor;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import net.sf.jasperreports.export.SimpleExporterInput;
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput;

@Controller
@RequiredArgsConstructor
public class ReportExportController {

    private final CheatsheetService cheatsheetService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    /**
     * Display the CheatSheet Report page with PDF and Excel export options.
     */
    @GetMapping("/admin/reports/cheatsheet")
    public String cheatsheetReportPage(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }

        List<CheatSheetReportEntity> reportData = cheatsheetService.getCheatsheetReportData();

        // Assign row numbers
        for (int i = 0; i < reportData.size(); i++) {
            reportData.get(i).setNo(i + 1);
        }

        model.addAttribute("reportData", reportData);
        model.addAttribute("totalRecords", reportData.size());

        return "cheatsheet-report";
    }

    /**
     * Generate and stream the CheatSheet Report as PDF.
     */
    @GetMapping("/admin/reports/cheatsheet/pdf")
    public void exportPdf(HttpServletResponse response, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (!isAdmin(currentUser)) {
                response.sendRedirect("/login");
                return;
            }

            List<CheatSheetReportEntity> reportData = cheatsheetService.getCheatsheetReportData();
            for (int i = 0; i < reportData.size(); i++) {
                reportData.get(i).setNo(i + 1);
            }

            // Load .jrxml from WEB-INF/reports/
            String jrxmlPath = session.getServletContext().getRealPath("/WEB-INF/reports/CheatSheetReport.jrxml");
            File jrxmlFile = new File(jrxmlPath);

            JasperReport jasperReport = JasperCompileManager.compileReport(jrxmlFile.getAbsolutePath());

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("ReportTitle", "CheatSheet Report");
            parameters.put("GeneratedAt", LocalDateTime.now().toString());

            JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(reportData);
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"cheatsheet-report.pdf\"");
            JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Generate and stream the CheatSheet Report as Excel (XLSX).
     */
    @GetMapping("/admin/reports/cheatsheet/excel")
    public void exportExcel(HttpServletResponse response, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (!isAdmin(currentUser)) {
                response.sendRedirect("/login");
                return;
            }

            List<CheatSheetReportEntity> reportData = cheatsheetService.getCheatsheetReportData();
            for (int i = 0; i < reportData.size(); i++) {
                reportData.get(i).setNo(i + 1);
            }

            // Load .jrxml from WEB-INF/reports/
            String jrxmlPath = session.getServletContext().getRealPath("/WEB-INF/reports/CheatSheetReport.jrxml");
            File jrxmlFile = new File(jrxmlPath);

            JasperReport jasperReport = JasperCompileManager.compileReport(jrxmlFile.getAbsolutePath());

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("ReportTitle", "CheatSheet Report");
            parameters.put("GeneratedAt", LocalDateTime.now().toString());

            JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(reportData);
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);

            // Export to XLSX
            JRXlsxExporter exporter = new JRXlsxExporter();
            exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
            exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(response.getOutputStream()));

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"cheatsheet-report.xlsx\"");
            exporter.exportReport();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
