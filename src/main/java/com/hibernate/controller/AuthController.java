package com.hibernate.controller;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.User;
import com.hibernate.service.CategoryService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.UserFollowService;
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
import java.util.List;
import java.util.UUID;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private CategoryService categoryService; 
    
    @Autowired
    private UserFollowService userFollowService;
    
    @Autowired
    private CheatsheetService cheatsheetService;
    
    @GetMapping("/")
    public String showHomePage(HttpSession session, Model model) {
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
                               HttpSession session, 
                               RedirectAttributes redirectAttributes) { 
        User user = userService.authenticateByEmail(email, password);
        if (user != null) {
            session.setAttribute("currentUser", user);
            return "redirect:/home";
        } else {
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
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login"; 
        }
        model.addAttribute("categorylist", categoryService.findAll());
        return "home"; 
    }

    // 👤 မိမိကိုယ်ပိုင် Profile ကိုကြည့်ရှုခြင်း
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        User user = userService.findById(currentUser.getId());
        model.addAttribute("user", user);
        model.addAttribute("targetUser", user); 

        model.addAttribute("followersCount", userFollowService.getFollowersCount(user.getId()));
        model.addAttribute("followingCount", userFollowService.getFollowingCount(user.getId()));

        List<CheatsheetEntity> myCheatSheets = cheatsheetService.findByUserId(user.getId());
        
        // 🌟 [FIXED] JSP ထဲက အခေါ်အဝေါ် မလွဲစေရန် ကာကွယ်ရေးအနေဖြင့် နာမည်နှစ်မျိုးလုံးဖြင့် ပို့ပေးလိုက်ပါသည်
        model.addAttribute("cheatSheetsList", myCheatSheets);
        model.addAttribute("cheatsheetlist", myCheatSheets);

        return "profile"; 
    }
    
    @GetMapping("/profile/show/followers")
    public String showMyFollowers(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        List<User> followersList = userFollowService.getFollowersUserList(currentUser.getId());
        model.addAttribute("pageTitle", "My Followers");
        model.addAttribute("userList", followersList);
        
        return "follow_list"; 
    }

    @GetMapping("/profile/show/following")
    public String showMyFollowing(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        List<User> followingList = userFollowService.getFollowingUserList(currentUser.getId());
        model.addAttribute("pageTitle", "Following Users");
        model.addAttribute("userList", followingList);
        
        return "follow_list"; 
    }
    
    // 🔍 တခြားသူ၏ Profile ကို သွားရောက်ကြည့်ရှုခြင်း
    @GetMapping("/profile/{id}")
    public String viewTargetProfile(@PathVariable Integer id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (currentUser.getId().equals(id)) {
            return "redirect:/profile";
        }

        User targetUser = userService.findById(id);
        if (targetUser == null) {
            return "redirect:/home"; 
        }

        model.addAttribute("targetUser", targetUser);
        model.addAttribute("followersCount", userFollowService.getFollowersCount(id));
        model.addAttribute("followingCount", userFollowService.getFollowingCount(id));
        
        boolean isFollowing = userFollowService.isFollowing(currentUser.getId(), id);
        model.addAttribute("isFollowing", isFollowing);

        List<CheatsheetEntity> targetUserCheatSheets = cheatsheetService.findByUserId(id); 
        
        // 🌟 [FIXED] user-profile.jsp ထဲတွင် ${cheatsheetlist} ဟု ရေးထားသောကြောင့် စာလုံးအသေးဖြင့် ကွက်တိ ပို့ပေးလိုက်ပါပြီ
        model.addAttribute("cheatsheetlist", targetUserCheatSheets);
        model.addAttribute("cheatSheetsList", targetUserCheatSheets); 

        return "user-profile"; 
    }
    
    @PostMapping("/follow/{id}")
    public String followUser(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        userFollowService.followUser(currentUser.getId(), id);
        return "redirect:/profile/" + id; 
    }

    @PostMapping("/unfollow/{id}")
    public String unfollowUser(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        userFollowService.unfollowUser(currentUser.getId(), id);
        return "redirect:/profile/" + id; 
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
                String oldAvatarName = currentUser.getAvatarPath();
                if (oldAvatarName != null && !oldAvatarName.isEmpty()) {
                    File oldFile = new File(dir.getAbsolutePath() + File.separator + oldAvatarName);
                    if (oldFile.exists()) {
                        oldFile.delete(); 
                    }
                }
                String originalFilename = file.getOriginalFilename();
                String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString() + extension;

                File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
                file.transferTo(serverFile);

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
    
    @GetMapping("/profile/avatar/{filename:.+}")
    @ResponseBody
    public org.springframework.core.io.Resource getAvatar(@PathVariable String filename) {
        return new org.springframework.core.io.FileSystemResource("C:/my_project_uploads/" + filename);
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