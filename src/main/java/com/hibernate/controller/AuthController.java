package com.hibernate.controller;

import com.hibernate.entity.User;
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
    
        @GetMapping("/")
        public String showHomePage(HttpSession session) {
            // Run လိုက်တာနဲ့ views/index.jsp (သို့မဟုတ် home.jsp) ဆီသို့ တန်းပို့ပေးမည်
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
            // (Username တူရင် 'Username is already taken!', Email တူရင် 'Email is already registered!' ဟု အတိအကျပြပါမည်)
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
                               RedirectAttributes redirectAttributes) { // 🌟 Model နေရာမှာ RedirectAttributes ပြောင်းသုံးပါမယ်
        
        User user = userService.authenticateByEmail(email, password);
       
        if (user != null) {
            session.setAttribute("currentUser", user);
            return "redirect:/home";
        } else {
            // 🌟 addFlashAttribute ကို သုံးလိုက်ရင် Redirect ဖြစ်သွားရင်တောင် ဒေတာ လုံးဝ မပျောက်တော့ပါဘူး
            redirectAttributes.addFlashAttribute("loginError", "Invalid Email or Password!");
            
            // 🚀 လော့ဂ်အင်ပေ့ချ်ဆီ အသေအချာ ပြန်မောင်းနှင်လိုက်ပါတယ်
            return "redirect:/login"; 
        }
    }
    
    @GetMapping("/logout")
    public String handleLogout(HttpSession session) {
        // Session ထဲရှိ ဒေတာအားလုံးကို ဖျက်ထုတ်ပစ်ခြင်း
        session.invalidate(); 
        // အကောင့်ထွက်ပြီးနောက် Home Page သို့ ပြန်ပို့ခြင်း
        return "redirect:/"; 
    }
   
    @GetMapping("/home")
    public String showHomeDashboard(HttpSession session) {
        // လုံခြုံရေးအရ Login ဝင်ထားခြင်း ရှိမရှိ အရင်စစ်ဆေးခြင်း
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login"; 
        }
        return "home"; // home.jsp ကို ပြသမည်
    }

    // ✨ ၂။ PROFILE MAPPING
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
            // အီးမေးလ်ပို့အောင်မြင်လျှင် ပြသမည့် Flash Message
            redirectAttributes.addFlashAttribute("successMessage", "A password reset link has been sent to your email address.");
        } else {
            // အီးမေးလ်မရှိလျှင် သို့မဟုတ် Error တက်လျှင် ပြသမည့် Flash Message
            redirectAttributes.addFlashAttribute("errorMessage", "No account found with this email address.");
        }
        
        // URL ကို /forgot-password ဆီသို့ Redirect ပြန်လှည့်ပေးခြင်း
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
        
        // 🌟 ဒီနေရာလေးကို အခုလို ပြင်လိုက်တာပါဗျာ (redirect: နေရာမှာ login လို့ပဲ တန်းခေါ်လိုက်တာ)
        if (result) {
            model.addAttribute("successMessage", "Password reset successfully! Please login with your new password.");
            return "login"; 
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
                    dir.mkdirs(); // Folder မရှိသေးရင် C:/ ထဲမှာ အလိုအလျောက် ဆောက်ပေးမည်
                }

                // ၂။ ပုံဟောင်းရှိနေလျှင် C:/my_project_uploads/ ထဲမှ ရှာပြီး အလိုအလျောက် ဖျက်ထုတ်ခြင်း
                String oldAvatarName = currentUser.getAvatarPath();
                if (oldAvatarName != null && !oldAvatarName.isEmpty()) {
                    File oldFile = new File(dir.getAbsolutePath() + File.separator + oldAvatarName);
                    if (oldFile.exists()) {
                        oldFile.delete(); 
                    }
                }

                // ၃။ ဖိုင်နာမည်တူတာတွေ မထပ်သွားစေရန် UUID ဖြင့် နာမည်အသစ်ပြောင်းခြင်း
                String originalFilename = file.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString() + extension;

                // ၄။ ပုံအသစ်ကို သတ်မှတ်ထားသော Folder ထဲသို့ ရွှေ့ပြောင်းသိမ်းဆည်းခြင်း
                File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
                file.transferTo(serverFile);

                // ၅။ Database တွင် လမ်းကြောင်းအသစ် သွားသိမ်းခြင်း
                currentUser.setAvatarPath(newFileName);
                userService.updateUser(currentUser);

                // ၆။ Session ထဲက User Data ကိုပါ နောက်ဆုံးပုံအသစ်ဖြင့် လဲလှယ်ပေးခြင်း
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
                                @RequestParam("bio") String bio, // Bio ပါတစ်ခါတည်း လက်ခံခြင်း
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            // ၁။ ဖောင်မှ ရလာသော အချက်အလက်အသစ်များကို လက်ရှိ User ထဲသို့ ထည့်ခြင်း
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setBio(bio);

            // ၂။ Database တွင် သွားရောက် Update လုပ်ခြင်း (စောစောက ပြင်ခဲ့သည့် merge သုံးထားသော method)
            userService.updateUser(currentUser);

            // ၃။ HTTP Session ကိုပါ နောက်ဆုံး ဒေတာအသစ်ဖြင့် အစားထိုးခြင်း
            session.setAttribute("currentUser", currentUser);

            // အောင်မြင်ကြောင်း Flash Message ပို့ခြင်း
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        
        return "redirect:/profile";
    }
 }