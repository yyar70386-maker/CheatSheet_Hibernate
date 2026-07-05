package com.hibernate.controller;

import java.util.List;
import javax.servlet.http.HttpSession;
import org.springframework.transaction.annotation.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.hibernate.entity.User;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.SharedCheatsheetEntity;
import com.hibernate.service.UserService;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.UserFollowService;
import com.hibernate.repository.SharedCheatsheetRepository;

@Controller
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private CheatsheetService cheatsheetService;

    @Autowired
    private UserFollowService userFollowService;

    @Autowired
    private SharedCheatsheetRepository sharedCheatsheetRepository;

    // 🌟 [CRITICAL UPDATE] URL ကို ပုံမှန်အတိုင်း "/profile" ဟုပြောင်းပြီး တစ်ခါတည်း ဒေတာအားလုံး ဆွဲထုတ်ပါမည်
    @GetMapping("/profile")
    @Transactional(readOnly = true)
    public String showProfilePage(HttpSession session, Model model) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        // ၁။ User Details & Followers Counts များ ဆွဲထုတ်ခြင်း
        User user = userService.findById(currentUser.getId());
        model.addAttribute("user", user);
        model.addAttribute("targetUser", user); 
        model.addAttribute("followersCount", userFollowService.getFollowersCount(user.getId()));
        model.addAttribute("followingCount", userFollowService.getFollowingCount(user.getId()));

        // ၂။ မိမိကိုယ်တိုင် ရေးသားထုတ်ဝေထားသော Cheat Sheets များ ဆွဲထုတ်ခြင်း
        List<CheatsheetEntity> myCheatSheets = cheatsheetService.findByUserId(user.getId());
        model.addAttribute("cheatSheetsList", myCheatSheets);
        model.addAttribute("cheatsheetlist", myCheatSheets);

        // ၃။ မိမိမှတစ်ဆင့် ထပ်ဆင့် Share ထားသော Cheat Sheets များကို စစ်ထုတ်ဆွဲထုတ်ခြင်း
     // 🌟 ၃။ မိမိမှတစ်ဆင့် ထပ်ဆင့် Share ထားသော Cheat Sheets များကို Repository မှ တိုက်ရိုက်ဆွဲထုတ်ခြင်း
        try {
            // 💡 Java Stream Filter နေရာတွင် ဤသို့ ပြောင်းလဲခေါ်ယူလိုက်ပါ
            List<SharedCheatsheetEntity> mySharedList = sharedCheatsheetRepository.findMySharedWithDetails(user.getId());

            // JSP ဘက်သို့ ဒေတာ ထည့်သွင်းပေးပို့ခြင်း
            model.addAttribute("sharedCheatSheetsList", mySharedList);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // forward ခံနေစရာမလိုဘဲ တိုက်ရိုက် profile.jsp ကို လှမ်းဖွင့်ခိုင်းလိုက်ပါမည်
        return "profile";
    }
}