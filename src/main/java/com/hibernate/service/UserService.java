package com.hibernate.service;

import java.time.LocalDateTime;
import java.util.UUID;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.User;
import com.hibernate.repository.UserRepository;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private AuditLogService auditLogService;

    public void registerUser(User user) {
        String usernamePattern = "^[a-zA-Z0-9]{4,20}$";

        if (user.getUsername() == null || !user.getUsername().matches(usernamePattern)) {
            throw new IllegalArgumentException("Username must be 4-20 characters long and contain only letters and numbers (no spaces)!");
        }
        if (userRepository.findByUsername(user.getUsername()) != null) {
            throw new IllegalArgumentException("Username '" + user.getUsername() + "' is already taken!");
        }

        if (userRepository.findByEmail(user.getEmail()) != null) {
            throw new IllegalArgumentException("Email address is already registered!");
        }

        String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashedPassword);
        user.setRole(0);
        userRepository.save(user);
        auditLogService.log(user, "User Registered", "User", null);
    }

    @Transactional(readOnly = true)
    public User authenticateByEmail(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public User findById(int id) {
        return userRepository.findById(id);
    }

    public void updateProfile(int id, String fullName, String email) {
        User user = userRepository.findById(id);
        if (user != null) {
            user.setFullName(fullName);
            user.setEmail(email);
            userRepository.update(user);
        }
    }

    public boolean changePassword(int id, String oldPassword, String newPassword) {
        User user = userRepository.findById(id);
        if (user != null && BCrypt.checkpw(oldPassword, user.getPassword())) {
            user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            userRepository.update(user);
            return true;
        }
        return false;
    }

    public boolean sendResetPasswordEmail(String email, String contextPath) {
        User user = userRepository.findByEmail(email);
        if (user == null) return false;

        String token = UUID.randomUUID().toString();
        user.setResetToken(token);
        user.setTokenExpiry(LocalDateTime.now().plusMinutes(15));
        userRepository.update(user);

        String resetUrl = contextPath + "/reset-password?token=" + token;

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(user.getEmail());
        message.setSubject("Password Reset Request");
        message.setText("Your password reset link:\n" + resetUrl + "\n\nThis link is valid for 15 minutes.");

        mailSender.send(message);
        return true;
    }

    public boolean resetPassword(String token, String newPassword) {
        User user = userRepository.findByResetToken(token);
        if (user == null || user.getTokenExpiry().isBefore(LocalDateTime.now())) {
            return false;
        }

        user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        user.setResetToken(null);
        user.setTokenExpiry(null);
        userRepository.update(user);
        return true;
    }

    public void updateUser(User user) {
        userRepository.update(user);
    }
}
