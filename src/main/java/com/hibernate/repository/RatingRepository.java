package com.hibernate.repository;

import com.hibernate.entity.RatingEntity;

public interface RatingRepository {
    public Integer insertRating(RatingEntity obj);
    public void updateRating(RatingEntity obj);
    // User တစ်ယောက်က CheatSheet တစ်ခုကို Rating ပေးပြီးသားလား စစ်ဖို့
    public RatingEntity getByUserAndSheetId(Integer userId, Integer cheatSheetId);
}