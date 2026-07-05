package com.hibernate.controller;

import java.util.List;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.SharedCheatsheetEntity;
import com.hibernate.entity.User;
import com.hibernate.entity.NotificationEntity;
import com.hibernate.repository.CheatsheetRepository;
import com.hibernate.repository.SharedCheatsheetRepository;
import com.hibernate.repository.NotificationRepository;
import com.hibernate.service.AuditLogService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.InteractionServiceImpl;
import com.hibernate.service.NotificationService;
import com.hibernate.websocket.NotificationSocketService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/interaction")
@RequiredArgsConstructor
public class InteractionController {

    private final NotificationService notificationService;
    private final InteractionServiceImpl interactionService;
    private final CheatsheetService cheatsheetService;
    private final AuditLogService auditLogService;
    private final NotificationSocketService notificationSocketService;
    
    private final SharedCheatsheetRepository sharedCheatsheetRepository;
    private final CheatsheetRepository cheatsheetRepository;
    private final NotificationRepository notificationRepository;
    private final org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @PostMapping(value = "/comment", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String postComment(
            @RequestParam Integer userId,
            @RequestParam Integer cheatSheetId,
            @RequestParam String content,
            @RequestParam(required = false) Integer parentCommentId,
            HttpServletRequest request,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "{\"error\":\"login_required\"}";
        }

        Integer newCommentId = interactionService.addComment(currentUser.getId(), cheatSheetId, content, parentCommentId);
        auditLogService.log(currentUser, parentCommentId == null ? "Comment Create" : "Reply Create", "Comment", newCommentId,
                "Comment added to cheatsheet #" + cheatSheetId, request.getRemoteAddr());

        CheatsheetEntity sheet = cheatsheetService.findById(cheatSheetId);
        if (sheet != null && sheet.getAuthor() != null && !sheet.getAuthor().getId().equals(currentUser.getId())) {
            NotificationDto notification = notificationService.createNotification(
                    sheet.getAuthor().getId(),
                    currentUser.getId(),
                    parentCommentId == null ? "New comment" : "New reply",
                    currentUser.getUsername() + " commented on your cheat sheet.",
                    parentCommentId == null ? "COMMENT" : "REPLY",
                    "/cheatsheet/detail/" + cheatSheetId);
            
            notificationSocketService.broadcastToUser(sheet.getAuthor().getId(), notification);
        }

        return "{\"id\": " + newCommentId + "}";
    }

    @PostMapping(value = "/react-sheet", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String reactSheet(
            @RequestParam Integer userId,
            @RequestParam Integer cheatSheetId,
            @RequestParam Boolean isLike,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "{\"error\":\"login_required\"}";
        }

        interactionService.likeCheatSheet(currentUser.getId(), cheatSheetId, isLike);
        Long likes = interactionService.countSheetReactions(cheatSheetId, true);
        Long dislikes = interactionService.countSheetReactions(cheatSheetId, false);
        return "{\"likes\": " + (likes != null ? likes : 0) + ", \"dislikes\": " + (dislikes != null ? dislikes : 0) + "}";
    }

    @PostMapping(value = "/react-comment", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String reactComment(
            @RequestParam Integer userId,
            @RequestParam Integer commentId,
            @RequestParam Boolean isLike,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "{\"error\":\"login_required\"}";
        }

        interactionService.likeComment(currentUser.getId(), commentId, isLike);
        Long likes = interactionService.countCommentReactions(commentId, true);
        Long dislikes = interactionService.countCommentReactions(commentId, false);
        return "{\"likes\": " + (likes != null ? likes : 0) + ", \"dislikes\": " + (dislikes != null ? dislikes : 0) + "}";
    }
    
    @Transactional
    @PostMapping(value = "/share-post", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<?> shareCheatsheet(@RequestParam Integer cheatSheetId, HttpSession session) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"message\":\"Please login first!\"}");
        }
        
        try {
            // အရင် Share ပြီးသားလား စစ်ဆေးခြင်း
            if (sharedCheatsheetRepository.isAlreadyShared(currentUser.getId(), cheatSheetId)) {
                return ResponseEntity.badRequest().body("{\"message\":\"You already shared this cheatsheet!\"}");
            }
            
            // 1. Shared Record သိမ်းခြင်း
            SharedCheatsheetEntity shared = new SharedCheatsheetEntity();
            User user = new User();
            user.setId(currentUser.getId());
            shared.setUser(user);
            CheatsheetEntity cheatsheet = new CheatsheetEntity();
            cheatsheet.setId(cheatSheetId);
            shared.setCheatsheet(cheatsheet);
            sharedCheatsheetRepository.save(shared);
            
            // 2. 🌟 [FIXED] Service ကို သုံးပြီး Entity ကို စိတ်ချရအောင် ဆွဲထုတ်ခြင်း (Error လုံးဝမတက်တော့ပါ)
            CheatsheetEntity originalCheatsheet = cheatsheetService.findById(cheatSheetId);
            if (originalCheatsheet == null) {
                return ResponseEntity.badRequest().body("{\"message\":\"Cheatsheet not found!\"}");
            }

            int currentShareCount = (originalCheatsheet.getShareCount() != null) ? originalCheatsheet.getShareCount() : 0;
            originalCheatsheet.setShareCount(currentShareCount + 1);
            cheatsheetRepository.update(originalCheatsheet);
            
            // 3. Notification ပို့ခြင်းနှင့် Database ထဲသိမ်းခြင်း
            if (originalCheatsheet.getAuthor() != null && 
                !originalCheatsheet.getAuthor().getId().equals(currentUser.getId())) {
                
                NotificationEntity notification = new NotificationEntity();
                notification.setMessage(currentUser.getFullName() + " shared your cheatsheet: \"" + originalCheatsheet.getTitle() + "\"");
                notification.setNotificationType("SHARE");
                notification.setLinkUrl("/cheatsheet/detail/" + originalCheatsheet.getId());
                notification.setIsRead(false);
                notification.setSender(currentUser);
                notification.setUser(originalCheatsheet.getAuthor());
                notification.setCreatedAt(java.time.LocalDateTime.now());
                
                // Database ထဲသို့ Save လုပ်ပါ
                notificationService.save(notification); 
                
                // --- WebSocket အတွက် DTO ပြင်ဆင်ပါ ---
                NotificationDto dto = new NotificationDto();
                dto.setMessage(notification.getMessage());
                dto.setNotificationType(notification.getNotificationType());
                dto.setLinkUrl(notification.getLinkUrl());
                dto.setSenderId(currentUser.getId());
                dto.setSenderName(currentUser.getFullName());
                dto.setUserId(originalCheatsheet.getAuthor().getId());
                dto.setIsRead(false);
                
                // လက်ရှိ မဖတ်ရသေးသောအရေအတွက်ကို တွက်ချက်ပို့ပေးပါ
                long unreadCount = notificationRepository.countUnreadByUserId(originalCheatsheet.getAuthor().getId());
                dto.setUnreadCount((int) unreadCount);
                
                messagingTemplate.convertAndSend("/topic/notifications/" + originalCheatsheet.getAuthor().getId(), dto);
            }
            
            return ResponseEntity.ok().body("{\"status\":\"success\"}");

        } catch (Exception e) {
            e.printStackTrace(); 
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("{\"message\":\"Server error occurred: " + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/shared-feed")
    public ModelAndView viewSharedFeed(HttpSession session) {
        if (session.getAttribute("currentUser") == null) {
            return new ModelAndView("redirect:/login");
        }

        List<SharedCheatsheetEntity> sharedList = sharedCheatsheetRepository.findAllSharedWithDetails();

        ModelAndView mv = new ModelAndView("shared-feed");
        mv.addObject("sharedPosts", sharedList);
        return mv;
    }
}