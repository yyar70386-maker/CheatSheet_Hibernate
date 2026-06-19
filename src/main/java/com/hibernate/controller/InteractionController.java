package com.hibernate.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.InteractionServiceImpl;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/interactions")
@RequiredArgsConstructor
public class InteractionController {

    private final InteractionServiceImpl interactionService;

    // ✅ Comment System
    @PostMapping("/comment")
    public ResponseEntity<String> addComment(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam String content) {
        return ResponseEntity.ok(interactionService.addComment(userId, cheatSheetId, content));
    }

    // ✅ Like CheatSheet (isLike = true/false)
    @PostMapping("/sheet-reaction")
    public ResponseEntity<String> likeCheatSheet(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam Boolean isLike) {
        return ResponseEntity.ok(interactionService.likeCheatSheet(userId, cheatSheetId, isLike));
    }

    // ✅ Like Comment (isLike = true/false)
    @PostMapping("/comment-reaction")
    public ResponseEntity<String> likeComment(@RequestParam Integer userId, @RequestParam Integer commentId, @RequestParam Boolean isLike) {
        return ResponseEntity.ok(interactionService.likeComment(userId, commentId, isLike));
    }
}