package com.hibernate.service;

import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.FavoriteEntity;
import com.hibernate.entity.User;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.repository.FavoriteRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FavoriteServiceImpl implements FavoriteService {

    private final FavoriteRepository favoriteRepo;

    @Transactional
    @Override
    public String toggleFavorite(Integer userId, Integer cheatSheetId) {
        FavoriteEntity existingFav = favoriteRepo.getByUserIdAndSheetId(userId, cheatSheetId);
        
        if (existingFav != null) {
            favoriteRepo.deleteFavorite(existingFav);
            return "Successfully removed from favorites.";
        } else {
            FavoriteEntity newFav = new FavoriteEntity();
            
            User user = new User(); 
            user.setId(userId);
            
            CheatsheetEntity sheet = new CheatsheetEntity(); 
            sheet.setId(cheatSheetId);
            
            newFav.setUser(user); 
            newFav.setCheatSheet(sheet);
            
            favoriteRepo.insertFavorite(newFav);
            return "Successfully added to favorites.";
        }
    }

    @Transactional
    @Override
    public FavoriteEntity getByUserIdAndSheetId(Integer userId, Integer cheatSheetId) {
        return favoriteRepo.getByUserIdAndSheetId(userId, cheatSheetId);
    }
}