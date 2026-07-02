package com.hibernate.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.User;
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

    private final InteractionServiceImpl interactionService;
    private final CheatsheetService cheatsheetService;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;
    private final NotificationSocketService notificationSocketService;

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
}
