package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.InteractionServiceImpl;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/interaction")
@RequiredArgsConstructor
public class InteractionController {

    private final InteractionServiceImpl interactionService;

    @PostMapping(value = "/comment", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String postComment(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam String content, @RequestParam(required = false) Integer parentCommentId) {
        Integer newCommentId = interactionService.addComment(userId, cheatSheetId, content, parentCommentId);
        return "{\"id\": " + newCommentId + "}";
    }

    @PostMapping(value = "/react-sheet", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String reactSheet(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam Boolean isLike) {
        interactionService.likeCheatSheet(userId, cheatSheetId, isLike);
        Long likes = interactionService.countSheetReactions(cheatSheetId, true);
        Long dislikes = interactionService.countSheetReactions(cheatSheetId, false);
        return "{\"likes\": " + (likes != null ? likes : 0) + ", \"dislikes\": " + (dislikes != null ? dislikes : 0) + "}";
    }

    @PostMapping(value = "/react-comment", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String reactComment(@RequestParam Integer userId, @RequestParam Integer commentId, @RequestParam Boolean isLike) {
        interactionService.likeComment(userId, commentId, isLike);
        Long likes = interactionService.countCommentReactions(commentId, true);
        Long dislikes = interactionService.countCommentReactions(commentId, false);
        return "{\"likes\": " + (likes != null ? likes : 0) + ", \"dislikes\": " + (dislikes != null ? dislikes : 0) + "}";
    }

    // 🌟 Comment Edit (AJAX)
    @PostMapping(value = "/comment/edit", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String editComment(@RequestParam Integer userId, @RequestParam Integer commentId, @RequestParam String newContent) {
        boolean success = interactionService.editComment(commentId, userId, newContent);
        return "{\"success\": " + success + "}";
    }

    // 🌟 Comment Delete (AJAX)
    @PostMapping(value = "/comment/delete", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String deleteComment(@RequestParam Integer userId, @RequestParam Integer commentId) {
        boolean success = interactionService.deleteComment(commentId, userId);
        return "{\"success\": " + success + "}";
    }
}