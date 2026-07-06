package com.hibernate.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.transaction.annotation.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.hibernate.entity.User;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.SharedCheatsheetEntity;
import com.hibernate.service.UserService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.UserFollowService;
import com.hibernate.repository.SharedCheatsheetRepository;

@Controller
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private CheatsheetService cheatsheetService;

    @Autowired
    private UserFollowService userFollowService;

    @Autowired
    private SharedCheatsheetRepository sharedCheatsheetRepository;

    // 🌟 [CRITICAL UPDATE] URL ကို ပုံမှန်အတိုင်း "/profile" ဟုပြောင်းပြီး တစ်ခါတည်း ဒေတာအားလုံး ဆွဲထုတ်ပါမည်
    @GetMapping("/profile")
    @Transactional(readOnly = true)
    public String showProfilePage(HttpSession session, Model model) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // ၁။ User Details & Followers Counts များ ဆွဲထုတ်ခြင်း
        User user = userService.findById(currentUser.getId());
        model.addAttribute("user", user);
        model.addAttribute("targetUser", user); 
        model.addAttribute("followersCount", userFollowService.getFollowersCount(user.getId()));
        model.addAttribute("followingCount", userFollowService.getFollowingCount(user.getId()));

        // ၂။ မိမိကိုယ်တိုင် ရေးသားထုတ်ဝေထားသော Cheat Sheets များ ဆွဲထုတ်ခြင်း
        List<CheatsheetEntity> myCheatSheets = cheatsheetService.findByUserId(user.getId());
        model.addAttribute("cheatSheetsList", myCheatSheets);
        model.addAttribute("cheatsheetlist", myCheatSheets);

        // ၃။ မိမိမှတစ်ဆင့် ထပ်ဆင့် Share ထားသော Cheat Sheets များကို စစ်ထုတ်ဆွဲထုတ်ခြင်း
     // 🌟 ၃။ မိမိမှတစ်ဆင့် ထပ်ဆင့် Share ထားသော Cheat Sheets များကို Repository မှ တိုက်ရိုက်ဆွဲထုတ်ခြင်း
        try {
            // 💡 Java Stream Filter နေရာတွင် ဤသို့ ပြောင်းလဲခေါ်ယူလိုက်ပါ
            List<SharedCheatsheetEntity> mySharedList = sharedCheatsheetRepository.findMySharedWithDetails(user.getId());

            // JSP ဘက်သို့ ဒေတာ ထည့်သွင်းပေးပို့ခြင်း
            model.addAttribute("sharedCheatSheetsList", mySharedList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // forward ခံနေစရာမလိုဘဲ တိုက်ရိုက် profile.jsp ကို လှမ်းဖွင့်ခိုင်းလိုက်ပါမည်
        return "profile";
    }

    @GetMapping("/profile/{id}")
    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public String showUserProfilePage(@PathVariable("id") String encodedId, HttpSession session, Model model) {
        Integer userId = com.hibernate.util.IdObfuscator.decode(encodedId);
        if (userId == null) {
            try {
                userId = Integer.parseInt(encodedId);
            } catch (NumberFormatException e) {
                return "redirect:/home";
            }
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getId().equals(userId)) {
            return "redirect:/profile";
        }

        User targetUser = userService.findById(userId);
        if (targetUser == null) {
            return "redirect:/home";
        }

        model.addAttribute("user", currentUser);
        model.addAttribute("targetUser", targetUser); 
        model.addAttribute("followersCount", userFollowService.getFollowersCount(userId));
        model.addAttribute("followingCount", userFollowService.getFollowingCount(userId));

        List<String> visibilities = new java.util.ArrayList<>();
        visibilities.add("PUBLIC");
        if (currentUser != null && userFollowService.isFollowing(currentUser.getId(), userId)) {
            visibilities.add("FRIEND-ONLY");
        }
        List<CheatsheetEntity> targetCheatSheets = cheatsheetService.findByUserIdAndVisibility(userId, visibilities);
        model.addAttribute("cheatSheetsList", targetCheatSheets);
        model.addAttribute("cheatsheetlist", targetCheatSheets);

        try {
            List<SharedCheatsheetEntity> sharedList = sharedCheatsheetRepository.findMySharedWithDetails(userId);
            model.addAttribute("sharedCheatSheetsList", sharedList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "user-profile";
    }

    @org.springframework.web.bind.annotation.PostMapping("/profile/change-password")
    public String changePassword(
            @org.springframework.web.bind.annotation.RequestParam("oldPassword") String oldPassword,
            @org.springframework.web.bind.annotation.RequestParam("newPassword") String newPassword,
            @org.springframework.web.bind.annotation.RequestParam("confirmNewPassword") String confirmNewPassword,
            HttpSession session,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // Validate formats backend-side
        if (newPassword.length() < 6 || !newPassword.matches("^[a-zA-Z0-9]+$")) {
            redirectAttributes.addFlashAttribute("error", "New password must be at least 6 characters and alphanumeric only.");
            return "redirect:/profile?tab=security";
        }

        if (newPassword.equals(oldPassword)) {
            redirectAttributes.addFlashAttribute("error", "New password cannot be the same as old password.");
            return "redirect:/profile?tab=security";
        }

        if (!newPassword.equals(confirmNewPassword)) {
            redirectAttributes.addFlashAttribute("error", "Confirm password does not match new password.");
            return "redirect:/profile?tab=security";
        }

        boolean success = userService.changePassword(currentUser.getId(), oldPassword, newPassword);
        if (success) {
            redirectAttributes.addFlashAttribute("message", "Password updated successfully.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Incorrect current password.");
        }
        return "redirect:/profile?tab=security";
    }

    @org.springframework.web.bind.annotation.PostMapping("/profile/update")
    public String updateProfile(
            @org.springframework.web.bind.annotation.RequestParam("fullName") String fullName,
            @org.springframework.web.bind.annotation.RequestParam("email") String email,
            @org.springframework.web.bind.annotation.RequestParam(value = "bio", required = false) String bio,
            HttpSession session,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        try {
            User user = userService.findById(currentUser.getId());
            if (user != null) {
                user.setFullName(fullName);
                user.setEmail(email);
                user.setBio(bio);
                userService.updateUser(user);
                
                // Update session user
                currentUser.setFullName(fullName);
                currentUser.setEmail(email);
                currentUser.setBio(bio);
                session.setAttribute("currentUser", currentUser);
                
                redirectAttributes.addFlashAttribute("message", "Profile details updated successfully.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Failed to update profile: " + e.getMessage());
        }
        
        return "redirect:/profile";
    }

    @org.springframework.web.bind.annotation.PostMapping("/profile/upload-avatar")
    public String uploadAvatar(
            @org.springframework.web.bind.annotation.RequestParam("avatarFile") org.springframework.web.multipart.MultipartFile avatarFile,
            HttpSession session,
            org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (avatarFile != null && !avatarFile.isEmpty()) {
            try {
                String uploadDir = "C:/my_project_uploads/";
                java.io.File dir = new java.io.File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }
                String orgName = avatarFile.getOriginalFilename();
                String ext = "";
                if (orgName != null && orgName.contains(".")) {
                    ext = orgName.substring(orgName.lastIndexOf("."));
                }
                String newName = java.util.UUID.randomUUID().toString() + ext;
                java.io.File dest = new java.io.File(dir, newName);
                avatarFile.transferTo(dest);

                User user = userService.findById(currentUser.getId());
                if (user != null) {
                    user.setAvatarPath(newName);
                    userService.updateUser(user);
                    
                    // Update session user
                    currentUser.setAvatarPath(newName);
                    session.setAttribute("currentUser", currentUser);
                    
                    redirectAttributes.addFlashAttribute("message", "Profile picture updated successfully.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("error", "Failed to upload avatar: " + e.getMessage());
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Please select a file to upload.");
        }
        
        return "redirect:/profile";
    }

    @GetMapping("/profile/avatar/{filename:.+}")
    @org.springframework.web.bind.annotation.ResponseBody
    public org.springframework.http.ResponseEntity<org.springframework.core.io.Resource> getAvatar(@PathVariable String filename) {
        try {
            java.nio.file.Path filePath = java.nio.file.Paths.get("C:/my_project_uploads/").resolve(filename).normalize();
            org.springframework.core.io.Resource resource = new org.springframework.core.io.UrlResource(filePath.toUri());
            if (resource.exists()) {
                String contentType = "image/jpeg";
                if (filename.toLowerCase().endsWith(".png")) {
                    contentType = "image/png";
                } else if (filename.toLowerCase().endsWith(".gif")) {
                    contentType = "image/gif";
                } else if (filename.toLowerCase().endsWith(".webp")) {
                    contentType = "image/webp";
                }
                return org.springframework.http.ResponseEntity.ok()
                        .contentType(org.springframework.http.MediaType.parseMediaType(contentType))
                        .body(resource);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return org.springframework.http.ResponseEntity.notFound().build();
    }
}