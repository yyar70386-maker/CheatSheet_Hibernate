package com.hibernate.controller;

import java.io.InputStream;
import java.util.List;

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
        // [SECURITY CHECK] Login မဝင်ထားသော Guest ဖြစ်ပါက login စာမျက်နှာသို့ မောင်းထုတ်မည်
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return new ModelAndView("redirect:/login");
        }
        
        // 🌟 အားလုံးကို မပြတော့ဘဲ လက်ရှိ Login ဝင်ထားသော User ID ဖြင့် ကိုယ်ပိုင် Active Cheatsheets ကိုသာ ဆွဲထုတ်ခြင်း
        List<CheatsheetEntity> mySheets = cheatsheetService.findByUserId(currentUser.getId());
        
        // View Name အား "mycheatsheet" (mycheatsheet.jsp) အဖြစ် ပြောင်းလဲသတ်မှတ်ခြင်း
        return new ModelAndView("mycheatsheet", "cheatsheetlist", mySheets);
    }

    @GetMapping("/add")
    public ModelAndView addForm(HttpSession session) { // 🌟 Fix: Session အား Parameter တွင် ထည့်သွင်းခြင်း
        // 🌟 [SECURITY CHECK] Guest ဖြစ်နေပါက login စာမျက်နှာသို့ မောင်းထုတ်မည်
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
        // 🌟 [SECURITY CHECK] Data Submit လုပ်ချိန်တွင်လည်း Guest ဖြစ်နေပါက ကာကွယ်ရန်
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
        
        // 🌟 Fix: Cheatsheet မရှိရင် list ကို ပြန်မောင်းထုတ်ပြီး NPE ကာကွယ်ခြင်း
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
            HttpSession session) { // 🌟 Author မပျောက်သွားစေရန် session ယူလိုက်သည်

        // 🌟 Fix: Update လုပ်တဲ့အခါ Author တန်ဖိုး null ဖြစ်မသွားအောင် မူလ DB ထဲက Author ကို ပြန်ထည့်ပေးခြင်း
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
        
        // 🌟 Fix: null စစ်ပြီး StringBuilder သုံးကာ Performance မြှင့်တင်ခြင်း
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
            @RequestParam(value = "filter", defaultValue = "ALL") String filter, // 🌟 Filter Parameter လက်ခံခြင်း
            HttpSession session) {
            
        int pageSize = 3;
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        // 🌟 Service မှတစ်ဆင့် Filter ပါ ပို့ပေးပြီး Data ဆွဲထုတ်ခြင်း
        List<CheatsheetEntity> cheatsheets = cheatsheetService.findByCategoryIdWithPagination(categoryId, page, pageSize, currentUserId, filter);
        long totalCheatsheets = cheatsheetService.countByCategoryId(categoryId, currentUserId, filter); 
        
        int totalPages = (int) Math.ceil((double) totalCheatsheets / pageSize);
        if (totalPages == 0) totalPages = 1;
        
     // 🌟 Fix: Service logic သစ်အတိုင်း currentUserId အား ထည့်သွင်းပေးလိုက်ပါသည်
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
        mv.addObject("currentFilter", filter.toUpperCase()); // UI တွင် Active Button ပြရန်
        
        return mv;
    }

 // ==================== 🌟 Cheatsheet Detail View (With Smart View Count Logic) ====================
    @GetMapping("/detail/{id}")
    public ModelAndView viewDetail(@PathVariable("id") Integer id, HttpSession session) {
        
        // ၁။ ဒေတာဘေ့စ်မှ Cheatsheet အား ဆွဲထုတ်ခြင်း
        CheatsheetEntity sheet = cheatsheetService.findById(id);
        if (sheet == null || !"active".equals(sheet.getStatus())) {
            return new ModelAndView("redirect:/error/404"); // မရှိပါက 404 သို့ ညွှန်းမည်
        }

        // ၂။ လက်ရှိ Login ဝင်ထားသော User Information ကို ရယူခြင်း
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        Integer authorId = (sheet.getAuthor() != null) ? sheet.getAuthor().getId() : -1;

        // 🌟 ၃။ [SMART VIEW COUNT INCREMENT LOGIC]
        // - PRIVATE မဟုတ်ရပါဘူး
        // - မိမိကိုယ်တိုင် ဖန်တီးထားသော Owner မဟုတ်ရပါဘူး (Author ID နှင့် လက်ရှိ User ID မတူမှ တိုးမည်)
        boolean isPrivate = "PRIVATE".equalsIgnoreCase(sheet.getVisibility());
        boolean isOwner = currentUserId.equals(authorId);

        if (!isPrivate && !isOwner) {
            // လက်ရှိ View Count အား ရယူ၍ ၁ တိုးမြှင့်ပြီး DB တွင် အလိုအလျောက် Update လုပ်ခြင်း
            int currentViews = (sheet.getViewCount() != null) ? sheet.getViewCount() : 0;
            sheet.setViewCount(currentViews + 1);
            
            cheatsheetService.update(sheet); // Transaction အောက်တွင် သွားရောက် သိမ်းဆည်းခြင်း
        }

        // ၄။ Detail View စာမျက်နှာ (cheatsheet-detail.jsp) သို့ Data များ တွဲဖက်ပေးပို့ခြင်း
        ModelAndView mv = new ModelAndView("cheatsheet-detail");
        mv.addObject("sheet", sheet);
        mv.addObject("isOwner", isOwner); // UI ဘက်တွင် Edit/Delete ခလုတ်ပြရန်/ဖျောက်ရန်
        
        return mv;
    }

    @GetMapping("/tag/{tagId}")
    public ModelAndView browseByTag(
            @PathVariable("tagId") Integer tagId,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "filter", defaultValue = "ALL") String filter,
            HttpSession session) {
            
        int pageSize = 3; // သုံးခုတစ်တန်းပုံစံအတွက် Page Size သတ်မှတ်ခြင်း
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        // Service မှတစ်ဆင့် Filter & Pagination ဒေတာယူခြင်း
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
    
    

    @GetMapping("/view-pdf/{id}")
    public void viewPdf(
            @PathVariable("id") Integer id, 
            HttpServletResponse response, 
            HttpSession session) { // 🌟 Fix 1: Login User ဒေတာ ယူရန် session ကို ထည့်သွင်းလိုက်ပါသည်
        try {
            // ၁။ Service Layer မှတစ်ဆင့် Data ရှာဖွေခြင်း
            CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
            
            if (cheatsheet != null) {
                // Null-safe ဖြစ်အောင် စစ်ဆေးပြီး download count ကို ၁ တိုးပေးခြင်း
                int currentDownloads = (cheatsheet.getDownloadCount() != null) ? cheatsheet.getDownloadCount() : 0;
                cheatsheet.setDownloadCount(currentDownloads + 1);
                
                // ၂။ Service ရဲ့ @Transactional update ကို ခေါ်ပြီး DB တွင် သွားသိမ်းခြင်း
                cheatsheetService.update(cheatsheet);
                
                // ၃။ Jasper Report ဖြင့် PDF တည်ဆောက်ခြင်း
                InputStream reportStream = this.getClass().getResourceAsStream("/reports/cheatsheet_template.jasper");
                
                List<CheatsheetEntity> dataList = java.util.Collections.singletonList(cheatsheet);
                net.sf.jasperreports.engine.data.JRBeanCollectionDataSource dataSource = 
                        new net.sf.jasperreports.engine.data.JRBeanCollectionDataSource(dataList);

                java.util.Map<String, Object> parameters = new java.util.HashMap<>();
                
                // 🌟 Fix 2: Session ထဲမှ လက်ရှိ Login ဝင်ထားသော User ကို ဆွဲထုတ်ခြင်း
                User currentUser = (User) session.getAttribute("currentUser");
                
                // User ရဲ့ နာမည်ကို စစ်ဆေးခြင်း (မရှိလျှင် Guest User ဟု ပြသမည်)
                String username = "Guest User";
                if (currentUser != null) {
                    // သင့် User entity ထဲက နာမည်ယူတဲ့ method က getUsername() သို့မဟုတ် getFullName() ဖြစ်ပါက ၎င်းအတိုင်း ပြောင်းလဲပေးနိုင်ပါတယ်
                    if (currentUser.getUsername() != null) {
                        username = currentUser.getUsername();
                    }
                }
                
                // 🌟 Fix 3: Jaspersoft Studio က Parameter သို့ တန်ဖိုးကို ကွက်တိ လှမ်းထည့်ပေးခြင်း
                parameters.put("DownloadedBy", username); 
                
                net.sf.jasperreports.engine.JasperPrint jasperPrint = 
                        net.sf.jasperreports.engine.JasperFillManager.fillReport(reportStream, parameters, dataSource);
                
                // ၄။ Browser တွင် ဒေါင်းလုဒ်မကျဘဲ Inline (တန်းပွင့်) ပြသရန် Header သတ်မှတ်ခြင်း
                response.setContentType("application/pdf");
                String filename = (cheatsheet.getTitle() != null) ? cheatsheet.getTitle() : "cheatsheet";
                response.setHeader("Content-Disposition", "inline; filename=\"" + filename + ".pdf\"");

                // ၅။ PDF Output Stream ထုတ်လွှတ်ခြင်း
                java.io.OutputStream out = response.getOutputStream();
                net.sf.jasperreports.engine.JasperExportManager.exportReportToPdfStream(jasperPrint, out);
                out.flush();
            } else {
                response.sendRedirect(response.encodeRedirectURL("/cheatsheet/list"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
