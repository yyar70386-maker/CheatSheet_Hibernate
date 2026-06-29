package com.hibernate.controller;

import java.io.InputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.entity.User;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.NotificationService;
import com.hibernate.service.TagService;
import com.hibernate.websocket.NotificationSocketService;

// 🌟 KSYK Feature Imports (Detail Data ဆွဲထုတ်ရန်)
import com.hibernate.service.InteractionServiceImpl;
import com.hibernate.service.FavoriteService;
import com.hibernate.service.RatingService;
import com.hibernate.entity.CommentEntity;
import com.hibernate.entity.FavoriteEntity;
import com.hibernate.entity.RatingEntity;
import com.hibernate.entity.SheetReactionEntity;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/cheatsheet")
public class CheatsheetController {

    private final CheatsheetService cheatsheetService;
    private final CategoryService categoryService;
    private final TagService tagService;
    private final NotificationService notificationService;
    private final NotificationSocketService notificationSocketService;
    private final AuditLogService auditLogService;
    
    // KSYK Services များ
    private final InteractionServiceImpl interactionService;
    private final FavoriteService favoriteService;
    private final RatingService ratingService;

    @GetMapping("/list")
    public ModelAndView list() {
        return new ModelAndView("cheatsheet-list", "cheatsheetlist", cheatsheetService.findAll());
    }

    @GetMapping("/add")
    public ModelAndView addForm() {
        ModelAndView mv = new ModelAndView("cheatsheet", "cheatsheet", new CheatsheetEntity());
        mv.addObject("categorylist", categoryService.findAll());
        return mv;
    }

    @PostMapping("/save")
    public ModelAndView save(@ModelAttribute("cheatsheet") CheatsheetEntity cheatsheet, @RequestParam(value = "tagIds", required = false) List<Integer> tagIds, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            cheatsheet.setAuthor(currentUser);
        }

        if (tagIds != null) {
            List<TagEntity> tags = tagService.findByIds(tagIds);
            cheatsheet.setTags(tags);
        }

        Integer sheetId = cheatsheetService.save(cheatsheet);
        if (currentUser != null && sheetId != null) {
            notificationSocketService.broadcastNotifications(
                    notificationService.createCheatsheetNotificationsForFollowers(
                            currentUser.getId(), sheetId, cheatsheet.getTitle()));
            auditLogService.log(currentUser, "New CheatSheet Created", "Cheatsheet", sheetId);
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
        if (cheatsheet.getCategory() != null) mv.addObject("taglist", tagService.findByCategoryId(cheatsheet.getCategory().getId()));
        return mv;
    }

    @PostMapping("/update")
    public ModelAndView update(
            @ModelAttribute("cheatsheet") CheatsheetEntity cheatsheet,
            @RequestParam(value = "tagIds", required = false) List<Integer> tagIds,
            HttpSession session) { 

        CheatsheetEntity existingSheet = cheatsheetService.findById(cheatsheet.getId());
        if (existingSheet != null) {
            cheatsheet.setAuthor(existingSheet.getAuthor());
            if (cheatsheet.getViewCount() == null) cheatsheet.setViewCount(existingSheet.getViewCount());
        }
        if (tagIds != null) cheatsheet.setTags(tagService.findByIds(tagIds));
        cheatsheetService.update(cheatsheet);
        return new ModelAndView("redirect:/cheatsheet/list");
    }

    @GetMapping("/delete/{id}")
    public ModelAndView delete(@PathVariable Integer id) {
        cheatsheetService.delete(id);
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
                html.append("<label class='tag-box'><input type='checkbox' name='tagIds' value='").append(tag.getId()).append("'> ").append(tag.getName()).append("</label>");
            }
        }
        return html.toString();
    }

    @GetMapping("/category/{categoryId}")
    public ModelAndView browseByCategory(@PathVariable("categoryId") Integer categoryId, @RequestParam(value = "page", defaultValue = "1") int page, HttpSession session) {
        int pageSize = 3;
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        // 🌟 [CORRECTED] Service ထဲတွင် နာမည်ပြောင်းလဲထားမှုအရ မက်သတ်အမည်များကို ညှိနှိုင်းပြင်ဆင်ထားပါသည်
        List<CheatsheetEntity> cheatsheets = cheatsheetService.findByCategoryIdWithPagination(categoryId, page, pageSize, currentUserId);
        long totalCheatsheets = cheatsheetService.countByCategoryId(categoryId, currentUserId); 
        
        // Total Pages တွက်ချက်ခြင်းကို ဤနေရာတွင် တိုက်ရိုက် Math.ceil ဖြင့် ရှင်းလင်းစွာ လုပ်ဆောင်ပေးလိုက်ပါသည်
        int totalPages = (int) Math.ceil((double) totalCheatsheets / pageSize);
        if (totalPages == 0) totalPages = 1;
        
        List<TagEntity> categoryTags = cheatsheetService.findTagsByCategoryId(categoryId);
        var currentCategory = categoryService.findById(categoryId);
        String categoryName = (currentCategory != null) ? currentCategory.getName() : "Unknown";
        ModelAndView mv = new ModelAndView("cheatsheet-browse");
        mv.addObject("cheatsheetlist", cheatsheets); mv.addObject("taglist", categoryTags);
        mv.addObject("currentPage", page); mv.addObject("totalPages", totalPages);
        mv.addObject("categoryId", categoryId); mv.addObject("categoryName", categoryName);
        mv.addObject("totalCount", totalCheatsheets); 
        return mv;
    }

    @GetMapping("/tag/{tagId}")
    public ModelAndView browseByTag(@PathVariable("tagId") Integer tagId) {
        // 🌟 [CORRECTED] Service မက်သတ်အမည်နှင့် ကိုက်ညီအောင် ပြင်ဆင်ထားပါသည်
        List<CheatsheetEntity> cheatsheets = cheatsheetService.findPublicCheatsheetsByTagId(tagId);
        
        var tagObj = tagService.findById(tagId); 
        String tagName = (tagObj != null) ? tagObj.getName() : "Unknown";
        ModelAndView mv = new ModelAndView("cheatsheet-tag-list");
        mv.addObject("cheatsheetlist", cheatsheets); mv.addObject("tagName", tagName); mv.addObject("totalCount", cheatsheets != null ? cheatsheets.size() : 0);
        return mv;
    }

    // 🌟 Detail Page ပြသရန် (Count များ၊ Rating များ အားလုံး ထည့်ပို့ပေးသည်) + [Merged with HEAD and swan branch]
    @GetMapping("/detail/{id}")
    public ModelAndView showDetail(@PathVariable("id") Integer id, HttpSession session) {
        CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
        if (cheatsheet == null) return new ModelAndView("redirect:/home");
        
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        boolean isOwner = cheatsheet.getAuthor() != null && cheatsheet.getAuthor().getId() != null && cheatsheet.getAuthor().getId().equals(currentUserId);
        boolean isPrivate = "PRIVATE".equalsIgnoreCase(cheatsheet.getVisibility());
        
        if (isPrivate && !isOwner) return new ModelAndView("redirect:/home"); 
        if (!isPrivate && !isOwner) {
            int currentViews = cheatsheet.getViewCount() != null ? cheatsheet.getViewCount() : 0;
            cheatsheet.setViewCount(currentViews + 1); 
            cheatsheetService.update(cheatsheet); 
        }
        
        ModelAndView mv = new ModelAndView("cheatsheet-detail", "sheet", cheatsheet);
        
        if (currentUserId != 0) {
            // User ၏ Favorite နှင့် Rating အခြေအနေကို စစ်ဆေးခြင်း
            FavoriteEntity isFavorited = favoriteService.getByUserIdAndSheetId(currentUserId, id);
            mv.addObject("isFavorited", isFavorited != null);
            
            @SuppressWarnings("unused")
            RatingEntity userRating = ratingService.getByUserAndSheetId(currentUserId, id);
            mv.addObject("userRating", userRating != null ? userRating.getStars() : 0);
            
            SheetReactionEntity sheetReaction = interactionService.getSheetReaction(currentUserId, id);
            mv.addObject("userSheetLike", sheetReaction != null ? sheetReaction.getIsLike() : null); 
        }

        // 🌟 CheatSheet ၏ Like နှင့် Dislike Count များကို View သို့ ပို့ပေးခြင်း
        Long sheetLikes = interactionService.countSheetReactions(id, true);
        Long sheetDislikes = interactionService.countSheetReactions(id, false);
        mv.addObject("sheetLikes", sheetLikes != null ? sheetLikes : 0L);
        mv.addObject("sheetDislikes", sheetDislikes != null ? sheetDislikes : 0L);

        // 🌟 Comment များကို Count များနှင့်တကွ ပို့ပေးခြင်း (currentUserId ပါ တွဲပို့ပေးရမည်)
        List<CommentEntity> comments = interactionService.getCommentsBySheetId(id, currentUserId);
        mv.addObject("commentsList", comments);
        
        Double avgRating = ratingService.getAverageRatingBySheetId(id);
        mv.addObject("avgRating", avgRating != null ? avgRating : 0.0);
        
        return mv;
    }
    
    

    @GetMapping("/view-pdf/{id}")
    public void viewPdf(@PathVariable("id") Integer id, HttpServletResponse response, HttpSession session) {
        try {
            // ၁။ DB ထဲမှ သက်ဆိုင်ရာ Cheatsheet Data ကို ဆွဲထုတ်ခြင်း
            CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
            
            if (cheatsheet != null) {
                // Download Count ကို ၁ တိုးပြီး DB တွင် ပြန်သိမ်းခြင်း
                int currentDownloads = (cheatsheet.getDownloadCount() != null) ? cheatsheet.getDownloadCount() : 0;
                cheatsheet.setDownloadCount(currentDownloads + 1);
                cheatsheetService.update(cheatsheet);
                
                // ၂။ Jasper Report 템플릿 (.jasper) ဖိုင်ကို လမ်းကြောင်းပြောင်းယူခြင်း
                InputStream reportStream = this.getClass().getResourceAsStream("/reports/cheatsheet_template.jasper");
                
                List<CheatsheetEntity> dataList = java.util.Collections.singletonList(cheatsheet);
                net.sf.jasperreports.engine.data.JRBeanCollectionDataSource dataSource = 
                        new net.sf.jasperreports.engine.data.JRBeanCollectionDataSource(dataList);

                // 🌟 [ဒီအကွက်ထဲမှာ အသစ်ဖြည့်သွင်းပေးထားပါတယ်ဗျာ]
                java.util.Map<String, Object> parameters = new java.util.HashMap<>();
                
                // Session ထဲမှ လက်ရှိ Login ဝင်ထားသော User Object ကို ယူသည်
                User currentUser = (User) session.getAttribute("currentUser");
                
                // User ရဲ့ Name သို့မဟုတ် Username ကို ယူသည် (မရှိလျှင် Guest User ဟု သတ်မှတ်မည်)
                String username = "Guest User";
                if (currentUser != null) {
                    if (currentUser.getUsername() != null) {
                        username = currentUser.getUsername(); // 🌟 Fix: getName() အစား getUsername() ကို သုံးထားပါသည်
                    }
                }

                // Jaspersoft Studio ရဲ့ Parameter ဆီသို့ နာမည်ကို တိုက်ရိုက် လှမ်းထည့်ပေးခြင်း
                parameters.put("DownloadedBy", username);

                // ၃။ Jasper Report ဖြည့်သွင်းတည်ဆောက်ခြင်း
                net.sf.jasperreports.engine.JasperPrint jasperPrint = 
                        net.sf.jasperreports.engine.JasperFillManager.fillReport(reportStream, parameters, dataSource);
                
                // ၄။ Browser တွင် PDF ပြသရန် Response Header များ သတ်မှတ်ခြင်း
                response.setContentType("application/pdf");
                String filename = (cheatsheet.getTitle() != null) ? cheatsheet.getTitle() : "cheatsheet";
                response.setHeader("Content-Disposition", "inline; filename=\"" + filename + ".pdf\"");

                // ၅။ PDF ကို Output Stream ဖြင့် ဆွဲထုတ်ပေးခြင်း
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
