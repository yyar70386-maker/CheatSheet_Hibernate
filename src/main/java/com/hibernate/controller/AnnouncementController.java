package com.hibernate.controller;



import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import com.hibernate.entity.AnnouncementEntity;
import com.hibernate.entity.User;
import com.hibernate.service.AnnouncementService;


import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AnnouncementController {

    private final AnnouncementService announcementService;
    
//    private final NotificationSocketService notificationSocketService;

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

            announcementService.save(announcement, currentUser);
//   List<NotificationDto> notifications = notificationService.createAnnouncementNotifications(
//                currentUser.getId(), id, announcement.getTitle());
//     notificationSocketService.broadcastNotifications(notifications);
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
                List<NotificationDto> notifications = notificationService.createAnnouncementNotifications(
                        currentUser.getId(), id, announcement.getTitle());
                notificationSocketService.broadcastNotifications(notifications);
            }
        }
        return "redirect:/admin/announcements";
    }
}
