package com.hibernate.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.entity.TagEntity;
import com.hibernate.service.CategoryService;
import com.hibernate.service.TagService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/tag")
public class TagController {

    private final TagService tagService;
    private final CategoryService categoryService;

    @GetMapping("/list")
    public ModelAndView tagList() {

        return new ModelAndView(
                "tag-list",
                "taglist",
                tagService.findAll());
    }

    @GetMapping("/add")
    public ModelAndView addForm() {

        ModelAndView mv =
                new ModelAndView("tag", "tag", new TagEntity());

        mv.addObject(
                "categorylist",
                categoryService.findAll());

        return mv;
    }

    @PostMapping("/save")
    public ModelAndView save(
            @ModelAttribute("tag") TagEntity tag) {

        tagService.save(tag);

        return new ModelAndView("redirect:/tag/list");
    }

    @GetMapping("/edit/{id}")
    public ModelAndView edit(
            @PathVariable Integer id) {

        ModelAndView mv =
                new ModelAndView(
                        "tag-edit",
                        "tag",
                        tagService.findById(id));

        mv.addObject(
                "categorylist",
                categoryService.findAll());

        return mv;
    }

    @PostMapping("/update")
    public ModelAndView update(
            @ModelAttribute("tag") TagEntity tag) {

        tagService.update(tag);

        return new ModelAndView("redirect:/tag/list");
    }

    @GetMapping("/delete/{id}")
    public ModelAndView delete(
            @PathVariable Integer id) {

        tagService.delete(id);

        return new ModelAndView("redirect:/tag/list");
    }
}