package com.hibernate.service;

import com.hibernate.entity.RatingEntity;

public interface RatingService {
    public String submitRating(Integer userId, Integer cheatSheetId, Integer stars);
    public Double getAverageRatingBySheetId(Integer sheetId);
    public RatingEntity getByUserAndSheetId(Integer userId, Integer cheatSheetId);
}