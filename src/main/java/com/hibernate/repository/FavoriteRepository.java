package com.hibernate.repository;

import com.hibernate.entity.FavoriteEntity;

public interface FavoriteRepository {
    Integer insertFavorite(FavoriteEntity obj);
    void deleteFavorite(FavoriteEntity obj);
    FavoriteEntity getByUserIdAndSheetId(Integer userId, Integer cheatSheetId);
}