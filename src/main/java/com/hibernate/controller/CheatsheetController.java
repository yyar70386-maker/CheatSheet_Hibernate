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
import com.hibernate.service.TagService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/cheatsheet")
public class CheatsheetController {

    private final CheatsheetService cheatsheetService;
    private final CategoryService categoryService;
    private final TagService tagService;

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
    public ModelAndView save(
            @ModelAttribute("cheatsheet") CheatsheetEntity cheatsheet,
            @RequestParam(value = "tagIds", required = false) List<Integer> tagIds,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            cheatsheet.setAuthor(currentUser);
        }

        if (tagIds != null) {
            List<TagEntity> tags = tagService.findByIds(tagIds);
            cheatsheet.setTags(tags);
        }

        cheatsheetService.save(cheatsheet);
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
            HttpSession session) {
        
        int pageSize = 3;
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        List<CheatsheetEntity> cheatsheets = cheatsheetService.getCheatsheetsByCategoryWithPagination(categoryId, page, pageSize, currentUserId);
        int totalPages = cheatsheetService.getTotalPagesByCategory(categoryId, pageSize, currentUserId);
        long totalCheatsheets = cheatsheetService.countByCategoryId(categoryId, currentUserId); 
        
        List<TagEntity> categoryTags = cheatsheetService.findTagsByCategoryId(categoryId);
        
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
        
        return mv;
    }

    @GetMapping("/detail/{id}")
    public ModelAndView showDetail(@PathVariable("id") Integer id, HttpSession session) {
        CheatsheetEntity cheatsheet = cheatsheetService.findById(id);
        
        if (cheatsheet == null) {
            return new ModelAndView("redirect:/home");
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        Integer currentUserId = (currentUser != null) ? currentUser.getId() : 0;
        
        // 🌟 Fix: cheatsheet.getAuthor() ကို null-safe ဖြစ်အောင် အရင်စစ်ဆေးခြင်း
        boolean isOwner = cheatsheet.getAuthor() != null && 
                          cheatsheet.getAuthor().getId() != null && 
                          cheatsheet.getAuthor().getId().equals(currentUserId);
                          
        boolean isPrivate = "PRIVATE".equalsIgnoreCase(cheatsheet.getVisibility());
        
        // 🌟 Fix [SECURITY]: Private ဖြစ်ပြီး Owner မဟုတ်ရင် ကြည့်ခွင့်မပေးဘဲ မောင်းထုတ်ခြင်း
        if (isPrivate && !isOwner) {
            return new ModelAndView("redirect:/home"); 
        }
        
        if (!isPrivate && !isOwner) {
            int currentViews = cheatsheet.getViewCount() != null ? cheatsheet.getViewCount() : 0;
            cheatsheet.setViewCount(currentViews + 1);
            cheatsheetService.update(cheatsheet); 
        }
        
        return new ModelAndView("cheatsheet-detail", "sheet", cheatsheet);
    }

    @GetMapping("/tag/{tagId}")
    public ModelAndView browseByTag(@PathVariable("tagId") Integer tagId) {
        List<CheatsheetEntity> cheatsheets = cheatsheetService.getPublicCheatsheetsByTagId(tagId);
        
        var tagObj = tagService.findById(tagId); 
        String tagName = (tagObj != null) ? tagObj.getName() : "Unknown";
        int size = (cheatsheets != null) ? cheatsheets.size() : 0;
        
        ModelAndView mv = new ModelAndView("cheatsheet-tag-list");
        mv.addObject("cheatsheetlist", cheatsheets);
        mv.addObject("tagName", tagName);
        mv.addObject("totalCount", size);
        
        return mv;
    }
    
    
<<<<<<< Updated upstream
    
    
=======
>>>>>>> Stashed changes
    @GetMapping("/view-pdf/{id}")
    public void viewPdf(@PathVariable("id") Integer id, HttpServletResponse response) {
        try {
            // ၁။ Service Layer မှတစ်ဆင့် Data ရှာဖွေခြင်း (Read-only transaction အလုပ်လုပ်မည်)
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
<<<<<<< Updated upstream
    
=======
>>>>>>> Stashed changes
}