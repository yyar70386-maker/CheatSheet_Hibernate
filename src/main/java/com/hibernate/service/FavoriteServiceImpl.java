package com.hibernate.service;

import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.FavoriteEntity;
import com.hibernate.entity.User;
import com.hibernate.entity.CheatSheetEntity;
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
            // ရှိပြီးသားဖြစ်နေရင် Remove Favorite လုပ်မယ်
            favoriteRepo.deleteFavorite(existingFav);
            return "Successfully removed from favorites.";
        } else {
            // မရှိသေးရင် Add Favorite လုပ်မယ်
            FavoriteEntity newFav = new FavoriteEntity();
            
            User user = new User(); 
            user.setId(userId);
            
            CheatSheetEntity sheet = new CheatSheetEntity(); 
            sheet.setId(cheatSheetId);
            
            newFav.setUser(user); 
            newFav.setCheatSheet(sheet);
            
            favoriteRepo.insertFavorite(newFav);
            return "Successfully added to favorites.";
        }
    }
}