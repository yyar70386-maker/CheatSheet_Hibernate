package com.hibernate.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.hibernate.entity.User;
import com.hibernate.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class AdminUserController {

    private final UserService userService;

    private boolean isAdmin(User user) {
        return user != null && user.getRole() == 1;
    }

    @GetMapping("/admin/users")
    public String list(
            @RequestParam(value = "q", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "role", required = false, defaultValue = "") String role,
            @RequestParam(value = "status", required = false, defaultValue = "") String status,
            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
            HttpSession session,
            Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        
        int pageSize = 10;
        model.addAttribute("users", userService.search(keyword, role, status, page, pageSize));
        model.addAttribute("keyword", keyword);
        model.addAttribute("role", role);
        model.addAttribute("status", status);
        model.addAttribute("currentPage", page);
        
        long total = userService.countSearch(keyword, role, status);
        model.addAttribute("totalPages", Math.max(1, (int) Math.ceil((double) total / pageSize)));
        
        return "user-list";
    }

    @PostMapping("/admin/users/{id}/suspend")
    public String suspend(@PathVariable int id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        if (currentUser.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("errorMsg", "You cannot suspend yourself!");
            return "redirect:/admin/users";
        }
        userService.suspendUser(id, currentUser, request.getRemoteAddr());
        redirectAttributes.addFlashAttribute("successMsg", "User suspended successfully.");
        return "redirect:/admin/users";
    }

    @PostMapping("/admin/users/{id}/unsuspend")
    public String unsuspend(@PathVariable int id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        userService.unsuspendUser(id, currentUser, request.getRemoteAddr());
        redirectAttributes.addFlashAttribute("successMsg", "User unsuspended successfully.");
        return "redirect:/admin/users";
    }

    @PostMapping("/admin/users/{id}/unlock")
    public String unlock(@PathVariable int id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        userService.unlockUser(id, currentUser, request.getRemoteAddr());
        redirectAttributes.addFlashAttribute("successMsg", "User account unlocked successfully.");
        return "redirect:/admin/users";
    }

    @PostMapping("/admin/users/{id}/role")
    public String changeRole(@PathVariable int id, @RequestParam int role, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        if (currentUser.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("errorMsg", "You cannot change your own role!");
            return "redirect:/admin/users";
        }
        userService.changeUserRole(id, role, currentUser, request.getRemoteAddr());
        redirectAttributes.addFlashAttribute("successMsg", "User role changed successfully.");
        return "redirect:/admin/users";
    }

    @PostMapping("/admin/users/{id}/delete")
    public String deletePost(@PathVariable int id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isAdmin(currentUser)) {
            return "redirect:/login";
        }
        if (currentUser.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("errorMsg", "You cannot delete yourself!");
            return "redirect:/admin/users";
        }
        userService.deleteUser(id);
        redirectAttributes.addFlashAttribute("successMsg", "User deleted successfully.");
        return "redirect:/admin/users";
    }

    // GET handler for legacy delete buttons/links
    @GetMapping("/admin/users/delete")
    public String deleteGet(@RequestParam("id") int id, HttpServletRequest request, HttpSession session, RedirectAttributes redirectAttributes) {
        return deletePost(id, request, session, redirectAttributes);
    }
}
