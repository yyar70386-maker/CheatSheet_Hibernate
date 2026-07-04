package com.hibernate.controller;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.CategoryService;
import com.hibernate.service.AnnouncementService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.UserFollowService;
import com.hibernate.service.TagService;
import com.hibernate.service.UserService;
import com.hibernate.websocket.NotificationSocketService;

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
    private CheatsheetService cheatsheetService;

    @Autowired
    private TagService tagService;

    @Autowired
    private AnnouncementService announcementService;
    
    @Autowired
    private UserFollowService userFollowService;
    
    @Autowired
    private NotificationSocketService notificationSocketService;

    @Autowired
    private AuditLogService auditLogService;
    
    @GetMapping("/")
    public String showHomePage(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "q", defaultValue = "") String query,
            HttpSession session,
            Model model) {
        int pageSize = 6;
        
        // Active ဖြစ်နေတဲ့ Category list ကိုသာ ဆွဲထုတ်ပြသခြင်း
        model.addAttribute("categorylist", categoryService.findAllActive());
        model.addAttribute("announcements", announcementService.findLatest(3));
        model.addAttribute("cheatsheetlist", cheatsheetService.findLatestPublic(query, page, pageSize));
        model.addAttribute("searchQuery", query);
        model.addAttribute("currentPage", page);
        
        long total = cheatsheetService.countLatestPublic(query);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));
        
        // သူငယ်ချင်းဖြစ်သူ ထည့်သွင်းထားသော Total Count Metrics များ
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
        model.addAttribute("searchQuery", query);
        model.addAttribute("currentPage", page);
        
        long total = cheatsheetService.countLatestPublic(query);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / 6)));
        
        model.addAttribute("totalSheets", cheatsheetService.getTotalSheetsCount());
        model.addAttribute("totalTags", tagService.getTotalTagsCount());
        
        return "home";
    }

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
        model.addAttribute("profileUsers", userFollowService.getFollowersForView(currentUser.getId(), currentUser.getId()));
        model.addAttribute("listType", "followers");
        model.addAttribute("pageTitle", "My Followers");
        return "follow_list"; 
    }

    @GetMapping("/profile/show/following")
    public String showMyFollowing(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        model.addAttribute("profileUsers", userFollowService.getFollowingForView(currentUser.getId(), currentUser.getId()));
        model.addAttribute("listType", "following");
        model.addAttribute("pageTitle", "Following Users");
        return "follow_list"; 
    }
    
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
        model.addAttribute("mutualFollowersCount", userFollowService.countMutualFollowers(currentUser.getId(), id));
        
        boolean isFollowing = userFollowService.isFollowing(currentUser.getId(), id);
        model.addAttribute("isFollowing", isFollowing);

        List<CheatsheetEntity> targetUserCheatSheets = cheatsheetService.findByUserId(id); 
        
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
        NotificationDto notification = userFollowService.followUser(currentUser.getId(), id);
        notificationSocketService.broadcastToUser(id, notification);
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
