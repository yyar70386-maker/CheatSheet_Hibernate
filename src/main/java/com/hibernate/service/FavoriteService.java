package com.hibernate.service;

import com.hibernate.entity.FavoriteEntity;

public interface FavoriteService {
    String toggleFavorite(Integer userId, Integer cheatSheetId);
    FavoriteEntity getByUserIdAndSheetId(Integer userId, Integer cheatSheetId);
}