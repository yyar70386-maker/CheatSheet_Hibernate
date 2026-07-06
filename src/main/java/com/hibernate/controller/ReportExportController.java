package com.hibernate.controller;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
import net.sf.jasperreports.export.SimpleXlsxReportConfiguration;

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
    public String cheatsheetReportPage(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }

        List<CheatSheetReportEntity> reportData = cheatsheetService.getCheatsheetReportData(startDate, endDate);

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
    public void exportPdf(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            HttpServletResponse response, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (!isAdmin(currentUser)) {
                response.sendRedirect("/login");
                return;
            }

            List<CheatSheetReportEntity> reportData = cheatsheetService.getCheatsheetReportData(startDate, endDate);
            for (int i = 0; i < reportData.size(); i++) {
                reportData.get(i).setNo(i + 1);
            }

            // WEB-INF/reports/ လမ်းကြောင်းအတိုင်း စိတ်ချရစွာ ပြန်လည်ဖတ်ရှုခြင်း
            String jrxmlPath = session.getServletContext().getRealPath("/WEB-INF/reports/CheatSheetReport.jrxml");
            java.io.File jrxmlFile = new java.io.File(jrxmlPath);
            if (!jrxmlFile.exists()) {
                throw new RuntimeException("JRXML file not found at: " + jrxmlPath);
            }
            InputStream inputStream = new java.io.FileInputStream(jrxmlFile);

            JasperReport jasperReport = JasperCompileManager.compileReport(inputStream);

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("ReportTitle", "CheatSheet Report");
            parameters.put("GeneratedAt", LocalDateTime.now().toString());

            JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(reportData);
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);

            // Headers ကို အပေါ်မှာ ကြိုတင်သတ်မှတ်ပါတယ်
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"cheatsheet-report.pdf\"");
            
            java.io.OutputStream outputStream = response.getOutputStream();
            JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);

            outputStream.flush();
            outputStream.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Generate and stream the CheatSheet Report as Excel (XLSX).
     */
    @GetMapping("/admin/reports/cheatsheet/excel")
    public void exportExcel(
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            HttpServletResponse response, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (!isAdmin(currentUser)) {
                response.sendRedirect("/login");
                return;
            }

            List<CheatSheetReportEntity> reportData = cheatsheetService.getCheatsheetReportData(startDate, endDate);
            for (int i = 0; i < reportData.size(); i++) {
                reportData.get(i).setNo(i + 1);
            }

            // WEB-INF/reports/ လမ်းကြောင်းအတိုင်း ဖတ်ရှုခြင်း
            String jrxmlPath = session.getServletContext().getRealPath("/WEB-INF/reports/CheatSheetReport.jrxml");
            java.io.File jrxmlFile = new java.io.File(jrxmlPath);
            if (!jrxmlFile.exists()) {
                throw new RuntimeException("JRXML file not found at: " + jrxmlPath);
            }
            InputStream inputStream = new java.io.FileInputStream(jrxmlFile);

            JasperReport jasperReport = JasperCompileManager.compileReport(inputStream);

            Map<String, Object> parameters = new HashMap<>();
            parameters.put("ReportTitle", "CheatSheet Report");
            parameters.put("GeneratedAt", LocalDateTime.now().toString());

            JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(reportData);
            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);

            // Headers ကို အပေါ်မှာ ကြိုတင်သတ်မှတ်ပါတယ်
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"cheatsheet-report.xlsx\"");

            java.io.OutputStream outputStream = response.getOutputStream();
            
            // Excel ပုံစံ ကောင်းမွန်စေရန် configuration များ ထည့်သွင်းခြင်း
            JRXlsxExporter exporter = new JRXlsxExporter();
            exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
            exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(outputStream));
            
            SimpleXlsxReportConfiguration configuration = new SimpleXlsxReportConfiguration();
            configuration.setOnePagePerSheet(false);
            configuration.setRemoveEmptySpaceBetweenRows(true);
            configuration.setRemoveEmptySpaceBetweenColumns(true);
            configuration.setWhitePageBackground(false);
            configuration.setDetectCellType(true);
            configuration.setIgnoreGraphics(true);
            
            exporter.setConfiguration(configuration);
            exporter.exportReport();

            outputStream.flush();
            outputStream.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}