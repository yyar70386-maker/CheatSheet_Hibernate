package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.AnnouncementService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.TagService;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService; 

    @Autowired
    private CheatsheetService cheatsheetService;

    @Autowired
    private TagService tagService;

    @Autowired
    private AnnouncementService announcementService;

    @Autowired
    private AuditLogService auditLogService;

    @Autowired
    private com.hibernate.repository.SharedCheatsheetRepository sharedCheatsheetRepository;
    
    @Transactional
    @GetMapping("/") 
    public String showHomePage(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "q", defaultValue = "") String query,
            HttpSession session,
            Model model) {
        int pageSize = 6;
        
        model.addAttribute("categorylist", categoryService.findAllActive());
        model.addAttribute("announcements", announcementService.findLatest(3));
        model.addAttribute("cheatsheetlist", cheatsheetService.findLatestPublic(query, page, pageSize));
        model.addAttribute("popularCheatsheets", cheatsheetService.findPopularPublic(6));
        model.addAttribute("searchQuery", query);
        model.addAttribute("currentPage", page);
        
        model.addAttribute("sharedPosts", sharedCheatsheetRepository.findAllSharedWithDetails());
        
        long total = cheatsheetService.countLatestPublic(query);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));
        
        model.addAttribute("totalSheets", cheatsheetService.getTotalSheetsCount());
        model.addAttribute("totalTags", tagService.getTotalTagsCount());
        
        return "home";
    }
   
    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        model.addAttribute("user", new User());
        return "register";
    }

    @PostMapping("/register")
    public String processRegister(@ModelAttribute("user") User user, 
                                  @RequestParam("confirmPassword") String confirmPassword, Model model) {
        if (!user.getPassword().equals(confirmPassword)) {
            model.addAttribute("error", "Password and Confirm Password do not match!");
            return "register";
        }
        try {
            userService.registerUser(user);
            return "redirect:/login?success=registered";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "register";
        } catch (Exception e) {
            model.addAttribute("error", "An unexpected error occurred. Please try again.");
            return "register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "login"; 
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam("email") String email, 
                               @RequestParam("password") String password,
                               HttpServletRequest request,
                               HttpSession session, 
                               RedirectAttributes redirectAttributes) { 
        try {
            User user = userService.authenticateByEmail(email, password);
            if (user != null) {
                session.setAttribute("currentUser", user);
                auditLogService.log(user, "Login", "User", user.getId(), "User logged in.", request.getRemoteAddr());
                return "redirect:/home";
            } else {
                redirectAttributes.addFlashAttribute("loginError", "Invalid Email or Password!");
                return "redirect:/login"; 
            }
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("loginError", e.getMessage());
            return "redirect:/login";
        }
    }
    
    @GetMapping("/logout")
    public String handleLogout(HttpServletRequest request, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            auditLogService.log(currentUser, "Logout", "User", currentUser.getId(), "User logged out.", request.getRemoteAddr());
        }
        session.invalidate(); 
        return "redirect:/"; 
    }
   
    @Transactional
    @GetMapping("/home")
    public String showHomeDashboard(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "q", defaultValue = "") String query,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            model.addAttribute("currentUser", currentUser);
        }
        model.addAttribute("categorylist", categoryService.findAllActive());
        model.addAttribute("announcements", announcementService.findLatest(3));
        model.addAttribute("cheatsheetlist", cheatsheetService.findLatestPublic(query, page, 6));
        model.addAttribute("popularCheatsheets", cheatsheetService.findPopularPublic(6));
        model.addAttribute("searchQuery", query);
        model.addAttribute("currentPage", page);
        
        model.addAttribute("sharedPosts", sharedCheatsheetRepository.findAllSharedWithDetails());
        
        long total = cheatsheetService.countLatestPublic(query);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / 6)));
        
        model.addAttribute("totalSheets", cheatsheetService.getTotalSheetsCount());
        model.addAttribute("totalTags", tagService.getTotalTagsCount());
        
        return "home";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "forgot-password"; 
    }

    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam("email") String email, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        String contextPath = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
        boolean emailSent = userService.sendResetPasswordEmail(email, contextPath);
        if (emailSent) {
            redirectAttributes.addFlashAttribute("successMessage", "A password reset link has been sent to your email address.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "No account found with this email address.");
        }
        return "redirect:/forgot-password";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordForm(@RequestParam("token") String token, Model model) {
        model.addAttribute("token", token);
        return "reset-password"; 
    }

    @PostMapping("/reset-password")
    public String handleResetPassword(@RequestParam("token") String token,
                                      @RequestParam("password") String password,
                                      @RequestParam("confirmPassword") String confirmPassword, Model model) {
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "New passwords do not match!");
            model.addAttribute("token", token);
            return "reset-password";
        }
        boolean result = userService.resetPassword(token, password);
        if (result) {
            return "redirect:/login?success=password_reset"; 
        } else {
            model.addAttribute("error", "The reset link is invalid or has expired.");
            return "reset-password";
        }
    }
}