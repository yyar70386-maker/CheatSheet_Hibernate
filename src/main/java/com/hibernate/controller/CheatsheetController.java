package com.hibernate.controller;

import java.io.InputStream;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.NotificationService;
import com.hibernate.service.TagService;
import com.hibernate.websocket.NotificationSocketService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/cheatsheet")
public class CheatsheetController {

    private final CheatsheetService cheatsheetService;
    private final CategoryService categoryService;
    private final TagService tagService;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;
    private final NotificationSocketService notificationSocketService;

    // ==================== 🌟 My Cheatsheets Personal List ====================
    @GetMapping("/list")
    public ModelAndView list(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }
        
        List<CheatsheetEntity> mySheets = cheatsheetService.findByUserId(currentUser.getId());
        return new ModelAndView("mycheatsheet", "cheatsheetlist", mySheets);
    }

    @GetMapping("/add")
    public ModelAndView addForm(HttpSession session) {
        if (session.getAttribute("currentUser") == null) {
            return new ModelAndView("redirect:/login");
        }

        ModelAndView mv = new ModelAndView("cheatsheet", "cheatsheet", new CheatsheetEntity());
        mv.addObject("categorylist", categoryService.findAll());
        return mv;
    }

    @PostMapping("/save")
    public ModelAndView save(
            @ModelAttribute("cheatsheet") CheatsheetEntity cheatsheet,
            @RequestParam(value = "tagIds", required = false) List<Integer> tagIds,
            HttpServletRequest request,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }

        cheatsheet.setAuthor(currentUser);

        if (tagIds != null) {
            List<TagEntity> tags = tagService.findByIds(tagIds);
            cheatsheet.setTags(tags);
        }

        Integer id = cheatsheetService.save(cheatsheet);
        auditLogService.log(currentUser, "Create Cheatsheet", "Cheatsheet", id,
                "Created cheatsheet: " + cheatsheet.getTitle(), request.getRemoteAddr());
                
        if ("PUBLIC".equalsIgnoreCase(cheatsheet.getVisibility())) {
            List<NotificationDto> notifications = notificationService.createCheatsheetNotificationsForFollowers(
                    currentUser.getId(), id, cheatsheet.getTitle());
            notificationSocketService.broadcastNotifications(notifications);
        }
        return new ModelAndView("redirect:/cheatsheet/list");
    }

    @GetMapping("/edit/{id}")
    public ModelAndView edit(@PathVariable Integer id) {
        CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
        if (cheatsheet == null) {
            return new ModelAndView("redirect:/cheatsheet/list");
        }
        
        ModelAndView mv = new ModelAndView("cheatsheet-edit", "cheatsheet", cheatsheet);
        mv.addObject("categorylist", categoryService.findAll());

        if (cheatsheet.getCategory() != null) {
            mv.addObject("taglist", tagService.findByCategoryId(cheatsheet.getCategory().getId()));
        }
        return mv;
    }

    @PostMapping("/update")
    public ModelAndView update(
            @ModelAttribute("cheatsheet") CheatsheetEntity cheatsheet,
            @RequestParam(value = "tagIds", required = false) List<Integer> tagIds,
            HttpServletRequest request,
            HttpSession session) {

        CheatsheetEntity existingSheet = cheatsheetService.findById(cheatsheet.getId());
        if (existingSheet != null) {
            cheatsheet.setAuthor(existingSheet.getAuthor());
            if (cheatsheet.getViewCount() == null) {
                cheatsheet.setViewCount(existingSheet.getViewCount());
            }
        }

        if (tagIds != null) {
            cheatsheet.setTags(tagService.findByIds(tagIds));
        }

        cheatsheetService.update(cheatsheet);
        auditLogService.log((User) session.getAttribute("currentUser"), "Update Cheatsheet", "Cheatsheet", cheatsheet.getId(),
                "Updated cheatsheet: " + cheatsheet.getTitle(), request.getRemoteAddr());
        return new ModelAndView("redirect:/cheatsheet/list");
    }

    @GetMapping("/delete/{id}")
    public ModelAndView delete(@PathVariable Integer id, HttpServletRequest request, HttpSession session) {
        cheatsheetService.delete(id);
        auditLogService.log((User) session.getAttribute("currentUser"), "Delete Cheatsheet", "Cheatsheet", id,
                "Cheatsheet deactivated.", request.getRemoteAddr());
        return new ModelAndView("redirect:/cheatsheet/list");
    }

    @GetMapping("/tags-by-category/{categoryId}")
    @ResponseBody
    public String tagsByCategory(@PathVariable Integer categoryId) {
        List<TagEntity> tags = tagService.findByCategoryId(categoryId);
        if (tags == null) return "";
        
        StringBuilder html = new StringBuilder();
        for (TagEntity tag : tags) {
            if (tag != null) {
                html.append("<label class='tag-box'>");
                html.append("<input type='checkbox' name='tagIds' value='").append(tag.getId()).append("'> ");
                html.append(tag.getName());
                html.append("</label>");
            }
        }
        return html.toString();
    }

    @GetMapping("/category/{categoryId}")
    public ModelAndView browseByCategory(
            @PathVariable("categoryId") Integer categoryId, 
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "filter", defaultValue = "ALL") String filter, 
            HttpSession session) {
            
        int pageSize = 3;
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        List<CheatsheetEntity> cheatsheets = cheatsheetService.findByCategoryIdWithPagination(categoryId, page, pageSize, currentUserId, filter);
        long totalCheatsheets = cheatsheetService.countByCategoryId(categoryId, currentUserId, filter); 
        
        int totalPages = (int) Math.ceil((double) totalCheatsheets / pageSize);
        if (totalPages == 0) totalPages = 1;
        
        List<TagEntity> categoryTags = cheatsheetService.findTagsByCategoryId(categoryId, currentUserId);
        var currentCategory = categoryService.findById(categoryId);
        String categoryName = (currentCategory != null) ? currentCategory.getName() : "Unknown";
        
        ModelAndView mv = new ModelAndView("cheatsheet-browse");
        mv.addObject("cheatsheetlist", cheatsheets); 
        mv.addObject("taglist", categoryTags);
        mv.addObject("currentPage", page); 
        mv.addObject("totalPages", totalPages);
        mv.addObject("categoryId", categoryId); 
        mv.addObject("categoryName", categoryName);
        mv.addObject("totalCount", totalCheatsheets); 
        mv.addObject("currentFilter", filter.toUpperCase()); 
        
        return mv;
    }

    // ==================== 🌟 Cheatsheet Detail View (With Smart View Count Logic) ====================
    @GetMapping("/detail/{id}")
    public ModelAndView viewDetail(@PathVariable("id") Integer id, HttpSession session) {
        CheatsheetEntity sheet = cheatsheetService.findById(id);
        if (sheet == null || !"active".equals(sheet.getStatus())) {
            return new ModelAndView("redirect:/error/404"); 
        }

        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        Integer authorId = (sheet.getAuthor() != null) ? sheet.getAuthor().getId() : -1;

        boolean isPrivate = "PRIVATE".equalsIgnoreCase(sheet.getVisibility());
        boolean isOwner = currentUserId.equals(authorId);

        if (!isPrivate && !isOwner) {
            int currentViews = (sheet.getViewCount() != null) ? sheet.getViewCount() : 0;
            sheet.setViewCount(currentViews + 1);
            cheatsheetService.update(sheet); 
        }

        ModelAndView mv = new ModelAndView("cheatsheet-detail");
        mv.addObject("sheet", sheet);
        mv.addObject("isOwner", isOwner); 
        return mv;
    }

    @GetMapping("/tag/{tagId}")
    public ModelAndView browseByTag(
            @PathVariable("tagId") Integer tagId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "filter", defaultValue = "ALL") String filter,
            HttpSession session) {
            
        int pageSize = 3; 
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        List<CheatsheetEntity> cheatsheets = cheatsheetService.findPublicCheatsheetsByTagId(tagId, page, pageSize, currentUserId, filter);
        long totalCheatsheets = cheatsheetService.countByTagId(tagId, currentUserId, filter);
        
        int totalPages = (int) Math.ceil((double) totalCheatsheets / pageSize);
        if (totalPages == 0) totalPages = 1;
        
        var tagObj = tagService.findById(tagId); 
        String tagName = (tagObj != null) ? tagObj.getName() : "Unknown";
        
        ModelAndView mv = new ModelAndView("cheatsheet-tag-list");
        mv.addObject("cheatsheetlist", cheatsheets);
        mv.addObject("tagName", tagName);
        mv.addObject("totalCount", totalCheatsheets);
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", totalPages);
        mv.addObject("tagId", tagId);
        mv.addObject("currentFilter", filter.toUpperCase());
        
        return mv;
    }
    
 // ==================== 🌟 [.JASPER HARD-FIXED] View PDF Report System ====================
    @GetMapping("/view-pdf/{id}")
    public void viewPdf(@PathVariable("id") Integer id, HttpServletResponse response, HttpSession session) {
        try {
            // ၁။ DB မှ Cheatsheet ဒေတာဆွဲထုတ်ခြင်း
            CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
            if (cheatsheet == null) {
                response.sendRedirect(response.encodeRedirectURL("/cheatsheet/list"));
                return;
            }

            // Download Count တိုးခြင်း
            int currentDownloads = (cheatsheet.getDownloadCount() != null) ? cheatsheet.getDownloadCount() : 0;
            cheatsheet.setDownloadCount(currentDownloads + 1);
            cheatsheetService.update(cheatsheet);
            
            // ၂။ .jasper ဖိုင်ကို တိုက်ရိုက်ဖတ်ယူခြင်း
            InputStream reportStream = this.getClass().getResourceAsStream("/reports/cheatsheet_template.jasper");
            if (reportStream == null) {
                throw new java.io.FileNotFoundException("Jasper compiled (.jasper) file not found in resources folder!");
            }
            
            // ၃။ DataSource ပြင်ဆင်ခြင်း
            List<CheatsheetEntity> dataList = java.util.Collections.singletonList(cheatsheet);
            net.sf.jasperreports.engine.data.JRBeanCollectionDataSource dataSource = 
                    new net.sf.jasperreports.engine.data.JRBeanCollectionDataSource(dataList);

            // ၄။ User Param Mapping ပြုလုပ်ခြင်း
            Map<String, Object> parameters = new HashMap<>();
            User currentUser = (User) session.getAttribute("currentUser");
            String username = "Guest User";
            if (currentUser != null && currentUser.getUsername() != null) {
                username = currentUser.getUsername();
            }
            parameters.put("DownloadedBy", username); 
            
            // ၅။ .jasper stream ကို တိုက်ရိုက် Fill လုပ်ခြင်း (ignore.missing.font properties က နောက်ကွယ်မှ ကာကွယ်ပေးထားပါသည်)
            net.sf.jasperreports.engine.JasperPrint jasperPrint = 
                    net.sf.jasperreports.engine.JasperFillManager.fillReport(reportStream, parameters, dataSource);
            
            // ၆။ PDF ဒေတာအား byte array အဖြစ် ပြောင်းလဲခြင်း
            byte[] pdfBytes = net.sf.jasperreports.engine.JasperExportManager.exportReportToPdf(jasperPrint);
            
            // ၇။ HTTP Response Header သတ်မှတ်ခြင်း
            response.setContentType("application/pdf");
            String filename = (cheatsheet.getTitle() != null) ? cheatsheet.getTitle() : "cheatsheet";
            
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".pdf\"");
            response.setContentLength(pdfBytes.length);

            // ၈။ Binary Data အား Output Stream ဆီသို့ တွန်းထုတ်ပြီး ပိတ်သိမ်းခြင်း
            java.io.OutputStream out = response.getOutputStream();
            out.write(pdfBytes);
            out.flush();
            out.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (!response.isCommitted()) {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Jasper rendering error: " + e.getMessage());
                }
            } catch (java.io.IOException ioe) {
                ioe.printStackTrace();
            }
        }
    }
}