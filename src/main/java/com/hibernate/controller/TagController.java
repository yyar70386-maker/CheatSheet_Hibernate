package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.entity.TagEntity;
import com.hibernate.entity.User;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.TagService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/tag")
public class TagController {

    private final TagService tagService;
    private final CategoryService categoryService;
    private final AuditLogService auditLogService;

    // Legacy Route: တကယ်လို့ အရင် view အဟောင်းကို ခေါ်မိရင်လည်း Admin Layout ဆီသို့သာ မောင်းထုတ်ပေးမည်
    @GetMapping("/list")
    public ModelAndView tagList() {
        return new ModelAndView("redirect:/admin/tags");
    }

    @GetMapping("/add")
    public ModelAndView addForm() {
        ModelAndView mv = new ModelAndView("tag", "tag", new TagEntity());
        mv.addObject("categorylist", categoryService.findAllActive());
        return mv;
    }

    @PostMapping("/save")
    public ModelAndView save(
            @ModelAttribute("tag") TagEntity tag,
            HttpServletRequest request,
            HttpSession session) {

        Integer id = tagService.save(tag);
        auditLogService.log((User) session.getAttribute("currentUser"), "Create Tag", "Tag", id,
                "Created tag: " + tag.getName(), request.getRemoteAddr());

        // 🌟 [REDIRECT FIX] Save ပြီးပါက အဟောင်းဆီမသွားတော့ဘဲ Admin Framework layout ဆီသို့ တိုက်ရိုက်ပြန်လှည့်ခြင်း
        return new ModelAndView("redirect:/admin/tags");
    }

    @GetMapping("/edit/{id}")
    public ModelAndView edit(@PathVariable Integer id) {
        ModelAndView mv = new ModelAndView("tag-edit", "tag", tagService.findById(id));
        mv.addObject("categorylist", categoryService.findAllActive());
        return mv;
    }

    @PostMapping("/update")
    public ModelAndView update(
            @ModelAttribute("tag") TagEntity tag,
            HttpServletRequest request,
            HttpSession session) {

        tagService.update(tag);
        auditLogService.log((User) session.getAttribute("currentUser"), "Update Tag", "Tag", tag.getId(),
                "Updated tag: " + tag.getName(), request.getRemoteAddr());

        // 🌟 [REDIRECT FIX] Update ပြီးပါကလည်း Admin Layout Framework ထဲသို့သာ ပြန်ပို့မည်
        return new ModelAndView("redirect:/admin/tags");
    }

    @GetMapping("/delete/{id}")
    public ModelAndView delete(
            @PathVariable Integer id,
            HttpServletRequest request,
            HttpSession session) {

        tagService.delete(id);
        auditLogService.log((User) session.getAttribute("currentUser"), "Delete Tag", "Tag", id,
                "Tag deactivated.", request.getRemoteAddr());

        // 🌟 [REDIRECT FIX] Delete ပြီးပါကလည်း Admin Layout Framework ထဲသို့သာ ပြန်ပို့မည်
        return new ModelAndView("redirect:/admin/tags");
    }
}