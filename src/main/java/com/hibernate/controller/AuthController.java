package com.hibernate.controller;

import com.hibernate.entity.SharedCheatsheetEntity;
import com.hibernate.entity.CheatsheetEntity;
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

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

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
    
 // 🌟 ၁။ စာမျက်နှာလှန်သည့် ခလုတ်နှိပ်ပါက နောက်ကွယ်မှ ဒေတာကို Session ထဲ သိမ်းပေးမည့် POST Mapping
    @PostMapping("/home")
    public String handleHomePagination(
            @RequestParam(value = "page", required = false) Integer page,
            @RequestParam(value = "sharedPage", required = false) Integer sharedPage,
            @RequestParam(value = "q", required = false) String query,
            HttpSession session) {
        
        if (page != null) session.setAttribute("currentPageSession", page);
        if (sharedPage != null) session.setAttribute("sharedPageSession", sharedPage);
        if (query != null) session.setAttribute("searchQuerySession", query);
        
        return "redirect:/home"; // 👈 URL အား အမြဲ Clean ဖြစ်နေစေရန် Redirect ပြန်လုပ်ခြင်း
    }
   
    @Transactional
    @GetMapping("/home")
    public String showHomeDashboard(
//            @RequestParam(value = "page", defaultValue = "1") int page,
//            @RequestParam(value = "sharedPage", defaultValue = "1") int sharedPage,
//            @RequestParam(value = "q", defaultValue = "") String query,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            model.addAttribute("currentUser", currentUser);
        }
        
        int page = (session.getAttribute("currentPageSession") != null) ? (int) session.getAttribute("currentPageSession") : 1;
        int sharedPage = (session.getAttribute("sharedPageSession") != null) ? (int) session.getAttribute("sharedPageSession") : 1;
        String query = (session.getAttribute("searchQuerySession") != null) ? (String) session.getAttribute("searchQuerySession") : "";
        
        model.addAttribute("categorylist", categoryService.findAllActive());
        model.addAttribute("announcements", announcementService.findLatest(3));
        
        model.addAttribute("cheatsheetlist", cheatsheetService.findLatestPublic(query, page, 6));
        model.addAttribute("popularCheatsheets", cheatsheetService.findPopularPublic(6));
        model.addAttribute("searchQuery", query);
        model.addAttribute("currentPage", page);
      
        
        long total = cheatsheetService.countLatestPublic(query);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / 6)));
        
        
     // ===== 🌟 Shared Sheets Pagination (တစ်မျက်နှာလျှင် ၄ ခု အတိအကျ ကန့်သတ်ခြင်း) 🌟 =====
        List<SharedCheatsheetEntity> allShared = sharedCheatsheetRepository.findAllSharedWithDetails();
        int totalSharedCount = allShared.size();
        int pageSize = 4; // တစ်စာမျက်နှာမှာ ပြသမည့် Post အရေအတွက်ကို ၄ ခုအဖြစ် သတ်မှတ်ခြင်း
        
        // ပို့စ်စုစုပေါင်းပေါ် မူတည်ပြီး စာမျက်နှာအရေအတွက်ကို Dynamic တွက်ချက်ခြင်း
        int sharedTotalPages = (int) Math.ceil((double) totalSharedCount / pageSize);
        if (sharedTotalPages == 0) {
            sharedTotalPages = 1;
        }
        
        // စာမျက်နှာ Bounds အတွက် Error မတက်အောင် Safety Check လုပ်ခြင်း
        if (sharedPage < 1) sharedPage = 1;
        if (sharedPage > sharedTotalPages) sharedPage = sharedTotalPages;
        
        // လက်ရှိ စာမျက်နှာအလိုက် Data ဖြတ်ထုတ်ရန် Start နှင့် End Index ကို တွက်ချက်ခြင်း
        int fromIndex = (sharedPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalSharedCount);
        
        List<SharedCheatsheetEntity> paginatedShared = new ArrayList<>();
        if (fromIndex < totalSharedCount) {
            paginatedShared = allShared.subList(fromIndex, toIndex);
        }
        
        
        
        
        model.addAttribute("sharedPosts", paginatedShared); 
        model.addAttribute("sharedCurrentPage", sharedPage);
        model.addAttribute("sharedTotalPages", sharedTotalPages);
        
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