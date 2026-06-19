package com.hibernate.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.hibernate.service.RatingService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/ratings")
@RequiredArgsConstructor
public class RatingController {

    private final RatingService ratingService;

    // POST Request: /api/ratings/submit?userId=1&cheatSheetId=5&stars=4
    @PostMapping("/submit")
    public ResponseEntity<String> submitRating(
            @RequestParam Integer userId, 
            @RequestParam Integer cheatSheetId,
            @RequestParam Integer stars) {
        
        String resultMessage = ratingService.submitRating(userId, cheatSheetId, stars);
        return ResponseEntity.ok(resultMessage);
    }
}