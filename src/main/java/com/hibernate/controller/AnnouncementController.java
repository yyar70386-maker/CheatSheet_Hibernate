package com.hibernate.controller;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.AnnouncementEntity;
import com.hibernate.entity.User;
import com.hibernate.service.AnnouncementService;
import com.hibernate.service.NotificationService; // 🌟 Import ထည့်သွင်းပေးထားပါသည်
import com.hibernate.websocket.NotificationSocketService; // 🌟 Import ထည့်သွင်းပေးထားပါသည်

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementService announcementService;
    private final NotificationService notificationService; // 🌟 [FIXED] မေ့ကျန်ခဲ့သော Service အား ထည့်သွင်းပေးခဲ့သည်။
    private final NotificationSocketService notificationSocketService; // 🌟 [FIXED] Comment ပိတ်ထားရာမှ ပြန်ဖွင့်ပေးခဲ့သည်။

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/announcements")
    public String viewAnnouncements(Model model) {
        model.addAttribute("announcements", announcementService.findAllActive());
        return "announcement-list";
    }

    @GetMapping("/admin/announcements")
    public String adminList(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        model.addAttribute("announcements", announcementService.findAll());
        model.addAttribute("announcement", new AnnouncementEntity());
        return "announcement-list";
    }

    @GetMapping("/admin/announcements/add")
    public String addForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        model.addAttribute("announcement", new AnnouncementEntity());
        return "announcement-edit";
    }

    @PostMapping("/admin/announcements/save")
    public String save(@ModelAttribute("announcement") AnnouncementEntity announcement, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }

        // Announcement အား Database ထဲသို့ အရင်သိမ်းဆည်းပါသည်
        announcementService.save(announcement, currentUser);
        
        // 🌟 [FIXED] တိုက်ရိုက် Save လုပ်ချိန်တွင်လည်း Real-time Notification ပို့ပေးနိုင်ရန် Comment ပြန်ဖွင့်ပေးခဲ့သည်။
        // မှတ်ချက်- announcement.getId() အဆင်ပြေစေရန် Service ဘက်မှ Save ပြီးလျှင် ID ပြန်ထွက်လာဖို့ လိုအပ်ပါသည်။
        if (announcement.getId() != null) {
            List<NotificationDto> notifications = notificationService.createAnnouncementNotifications(
                    currentUser.getId(), announcement.getId(), announcement.getTitle());
            notificationSocketService.broadcastNotifications(notifications);
        }
        
        return "redirect:/admin/announcements";
    }

    @GetMapping("/admin/announcements/edit/{id}")
    public String edit(@PathVariable Integer id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        model.addAttribute("announcement", announcementService.findById(id));
        return "announcement-edit";
    }

    @PostMapping("/admin/announcements/update")
    public String update(@ModelAttribute("announcement") AnnouncementEntity announcement, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        announcementService.update(announcement);
        return "redirect:/admin/announcements";
    }

    @PostMapping("/admin/announcements/delete/{id}")
    public String delete(@PathVariable Integer id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        announcementService.delete(id);
        return "redirect:/admin/announcements";
    }

    @PostMapping("/admin/announcements/{id}/status/{status}")
    public String status(@PathVariable Integer id, @PathVariable String status, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        announcementService.updateStatus(id, status, currentUser);
        if ("active".equalsIgnoreCase(status)) {
            AnnouncementEntity announcement = announcementService.findById(id);
            if (announcement != null) {
                // 🌟 အပေါ်တွင် `notificationService` နှင့် `notificationSocketService` အား Inject လုပ်ထားသဖြင့် ယခုနေရာတွင် Error တက်တော့မည်မဟုတ်ပါ။
                List<NotificationDto> notifications = notificationService.createAnnouncementNotifications(
                        currentUser.getId(), id, announcement.getTitle());
                notificationSocketService.broadcastNotifications(notifications);
            }
        }
        return "redirect:/admin/announcements";
    }
}