package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.service.CategoryService;
import com.hibernate.service.UserService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.util.UUID;

@Controller
public class AuthController {

	@Autowired
	private UserService userService;

	@Autowired
	private CategoryService categoryService;

	@GetMapping("/")
	public String showHomePage(HttpSession session, Model model) {

		model.addAttribute("categorylist", categoryService.findAll());
		return "home";
	}

	@GetMapping("/register")
	public String showRegisterForm(Model model) {
		model.addAttribute("user", new User());
		return "register";
	}

	@PostMapping("/register")
	public String processRegister(@ModelAttribute("user") User user,
			@RequestParam("confirmPassword") String confirmPassword, Model model) {

		if (!user.getPassword().equals(confirmPassword)) {
			model.addAttribute("error", "Password and Confirm Password do not match!");
			return "register";
		}

		try {

			userService.registerUser(user);
			return "redirect:/login?success=registered";

		} catch (IllegalArgumentException e) {

			model.addAttribute("error", e.getMessage());
			return "register";

		} catch (Exception e) {

			model.addAttribute("error", "An unexpected error occurred. Please try again.");
			return "register";
		}
	}

	@GetMapping("/login")
	public String showLoginForm() {
		return "login";
	}

	@PostMapping("/login")
	public String processLogin(@RequestParam("email") String email, @RequestParam("password") String password,
			HttpSession session, RedirectAttributes redirectAttributes) { 

		User user = userService.authenticateByEmail(email, password);

		if (user != null) {
			session.setAttribute("currentUser", user);
			return "redirect:/home";
		} else {

			redirectAttributes.addFlashAttribute("loginError", "Invalid Email or Password!");
			return "redirect:/login";
		}
	}

	@GetMapping("/logout")
	public String handleLogout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}

	@GetMapping("/home")
	public String showHomeDashboard(HttpSession session, Model model) {

		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		model.addAttribute("categorylist", categoryService.findAll());
		return "home";
	}

	@GetMapping("/profile")
	public String showProfile(HttpSession session, Model model) {
		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		model.addAttribute("user", userService.findById(currentUser.getId()));
		return "profile";
	}

	// --- FORGOT & RESET PASSWORD CONTROLLERS ---

	@GetMapping("/forgot-password")
	public String showForgotPasswordForm() {
		return "forgot-password";
	}

	@PostMapping("/forgot-password")
	public String handleForgotPassword(@RequestParam("email") String email, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		String contextPath = request.getRequestURL().toString().replace(request.getRequestURI(),
				request.getContextPath());

		boolean emailSent = userService.sendResetPasswordEmail(email, contextPath);

		if (emailSent) {
			redirectAttributes.addFlashAttribute("successMessage",
					"A password reset link has been sent to your email address.");
		} else {
			redirectAttributes.addFlashAttribute("errorMessage", "No account found with this email address.");
		}

		return "redirect:/forgot-password";
	}

	@GetMapping("/reset-password")
	public String showResetPasswordForm(@RequestParam("token") String token, Model model) {
		model.addAttribute("token", token);
		return "reset-password";
	}

	@PostMapping("/reset-password")
	public String handleResetPassword(@RequestParam("token") String token, @RequestParam("password") String password,
			@RequestParam("confirmPassword") String confirmPassword, Model model) {
		if (!password.equals(confirmPassword)) {
			model.addAttribute("error", "New passwords do not match!");
			model.addAttribute("token", token);
			return "reset-password";
		}

		boolean result = userService.resetPassword(token, password);

		if (result) {

			return "redirect:/login?success=password_reset";
		} else {
			model.addAttribute("error", "The reset link is invalid or has expired.");
			return "reset-password";
		}
	}

	@PostMapping("/profile/upload-avatar")
	public String handleAvatarUpload(@RequestParam("avatarFile") MultipartFile file, HttpSession session,
			HttpServletRequest request, RedirectAttributes redirectAttributes) {

		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		if (!file.isEmpty()) {
			try {
				
				String originalFilename = file.getOriginalFilename();
				if (originalFilename == null || !originalFilename.contains(".")) {
					redirectAttributes.addFlashAttribute("error", "Invalid file name.");
					return "redirect:/profile";
				}
				
				
				String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
				if (!extension.matches("\\.(jpg|jpeg|png|gif)")) {
					redirectAttributes.addFlashAttribute("error", "Only Image files (JPG, JPEG, PNG, GIF) are allowed!");
					return "redirect:/profile";
				}

				
				try (java.io.InputStream is = file.getInputStream()) {
					java.awt.image.BufferedImage bufferedImage = javax.imageio.ImageIO.read(is);
					
					
					if (bufferedImage == null) {
						redirectAttributes.addFlashAttribute("error", "Fake Image Detected! You cannot bypass with fake extensions.");
						return "redirect:/profile";
					}
				} catch (Exception e) {
					redirectAttributes.addFlashAttribute("error", "Invalid image content or corrupted file.");
					return "redirect:/profile";
				}

				
				String uploadDir = "C:/my_project_uploads/";
				File dir = new File(uploadDir);
				if (!dir.exists()) {
					dir.mkdirs();
				}

				
				String oldAvatarName = currentUser.getAvatarPath();
				if (oldAvatarName != null && !oldAvatarName.isEmpty()) {
					File oldFile = new File(dir.getAbsolutePath() + File.separator + oldAvatarName);
					if (oldFile.exists()) {
						oldFile.delete();
					}
				}

				
				String newFileName = UUID.randomUUID().toString() + extension;

				File serverFile = new File(dir.getAbsolutePath() + File.separator + newFileName);
				file.transferTo(serverFile);

				currentUser.setAvatarPath(newFileName);
				userService.updateUser(currentUser);
				session.setAttribute("currentUser", currentUser);

				
				redirectAttributes.addFlashAttribute("message", "Profile picture updated successfully!");
				return "redirect:/profile";

			} catch (Exception e) {
				redirectAttributes.addFlashAttribute("error", "Failed to upload image: " + e.getMessage());
				return "redirect:/profile";
			}
		}

		redirectAttributes.addFlashAttribute("error", "Please select a valid file to upload.");
		return "redirect:/profile";
	}

	@PostMapping("/profile/update")
	public String updateProfile(@RequestParam("fullName") String fullName, @RequestParam("email") String email,
			@RequestParam("bio") String bio, HttpSession session, RedirectAttributes redirectAttributes) {

		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		try {
			currentUser.setFullName(fullName);
			currentUser.setEmail(email);
			currentUser.setBio(bio);

			userService.updateUser(currentUser);
			session.setAttribute("currentUser", currentUser);

			redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");

		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("error", "Failed to update profile: " + e.getMessage());
		}

		return "redirect:/profile";
	}

	@PostMapping("/profile/change-password")
	public String changePassword(@RequestParam("oldPassword") String oldPassword, 
			@RequestParam("newPassword") String newPassword, 
			HttpSession session, RedirectAttributes redirectAttributes) {

		User currentUser = (User) session.getAttribute("currentUser");
		if (currentUser == null) {
			return "redirect:/login";
		}

		
		if (newPassword == null || newPassword.trim().length() < 6) {
			redirectAttributes.addFlashAttribute("errorMsg", "The new password must be at least 6 characters long.");
			return "redirect:/profile?tab=security";
		}
		
		
		if (oldPassword != null && oldPassword.equals(newPassword)) {
			redirectAttributes.addFlashAttribute("errorMsg", "New password cannot be the same as your current password.");
			return "redirect:/profile?tab=security";
		}

		try {
			boolean isUpdated = userService.changePassword(currentUser.getId(), oldPassword, newPassword);

			if (isUpdated) {
				
				session.invalidate(); 

				
				//redirectAttributes.addFlashAttribute("loginSuccess", "Password changed successfully! Please login again with your new password.");
				
				
				return "redirect:/login?success=password_changed";
			
			} else {
				redirectAttributes.addFlashAttribute("errorMsg", "The current password you entered is incorrect.");
				return "redirect:/profile?tab=security";
			}

		} catch (Exception e) {
			redirectAttributes.addFlashAttribute("errorMsg", "An error occurred while changing password: " + e.getMessage());
			return "redirect:/profile?tab=security";
		}
	}
}