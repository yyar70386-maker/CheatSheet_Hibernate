package com.hibernate.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.hibernate.entity.User;
import com.hibernate.service.RatingService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/rating")
@RequiredArgsConstructor
public class RatingController {

    private final RatingService ratingService;

    @PostMapping(value = "/submit", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String submitRating(@RequestParam Integer cheatSheetId, @RequestParam Integer stars, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "{\"error\":\"login_required\"}";
        }
        String message = ratingService.submitRating(currentUser.getId(), cheatSheetId, stars);
        Double average = ratingService.getAverageRatingBySheetId(cheatSheetId);
        return "{\"message\":\"" + message + "\",\"average\":" + average + "}";
    }
}
