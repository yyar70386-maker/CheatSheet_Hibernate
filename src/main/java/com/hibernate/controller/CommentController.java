package com.hibernate.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.CommentServiceImpl;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentServiceImpl commentService;

    // ✅ Comment သို့မဟုတ် Reply တင်ရန်
    // Reply အတွက်ဆိုလျှင် parentCommentId ကို ထည့်ပို့ပေးရမည်။ ရိုးရိုး Comment ဆိုလျှင် မထည့်ဘဲထားလို့ရသည်။
    @PostMapping("/add")
    public ResponseEntity<String> addComment(
            @RequestParam Integer userId, 
            @RequestParam Integer cheatSheetId, 
            @RequestParam String content,
            @RequestParam(required = false) Integer parentCommentId) { 
        
        String result = commentService.addComment(userId, cheatSheetId, content, parentCommentId);
        return ResponseEntity.ok(result);
    }

    // ✅ Comment ကို Like လုပ်ရန် (isLike=true လို့ပို့ပေးပါ)
    @PostMapping("/react")
    public ResponseEntity<String> reactToComment(
            @RequestParam Integer userId, 
            @RequestParam Integer commentId, 
            @RequestParam Boolean isLike) {
        
        String result = commentService.reactToComment(userId, commentId, isLike);
        return ResponseEntity.ok(result);
    }
}