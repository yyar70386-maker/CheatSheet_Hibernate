package com.hibernate.service;

public interface RatingService {
    // Rating အသစ်ပေးတာရော၊ အဟောင်းကို Update လုပ်တာရော တစ်ခါတည်း အလုပ်လုပ်ပေးမယ့် Method
    public String submitRating(Integer userId, Integer cheatSheetId, Integer stars);
}