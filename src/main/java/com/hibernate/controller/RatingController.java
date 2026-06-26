package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.RatingService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/rating")
@RequiredArgsConstructor
public class RatingController {

    private final RatingService ratingService;

    @PostMapping("/submit")
    public String submitRating(@RequestParam Integer userId, @RequestParam Integer cheatSheetId, @RequestParam Integer stars) {
        ratingService.submitRating(userId, cheatSheetId, stars);
        return "redirect:/cheatsheet/detail/" + cheatSheetId;
    }
}