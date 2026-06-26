package com.hibernate.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; 
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hibernate.entity.CategoryEntity;
import com.hibernate.entity.User;
import com.hibernate.service.CategoryService;
import com.hibernate.service.UserService;

@Controller
public class AdminController {

    @Autowired
    private CategoryService categoryService; 
    
    @Autowired
    private UserService userService;

    // ==================== 📂 CATEGORIES MANAGEMENT METHODS ====================
    
    // ၁။ Category Page အားပြသခြင်းနှင့် List ထုတ်ခြင်း
    @GetMapping("/categories")
    public String showCategoryPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        
        // 🔐 Login & Admin Role စစ်ဆေးခြင်း
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        if (currentUser.getRole() != 1) {
            redirectAttributes.addFlashAttribute("errorMsg", "Access Denied! You do not have Admin privileges.");
            return "redirect:/profile";
        }

        // 📌 ပြင်ဆင်ချက်: getAllCategories() အစား Service အသစ်အတိုင်း findAll() သို့ ပြောင်းလဲထားပါသည်
        List<CategoryEntity> categoryList = categoryService.findAll(); 
        model.addAttribute("categories", categoryList);

        // Form Binding အတွက် Object အလွတ်တစ်ခု ထည့်ပေးခြင်း (Edit Mode မဟုတ်မှသာ အသစ်ထည့်မည်)
        if (!model.containsAttribute("categoryAttr")) {
            model.addAttribute("categoryAttr", new CategoryEntity());
        }

        return "categories"; 
    }

    // ၂။ Category အသစ်တစ်ခု သိမ်းဆည်းခြင်း (Add Action)
    @PostMapping("/categories/add")
    public String addCategory(@ModelAttribute("categoryAttr") CategoryEntity category, 
                              HttpSession session, RedirectAttributes redirectAttributes) {
        
        // 🔐 Admin Security Check
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != 1) {
            return "redirect:/login";
        }

        // 📌 Custom Validation: နာမည်တူရှိမရှိ စစ်ဆေးခြင်း
        CategoryEntity existing = categoryService.findByName(category.getName());
        if (existing != null) {
            redirectAttributes.addFlashAttribute("errorMsg", "Category name '" + category.getName() + "' already exists!");
            return "redirect:/categories";
        }

        categoryService.save(category);
        redirectAttributes.addFlashAttribute("successMsg", "Category added successfully!");
        return "redirect:/categories";
    }

    // ၃။ Edit လုပ်ရန် ဒေတာဆွဲထုတ်ပြီး Form ဆီသို့ ပြန်ပို့ခြင်း
    @GetMapping("/categories/edit/{id}")
    public String showEditForm(@PathVariable("id") Integer id, HttpSession session, 
                               Model model, RedirectAttributes redirectAttributes) {
        
        // 🔐 Admin Security Check
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != 1) {
            return "redirect:/login";
        }

        CategoryEntity category = categoryService.findById(id);
        if (category == null) {
            redirectAttributes.addFlashAttribute("errorMsg", "Category not found!");
            return "redirect:/categories";
        }

        // Table ထဲမှာ စာရင်းတွေ ဆက်ပြနေစေရန် ဒေတာပြန်ထည့်ပေးခြင်း
        model.addAttribute("categories", categoryService.findAll());
        model.addAttribute("categoryAttr", category); // ရှာတွေ့တဲ့ ဒေတာကို Form ထဲ Bind လုပ်ရန် ထည့်ပေးခြင်း
        model.addAttribute("isEdit", true); // JSP ဘက်တွင် Form ခလုတ်ကို "Update" ဟု ပြောင်းရန် Flag
        
        return "categories";
    }

    // ၄။ ပြင်ဆင်ပြီးသား Category ကို ဒေတာဘေ့စ်တွင် အမှန်တကယ် Update လုပ်ခြင်း
    @PostMapping("/categories/update")
    public String updateCategory(@ModelAttribute("categoryAttr") CategoryEntity category, 
                                 HttpSession session, RedirectAttributes redirectAttributes) {
        
        // 🔐 Admin Security Check
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != 1) {
            return "redirect:/login";
        }

        // 📌 Custom Validation: မိမိ ID မဟုတ်သော အခြား Category များတွင် နာမည်တူရှိမရှိ စစ်ဆေးခြင်း
        CategoryEntity existing = categoryService.findByName(category.getName());
        if (existing != null && !existing.getId().equals(category.getId())) {
            redirectAttributes.addFlashAttribute("errorMsg", "Category name '" + category.getName() + "' already exists!");
            return "redirect:/categories/edit/" + category.getId();
        }

        categoryService.update(category);
        redirectAttributes.addFlashAttribute("successMsg", "Category updated successfully!");
        return "redirect:/categories";
    }

    // ၅။ Category အား ဖျက်ပစ်ခြင်း (Soft Delete)
    @GetMapping("/categories/delete/{id}")
    public String deleteCategory(@PathVariable("id") Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        
        // 🔐 Admin Security Check
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != 1) {
            return "redirect:/login";
        }

        categoryService.delete(id);
        redirectAttributes.addFlashAttribute("successMsg", "Category deleted successfully!");
        return "redirect:/categories";
    }

    // ==================== 📂 OTHER MANAGEMENT METHODS ====================
    
    @GetMapping("/tag")
    public String showTagManagementPage(Model model) {
        return "tag"; 
    }
    
    @GetMapping("/users")
    public String showUserManagementPage(Model model) {
        List<User> userList = userService.getAllUsers();
        model.addAttribute("users", userList); 
        return "user"; 
    }
}