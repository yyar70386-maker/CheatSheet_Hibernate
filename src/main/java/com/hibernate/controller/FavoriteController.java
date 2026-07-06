package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.FavoriteService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/favorite")
@RequiredArgsConstructor
public class FavoriteController {
    private final FavoriteService favoriteService;

    @PostMapping("/toggle")
    @ResponseBody
    public String toggleFavorite(@RequestParam Integer userId, @RequestParam Integer cheatSheetId) {
        return favoriteService.toggleFavorite(userId, cheatSheetId);
    }
}