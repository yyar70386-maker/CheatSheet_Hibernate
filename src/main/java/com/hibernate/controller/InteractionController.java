package com.hibernate.controller;

import java.util.List;

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
import com.hibernate.repository.CheatsheetRepository;
import com.hibernate.repository.SharedCheatsheetRepository;
import com.hibernate.service.InteractionServiceImpl;
import com.hibernate.service.NotificationService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/interaction")
@RequiredArgsConstructor
public class InteractionController {
	@Autowired
	private final NotificationService notificationService;
    private final InteractionServiceImpl interactionService;
    private final SharedCheatsheetRepository sharedCheatsheetRepository;
    private final CheatsheetRepository cheatsheetRepository;
    private final com.hibernate.repository.NotificationRepository notificationRepository;
    @Autowired

    private final org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @PostMapping(value = "/comment", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String postComment(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam String content, @RequestParam(required = false) Integer parentCommentId) {
        Integer newCommentId = interactionService.addComment(userId, cheatSheetId, content, parentCommentId);
        // JSON format ဖြင့် ကိုယ်တိုင်ရေး၍ ပြန်ပို့မည်
        return "{\"id\": " + newCommentId + "}";
    }

    @PostMapping(value = "/react-sheet", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String reactSheet(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam Boolean isLike) {
        interactionService.likeCheatSheet(userId, cheatSheetId, isLike);
        Long likes = interactionService.countSheetReactions(cheatSheetId, true);
        Long dislikes = interactionService.countSheetReactions(cheatSheetId, false);
        // JSON format ဖြင့် ပြန်ပို့မည်
        return "{\"likes\": " + (likes != null ? likes : 0) + ", \"dislikes\": " + (dislikes != null ? dislikes : 0) + "}";
    }

    @PostMapping(value = "/react-comment", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String reactComment(@RequestParam Integer userId, @RequestParam Integer commentId, @RequestParam Boolean isLike) {
        interactionService.likeComment(userId, commentId, isLike);
        Long likes = interactionService.countCommentReactions(commentId, true);
        Long dislikes = interactionService.countCommentReactions(commentId, false);
        // JSON format ဖြင့် ပြန်ပို့မည်
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
            
            // 2. Cheatsheet Count Update လုပ်ခြင်း
            CheatsheetEntity originalCheatsheet = cheatsheetRepository.findById(cheatSheetId);
            int currentShareCount = (originalCheatsheet.getShareCount() != null) ? originalCheatsheet.getShareCount() : 0;
            originalCheatsheet.setShareCount(currentShareCount + 1);
            cheatsheetRepository.update(originalCheatsheet);
            
            // 3. Notification ပို့ခြင်းနှင့် Database ထဲသိမ်းခြင်း
            if (originalCheatsheet.getAuthor() != null && 
                !originalCheatsheet.getAuthor().getId().equals(currentUser.getId())) {
                
                // --- Database ထဲ သိမ်းရန် Entity အသစ်ဆောက်ပါ ---
                com.hibernate.entity.NotificationEntity notification = new com.hibernate.entity.NotificationEntity();
                notification.setMessage(currentUser.getFullName() + " shared your cheatsheet: \"" + originalCheatsheet.getTitle() + "\"");
                notification.setNotificationType("SHARE");
                notification.setLinkUrl("/cheatsheet/detail/" + originalCheatsheet.getId());
                notification.setIsRead(false);
                notification.setSender(currentUser);
                notification.setUser(originalCheatsheet.getAuthor());
                notification.setCreatedAt(java.time.LocalDateTime.now());
                
                // Database ထဲသို့ Save လုပ်ပါ (အရေးကြီးဆုံးအချက်)
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
            // အမှားဖြစ်ပါက Console တွင် ကြည့်ရှုနိုင်ရန်
            e.printStackTrace(); 
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("{\"message\":\"Server error occurred: " + e.getMessage() + "\"}");
        }
    }

    // 🌟 2. SHARED FEED: Share ထားသမျှအားလုံးကို Repository မှတစ်ဆင့် တိုက်ရိုက်ပြန်ထုတ်ယူခြင်း
    @GetMapping("/shared-feed")
    public ModelAndView viewSharedFeed(HttpSession session) {
        
        if (session.getAttribute("currentUser") == null) {
            return new ModelAndView("redirect:/login");
        }

        // Repository ထဲက findAllSharedWithDetails() ကို တိုက်ရိုက် လှမ်းခေါ်ထုတ်ခြင်း
        List<SharedCheatsheetEntity> sharedList = sharedCheatsheetRepository.findAllSharedWithDetails();

        ModelAndView mv = new ModelAndView("shared-feed");
        mv.addObject("sharedPosts", sharedList);
        return mv;
    }
    
    
}