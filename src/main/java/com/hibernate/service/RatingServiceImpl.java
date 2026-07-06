package com.hibernate.service;

import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.*;
import com.hibernate.repository.RatingRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RatingServiceImpl implements RatingService {
    private final RatingRepository ratingRepo;
    
    @Transactional
    @Override
    public String submitRating(Integer userId, Integer cheatSheetId, Integer stars) {
        RatingEntity existing = ratingRepo.getByUserAndSheetId(userId, cheatSheetId);
        
        if (existing != null) {
            // 🌟 ရှိပြီးသား Star ကိုပဲ ပြန်နှိပ်ရင် Rating ကို ဖျက်ပေးမည် (Undo)
            if (existing.getStars().equals(stars)) {
                ratingRepo.deleteRating(existing);
                return "Rating removed successfully.";
            } else {
                existing.setStars(stars);
                ratingRepo.updateRating(existing);
                return "Rating updated successfully.";
            }
        } else {
            RatingEntity newRating = new RatingEntity();
            newRating.setStars(stars);
            User user = new User(); user.setId(userId);
            CheatsheetEntity sheet = new CheatsheetEntity(); sheet.setId(cheatSheetId);
            newRating.setUser(user); newRating.setCheatSheet(sheet);
            ratingRepo.insertRating(newRating);
            return "Rating submitted successfully.";
        }
    }

    @Transactional
    @Override
    public RatingEntity getByUserAndSheetId(Integer userId, Integer cheatSheetId) {
        return ratingRepo.getByUserAndSheetId(userId, cheatSheetId);
    }

    @Transactional
    @Override
    public Double getAverageRatingBySheetId(Integer sheetId) {
        return ratingRepo.getAverageRatingBySheetId(sheetId);
    }
}