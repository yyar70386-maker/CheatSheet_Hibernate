package com.hibernate.controller;

import java.util.List;
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
        
        boolean isOwner = cheatsheet.getAuthor() != null && 
                          cheatsheet.getAuthor().getId() != null && 
                          cheatsheet.getAuthor().getId().equals(currentUserId);
                          
        boolean isPrivate = "PRIVATE".equalsIgnoreCase(cheatsheet.getVisibility());
        
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
        // 🌟 [CORRECTED] Service မက်သတ်အမည်နှင့် ကိုက်ညီအောင် ပြင်ဆင်ထားပါသည်
        List<CheatsheetEntity> cheatsheets = cheatsheetService.findPublicCheatsheetsByTagId(tagId);
        
        var tagObj = tagService.findById(tagId); 
        String tagName = (tagObj != null) ? tagObj.getName() : "Unknown";
        int size = (cheatsheets != null) ? cheatsheets.size() : 0;
        
        ModelAndView mv = new ModelAndView("cheatsheet-tag-list");
        mv.addObject("cheatsheetlist", cheatsheets);
        mv.addObject("tagName", tagName);
        mv.addObject("totalCount", size);
        
        return mv;
    }
}