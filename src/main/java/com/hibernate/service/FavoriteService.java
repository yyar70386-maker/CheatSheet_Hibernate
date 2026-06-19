package com.hibernate.service;

public interface FavoriteService {
    String toggleFavorite(Integer userId, Integer cheatSheetId);
}