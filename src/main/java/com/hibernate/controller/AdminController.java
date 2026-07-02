package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import com.hibernate.service.CheatsheetService;
import com.hibernate.service.InteractionServiceImpl;
import com.hibernate.service.NotificationService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

    private final CheatsheetService cheatsheetService;
    private final InteractionServiceImpl interactionService;
    private final NotificationService notificationService;

    @GetMapping("/dashboard")
    public ModelAndView dashboard(@RequestParam(required = false, defaultValue = "newest") String sheetFilter,
                                  @RequestParam(required = false, defaultValue = "newest") String commentFilter) {
        ModelAndView mv = new ModelAndView("admin-dashboard");
        
        mv.addObject("cheatsheets", cheatsheetService.findAllAdmin(sheetFilter));
        mv.addObject("comments", interactionService.findAllAdmin(commentFilter));
        
        mv.addObject("currentSheetFilter", sheetFilter);
        mv.addObject("currentCommentFilter", commentFilter);
        return mv;
    }

    @PostMapping("/cheatsheet/action")
    public String handleSheetAction(@RequestParam Integer sheetId, @RequestParam String action, @RequestParam String reason) {
        cheatsheetService.banCheatsheet(sheetId, reason); 
        notificationService.send(sheetId, reason);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/comment/action")
    public String handleCommentAction(@RequestParam Integer commentId, @RequestParam String action, @RequestParam String reason) {
        interactionService.deleteCommentAdmin(commentId);
        notificationService.sendCommentNotification(commentId, reason);
        return "redirect:/admin/dashboard";
    }
}