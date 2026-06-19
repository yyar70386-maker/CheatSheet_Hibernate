package com.hibernate.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.FavoriteService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    // ✅ Favorite Add သို့မဟုတ် Remove လုပ်ရန် (Toggle)
    @PostMapping("/toggle")
    public ResponseEntity<String> toggleFavorite(
            @RequestParam Integer userId, 
            @RequestParam Integer cheatSheetId) {
        
        String resultMessage = favoriteService.toggleFavorite(userId, cheatSheetId);
        return ResponseEntity.ok(resultMessage);
    }
}