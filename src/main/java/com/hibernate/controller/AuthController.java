package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.CategoryService;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.util.UUID;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService; // 👈 Local မှ CategoryService ကို ထည့်သွင်းထားသည်
    
    @GetMapping("/")
    public String showHomePage(HttpSession session, Model model) {
        // 👈 Home page card များအတွက် active categories များကို ဆွဲထုတ်ပေးခြင်း
        model.addAttribute("categorylist", categoryService.findAll());
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
        
        // [VALIDATION] ၁။ Passwords နှစ်ခု တူ၊ မတူ အရင်စစ်ဆေးခြင်း
        if (!user.getPassword().equals(confirmPassword)) {
            model.addAttribute("error", "Password and Confirm Password do not match!");
            return "register";
        }
        
        try {
            // ၂။ Service ထဲက registerUser ကို လှမ်းခေါ်ပြီး (Username + Email တူ/မတူ) စစ်ခိုင်းခြင်း
            userService.registerUser(user);
            return "redirect:/login?success=registered";
            
        } catch (IllegalArgumentException e) {
            // 🚨 ၃။ Service ဘက်မှ တက်လာသော သီးသန့် Validation Error များကို ဖမ်းယူခြင်း
            model.addAttribute("error", e.getMessage());
            return "register";
            
        } catch (Exception e) {
            // 🛑 ၄။ အခြား မျှော်လင့်မထားသော Database သို့မဟုတ် စနစ် Error များအတွက်
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
                               HttpSession session, 
                               RedirectAttributes redirectAttributes) { // 🌟 GitHub ပါအတိုင်း RedirectAttributes ပြောင်းသုံးထားသည်
        
        User user = userService.authenticateByEmail(email, password);
       
        if (user != null) {
            session.setAttribute("currentUser", user);
            
            // 🚀 [🚨 ဤနေရာတွင် Role အား စစ်ဆေးပြီး လမ်းကြောင်းခွဲပေးရပါမည်]
            if (user.getRole() == 1) {
                // Admin (Role = 1) ဖြစ်ပါက Admin Dashboard URL သို့ လွှတ်မည်
                return "redirect:/admin/dashboard";
            } else {
                // သာမန် User ဖြစ်ပါက /home (သို့မဟုတ် /profile) သို့ လွှတ်မည်
                return "redirect:/home";
            }
            
        } else {
            // 🌟 GitHub ပါအတိုင်း addFlashAttribute ကို သုံးထားသဖြင့် Redirect ဖြစ်သော်လည်း ဒေတာမပျောက်ပါ
            redirectAttributes.addFlashAttribute("loginError", "Invalid Email or Password!");
            return "redirect:/login"; 
        }
    }
    
    @GetMapping("/logout")
    public String handleLogout(HttpSession session) {
        session.invalidate(); 
        return "redirect:/"; 
    }
   
    @GetMapping("/home")
    public String showHomeDashboard(HttpSession session, Model model) {
        // လုံခြုံရေးအရ Login ဝင်ထားခြင်း ရှိမရှိ အရင်စစ်ဆေးခြင်း
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login"; 
        }
        
        // 👈 Local ပါအတိုင်း Home page dashboard တွင် card များပေါ်ရန် data လှမ်းပို့ပေးခြင်း
        model.addAttribute("categorylist", categoryService.findAll());
        return "home"; 
    }

    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        // database ထဲမှ နောက်ဆုံးအချက်အလက်ကို ပြန်ဆွဲထုတ်ပြီး model ထဲထည့်ပေးခြင်း
        model.addAttribute("user", userService.findById(currentUser.getId()));
        return "profile";
    }

    // --- FORGOT & RESET PASSWORD CONTROLLERS ---

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
            // 🌟 GitHub ပါအတိုင်း Login page ဆီ တိုက်ရိုက်မသွားဘဲ Parameter ဖြင့် Redirect လှည့်ထားသည်
            return "redirect:/login?success=password_reset"; 
        } else {
            model.addAttribute("error", "The reset link is invalid or has expired.");
            return "reset-password";
        }
    }
    
    @PostMapping("/profile/upload-avatar")
    public String handleAvatarUpload(@RequestParam("avatarFile") MultipartFile file,
                                     HttpSession session,
                                     HttpServletRequest request,
                                     RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (!file.isEmpty()) {
            try {
                String uploadDir = "C:/my_project_uploads/";
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                // ပုံဟောင်းရှိနေလျှင် ဖျက်ထုတ်ခြင်း
                String oldAvatarName = currentUser.getAvatarPath();
                if (oldAvatarName != null && !oldAvatarName.isEmpty()) {
                    File oldFile = new File(dir.getAbsolutePath() + File.separator + oldAvatarName);
                    if (oldFile.exists()) {
                        oldFile.delete(); 
                    }
                }

                // UUID ဖြင့် နာမည်အသစ်ပြောင်းခြင်း
                String originalFilename = file.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString() + extension;

                // ပုံအသစ်သိမ်းဆည်းခြင်း
                File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
                file.transferTo(serverFile);

                // Database နှင့် Session update လုပ်ခြင်း
                currentUser.setAvatarPath(newFileName);
                userService.updateUser(currentUser);
                session.setAttribute("currentUser", currentUser);

                redirectAttributes.addFlashAttribute("message", "Profile picture updated successfully!");
                return "redirect:/profile";

            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("error", "Failed to upload image: " + e.getMessage());
                return "redirect:/profile";
            }
        }

        redirectAttributes.addFlashAttribute("error", "Please select a valid file to upload.");
        return "redirect:/profile";
    }
    
    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam("fullName") String fullName,
                                @RequestParam("email") String email,
                                @RequestParam("bio") String bio,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setBio(bio);

            userService.updateUser(currentUser);
            session.setAttribute("currentUser", currentUser);

            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        
        return "redirect:/profile";
    }
}