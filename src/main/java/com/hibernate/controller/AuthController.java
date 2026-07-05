package com.hibernate.controller;

import com.hibernate.entity.SharedCheatsheetEntity;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;
import com.hibernate.service.CategoryService;
import com.hibernate.service.AnnouncementService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.UserFollowService;
import com.hibernate.service.TagService;
import com.hibernate.service.UserService;
//import com.hibernate.websocket.NotificationSocketService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
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
    private UserFollowService userFollowService;
    
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
        
        // Active ဖြစ်နေတဲ့ Category list ကိုသာ ဆွဲထုတ်ပြသခြင်း
        model.addAttribute("categorylist", categoryService.findAllActive());
        model.addAttribute("announcements", announcementService.findLatest(3));
        model.addAttribute("cheatsheetlist", cheatsheetService.findLatestPublic(query, page, pageSize));
        model.addAttribute("searchQuery", query);
        model.addAttribute("currentPage", page);
        
        model.addAttribute("sharedPosts", sharedCheatsheetRepository.findAllSharedWithDetails());
        
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

//    @GetMapping("/profile")
//    public String showProfile(HttpSession session, Model model) {
//        User currentUser = (User) session.getAttribute("currentUser");
//        if (currentUser == null) {
//            return "redirect:/login";
//        }
//
//        User user = userService.findById(currentUser.getId());
//        model.addAttribute("user", user);
//        model.addAttribute("targetUser", user); 
//
//        model.addAttribute("followersCount", userFollowService.getFollowersCount(user.getId()));
//        model.addAttribute("followingCount", userFollowService.getFollowingCount(user.getId()));
//
//        List<CheatsheetEntity> myCheatSheets = cheatsheetService.findByUserId(user.getId());
//        
//        model.addAttribute("cheatSheetsList", myCheatSheets);
//        model.addAttribute("cheatsheetlist", myCheatSheets);
//
//        return "profile"; 
//    }
    
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
//        notificationSocketService.broadcastToUser(id, notification);
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