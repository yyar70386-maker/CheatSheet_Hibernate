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
import org.springframework.web.multipart.MultipartFile;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.FavoriteService;
import com.hibernate.service.InteractionServiceImpl;
import com.hibernate.service.NotificationService;
import com.hibernate.service.RatingService;
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
    private final FavoriteService favoriteService;
    private final InteractionServiceImpl interactionService;
    private final RatingService ratingService;

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
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
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

        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                String uploadDir = "C:/my_project_uploads/";
                java.io.File dir = new java.io.File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                String orgName = imageFile.getOriginalFilename();
                String ext = "";
                if (orgName != null && orgName.contains(".")) {
                    ext = orgName.substring(orgName.lastIndexOf("."));
                }
                String newName = java.util.UUID.randomUUID().toString() + ext;
                java.io.File dest = new java.io.File(dir, newName);
                imageFile.transferTo(dest);
                cheatsheet.setImagePath("/uploads/" + newName);
            } catch (Exception e) {
                e.printStackTrace();
            }
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
    public ModelAndView edit(@PathVariable("id") String encodedId) {
        Integer id = com.hibernate.util.IdObfuscator.decode(encodedId);
        if (id == null) {
            try {
                id = Integer.parseInt(encodedId);
            } catch (NumberFormatException e) {
                return new ModelAndView("redirect:/cheatsheet/list");
            }
        }
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
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            HttpServletRequest request,
            HttpSession session) {

        CheatsheetEntity existingSheet = cheatsheetService.findById(cheatsheet.getId());
        if (existingSheet != null) {
            cheatsheet.setAuthor(existingSheet.getAuthor());
            if (cheatsheet.getViewCount() == null) {
                cheatsheet.setViewCount(existingSheet.getViewCount());
            }
            if (imageFile != null && !imageFile.isEmpty()) {
                try {
                    String uploadDir = "C:/my_project_uploads/";
                    java.io.File dir = new java.io.File(uploadDir);
                    if (!dir.exists()) {
                        dir.mkdirs();
                    }
                    String orgName = imageFile.getOriginalFilename();
                    String ext = "";
                    if (orgName != null && orgName.contains(".")) {
                        ext = orgName.substring(orgName.lastIndexOf("."));
                    }
                    String newName = java.util.UUID.randomUUID().toString() + ext;
                    java.io.File dest = new java.io.File(dir, newName);
                    imageFile.transferTo(dest);
                    cheatsheet.setImagePath("/uploads/" + newName);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                cheatsheet.setImagePath(existingSheet.getImagePath());
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
    public ModelAndView delete(@PathVariable("id") String encodedId, HttpServletRequest request, HttpSession session) {
        Integer id = com.hibernate.util.IdObfuscator.decode(encodedId);
        if (id == null) {
            try {
                id = Integer.parseInt(encodedId);
            } catch (NumberFormatException e) {
                return new ModelAndView("redirect:/cheatsheet/list");
            }
        }
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
            @PathVariable("categoryId") String encodedCategoryId, 
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "filter", defaultValue = "ALL") String filter, 
            HttpSession session) {
            
        Integer categoryId = com.hibernate.util.IdObfuscator.decode(encodedCategoryId);
        if (categoryId == null) {
            try {
                categoryId = Integer.parseInt(encodedCategoryId);
            } catch (NumberFormatException e) {
                return new ModelAndView("redirect:/home");
            }
        }
            
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
        mv.addObject("categoryId", encodedCategoryId); 
        mv.addObject("categoryName", categoryName);
        mv.addObject("totalCount", totalCheatsheets); 
        mv.addObject("currentFilter", filter.toUpperCase()); 
        
        return mv;
    }

    // ==================== 🌟 Cheatsheet Detail View (Conflict ရှင်းပြီးသား ဗားရှင်း) ====================
    @GetMapping("/detail/{id}")
    public ModelAndView viewDetail(@PathVariable("id") String encodedId, HttpSession session) {
        Integer id = com.hibernate.util.IdObfuscator.decode(encodedId);
        if (id == null) {
            try {
                id = Integer.parseInt(encodedId);
            } catch (NumberFormatException e) {
                return new ModelAndView("redirect:/home");
            }
        }
        CheatsheetEntity sheet = cheatsheetService.findById(id);
        if (sheet == null || "inactive".equalsIgnoreCase(sheet.getStatus())) {
            return new ModelAndView("redirect:/error/404"); 
        }

        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        Integer authorId = (sheet.getAuthor() != null) ? sheet.getAuthor().getId() : -1;

        boolean isOwner = currentUserId.equals(authorId);
        if (!"active".equalsIgnoreCase(sheet.getStatus()) && !isOwner) {
            return new ModelAndView("redirect:/error/404");
        }

        boolean isPrivate = "PRIVATE".equalsIgnoreCase(sheet.getVisibility());

        if (!isPrivate && !isOwner) {
            int currentViews = (sheet.getViewCount() != null) ? sheet.getViewCount() : 0;
            sheet.setViewCount(currentViews + 1);
            cheatsheetService.update(sheet); 
        }

        ModelAndView mv = new ModelAndView("cheatsheet-detail");
        mv.addObject("sheet", sheet);
        
        // Interaction & Rating Data များကို View ထဲသို့ ထည့်ပေးခြင်း
        mv.addObject("avgRating", ratingService.getAverageRatingBySheetId(id));
        mv.addObject("sheetLikes", interactionService.countSheetReactions(id, true));
        mv.addObject("sheetDislikes", interactionService.countSheetReactions(id, false));
        mv.addObject("commentsList", interactionService.getCommentsBySheetId(id, currentUserId));
        
        if (currentUser != null) {
            var favorite = favoriteService.getByUserIdAndSheetId(currentUser.getId(), id);
            var userReaction = interactionService.getSheetReaction(currentUser.getId(), id);
            var userRatingEntity = ratingService.getByUserAndSheetId(currentUser.getId(), id);
            
            mv.addObject("isFavorited", favorite != null);
            mv.addObject("userSheetLike", userReaction != null ? userReaction.getIsLike() : null);
            mv.addObject("userRating", userRatingEntity != null ? userRatingEntity.getStars() : 0);
        }
        
        // UI ဘက်တွင် Edit/Delete ခလုတ်ပြရန်/ဖျောက်ရန်အတွက် ပေါင်းစည်းပေးထားပါတယ်
        mv.addObject("isOwner", isOwner); 
        
        return mv;
    }

    @GetMapping("/tag/{tagId}")
    public ModelAndView browseByTag(
            @PathVariable("tagId") String encodedTagId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "filter", defaultValue = "ALL") String filter,
            HttpSession session) {
            
        Integer tagId = com.hibernate.util.IdObfuscator.decode(encodedTagId);
        if (tagId == null) {
            try {
                tagId = Integer.parseInt(encodedTagId);
            } catch (NumberFormatException e) {
                return new ModelAndView("redirect:/home");
            }
        }
            
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
        mv.addObject("tagId", encodedTagId);
        mv.addObject("currentFilter", filter.toUpperCase());
        
        return mv;
    }
    
    // ==================== 🌟 [.JASPER HARD-FIXED] View PDF Report System ====================
    @GetMapping("/view-pdf/{id}")
    public void viewPdf(@PathVariable("id") String encodedId, HttpServletResponse response, HttpSession session) {
        try {
            Integer id = com.hibernate.util.IdObfuscator.decode(encodedId);
            if (id == null) {
                try {
                    id = Integer.parseInt(encodedId);
                } catch (NumberFormatException e) {
                    response.sendRedirect(response.encodeRedirectURL("/cheatsheet/list"));
                    return;
                }
            }
            CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
            if (cheatsheet == null) {
                response.sendRedirect(response.encodeRedirectURL("/cheatsheet/list"));
                return;
            }

            int currentDownloads = (cheatsheet.getDownloadCount() != null) ? cheatsheet.getDownloadCount() : 0;
            cheatsheet.setDownloadCount(currentDownloads + 1);
            cheatsheetService.update(cheatsheet);
            
            InputStream reportStream = this.getClass().getResourceAsStream("/reports/cheatsheet_template.jasper");
            if (reportStream == null) {
                throw new java.io.FileNotFoundException("Jasper compiled (.jasper) file not found in resources folder!");
            }
            
            List<CheatsheetEntity> dataList = java.util.Collections.singletonList(cheatsheet);
            net.sf.jasperreports.engine.data.JRBeanCollectionDataSource dataSource = 
                    new net.sf.jasperreports.engine.data.JRBeanCollectionDataSource(dataList);

            Map<String, Object> parameters = new HashMap<>();
            User currentUser = (User) session.getAttribute("currentUser");
            String username = "Guest User";
            if (currentUser != null && currentUser.getUsername() != null) {
                username = currentUser.getUsername();
            }
            parameters.put("DownloadedBy", username); 
            
            net.sf.jasperreports.engine.JasperPrint jasperPrint = 
                    net.sf.jasperreports.engine.JasperFillManager.fillReport(reportStream, parameters, dataSource);
            
            byte[] pdfBytes = net.sf.jasperreports.engine.JasperExportManager.exportReportToPdf(jasperPrint);
            
            response.setContentType("application/pdf");
            String filename = (cheatsheet.getTitle() != null) ? cheatsheet.getTitle() : "cheatsheet";
            
            response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + ".pdf\"");
            response.setContentLength(pdfBytes.length);

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