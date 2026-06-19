package com.hibernate.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.entity.CategoryEntity;
import com.hibernate.service.CategoryService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/category")
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping("/list")
    public ModelAndView categoryList() {
        List<CategoryEntity> list = categoryService.findAll();
        return new ModelAndView("category-list", "categorylist", list);
    }

    @GetMapping("/add")
    public ModelAndView addCategoryForm() {
        return new ModelAndView("category", "category", new CategoryEntity());
    }

    @PostMapping("/save")
    public ModelAndView saveCategory(
            @ModelAttribute("category") CategoryEntity category) {

        categoryService.save(category);

        return new ModelAndView("redirect:/category/list");
    }

    @GetMapping("/edit/{id}")
    public ModelAndView editCategory(
            @PathVariable("id") Integer id) {

        CategoryEntity category = categoryService.findById(id);

        return new ModelAndView("category-edit", "category", category);
    }

    @PostMapping("/update")
    public ModelAndView updateCategory(
            @ModelAttribute("category") CategoryEntity category) {

        categoryService.update(category);

        return new ModelAndView("redirect:/category/list");
    }

    @GetMapping("/delete/{id}")
    public ModelAndView deleteCategory(
            @PathVariable("id") Integer id) {

        categoryService.delete(id);

        return new ModelAndView("redirect:/category/list");
    }
}