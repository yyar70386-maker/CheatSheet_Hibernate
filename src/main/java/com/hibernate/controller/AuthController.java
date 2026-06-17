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
                               HttpSession session, Model model) {
        User user = userService.authenticateByEmail(email, password);
        if (user != null) {
            // 🌟 Session Attribute Key ကို 'currentUser' အဖြစ် သတ်မှတ်သိမ်းဆည်းခြင်း
            session.setAttribute("currentUser", user);
            
            // 🚀 Login အောင်မြင်ပါက URL မှန်ကန်စေရန် /home သို့ Redirect လုပ်မည်
            return "redirect:/home";
        } else {
            model.addAttribute("error", "Invalid Email or Password!");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String handleLogout(HttpSession session) {
        // Session ထဲရှိ ဒေတာအားလုံးကို ဖျက်ထုတ်ပစ်ခြင်း
        session.invalidate(); 
        // အကောင့်ထွက်ပြီးနောက် Home Page သို့ ပြန်ပို့ခြင်း
        return "redirect:/"; 
    }
    // ✨ ၁။ HOME DASHBOARD MAPPING (ထည့်သွင်းပေးထားသော အပိုင်း)
    @GetMapping("/home")
    public String showHomeDashboard(HttpSession session) {
        // လုံခြုံရေးအရ Login ဝင်ထားခြင်း ရှိမရှိ အရင်စစ်ဆေးခြင်း
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login"; // Login မဝင်ရသေးပါက မောင်းထုတ်မည်
        }
        return "home"; // home.jsp ကို ပြသမည်
    }

    // ✨ ၂။ PROFILE MAPPING (တောင်းဆိုချက်အတိုင်း ပြင်ဆင်ပြီး)
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
    public String handleForgotPassword(@RequestParam("email") String email, HttpServletRequest request, Model model) {
        String contextPath = request.getRequestURL().toString().replace(request.getRequestURI(), request.getContextPath());
        
        boolean emailSent = userService.sendResetPasswordEmail(email, contextPath);
        if (emailSent) {
            model.addAttribute("message", "A password reset link has been sent to your email address.");
        } else {
            model.addAttribute("error", "No account found with this email address.");
        }
        return "forgot-password";
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
                // ၁။ ပုံသိမ်းမည့်ဆာဗာလမ်းကြောင်းရှာခြင်း (Tomcat ၏ webapps/[Project]/uploads)
                String uploadDir = request.getServletContext().getRealPath("/uploads");
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs(); // Folder မရှိသေးရင် ဆောက်ပေးခြင်း
                }

                // 🌟 [ဒီဇိုင်းကောင်းစေရန် ဖြည့်စွက်ချက်] ပုံဟောင်းရှိနေလျှင် ဆာဗာထဲမှ အရင်ဖျက်ထုတ်ပစ်ခြင်း
                String oldAvatarName = currentUser.getAvatarPath();
                if (oldAvatarName != null && !oldAvatarName.isEmpty()) {
                    File oldFile = new File(dir.getAbsolutePath() + File.separator + oldAvatarName);
                    if (oldFile.exists()) {
                        oldFile.delete(); // ပုံဟောင်းကို အလိုအလျောက် ဖျက်ပေးခြင်း
                    }
                }

                // ၂။ ဖိုင်နာမည်တူတာတွေ မထပ်သွားစေရန် UUID ဖြင့် နာမည်အသစ်ပြောင်းခြင်း
                String originalFilename = file.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString() + extension;

                // ၃။ ပုံအသစ်ကို သတ်မှတ်ထားသော Folder ထဲသို့ ရွှေ့ပြောင်းသိမ်းဆည်းခြင်း
                File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
                file.transferTo(serverFile);

                // ၄။ Database တွင် လမ်းကြောင်းသွားသိမ်းရန် Entity ထဲသို့ ထည့်ခြင်း
                currentUser.setAvatarPath(newFileName);
                
                // Database တွင် သွားရောက် Update လုပ်ခြင်း (merge သုံးထားသော မက်သတ်)
                userService.updateUser(currentUser);

                // ၅။ Session ထဲက User Data ကိုပါ နောက်ဆုံးပုံအသစ်ဖြင့် လဲလှယ်ပေးခြင်း
                session.setAttribute("currentUser", currentUser);

                // Flash Attribute ဖြင့် အောင်မြင်ကြောင်း Message ပြသရန် ပို့ပေးခြင်း
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