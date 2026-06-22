package com.hibernate.service;

import javax.transaction.Transactional;
import org.springframework.stereotype.Service;
import com.hibernate.entity.RatingEntity;
import com.hibernate.entity.User; // Ko Htun Hla's Class

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.repository.RatingRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RatingServiceImpl implements RatingService {

    private final RatingRepository ratingRepo;
	
    @Transactional
    @Override
    public String submitRating(Integer userId, Integer cheatSheetId, Integer stars) {
        
        // ကြယ်အရေအတွက် ၁ ကနေ ၅ ကြားပဲ ဖြစ်ရမယ်လို့ စစ်ဆေးခြင်း
        if (stars < 1 || stars > 5) {
            return "Invalid rating. Stars must be between 1 and 5.";
        }

        RatingEntity existingRating = ratingRepo.getByUserAndSheetId(userId, cheatSheetId);
		
        if (existingRating != null) {
            // အရင်က Rating ပေးထားပြီးသားဆိုရင် Star အရေအတွက်ကို Update ပဲ လုပ်မယ်
            existingRating.setStars(stars);
            ratingRepo.updateRating(existingRating);
            return "Rating updated successfully.";
        } else {
            // အရင်က မပေးရသေးရင် အသစ်ထည့်မယ်
            RatingEntity newRating = new RatingEntity();
            newRating.setStars(stars);
            
            // ID ကနေတစ်ဆင့် Object တွေ တည်ဆောက်ပြီး Set လုပ်ခြင်း
            User user = new User();
            user.setId(userId);
            
            CheatsheetEntity sheet = new CheatsheetEntity();
            sheet.setId(cheatSheetId);
            
            newRating.setUser(user);
            newRating.setCheatSheet(sheet);
            
            ratingRepo.insertRating(newRating);
            return "Rating submitted successfully.";
        }
    }
}