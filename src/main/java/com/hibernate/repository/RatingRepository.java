package com.hibernate.repository;

import com.hibernate.entity.RatingEntity;

public interface RatingRepository {
    public Integer insertRating(RatingEntity obj);
    public void updateRating(RatingEntity obj);
    
    // 🌟 Rating ပြန်ဖြုတ်ရန် ဖျက်မည့် Method အသစ်
    public void deleteRating(RatingEntity obj); 
    
    public RatingEntity getByUserAndSheetId(Integer userId, Integer cheatSheetId);
    public Double getAverageRatingBySheetId(Integer sheetId);
}