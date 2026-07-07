package com.hibernate.service;

import java.time.LocalDateTime;
import java.util.List;
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
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private AuditLogService auditLogService;

    @Autowired
    private NotificationService notificationService;

    @Override
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

    @Override
    @Transactional(noRollbackFor = IllegalArgumentException.class)
    public User authenticateByEmail(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new IllegalArgumentException("Invalid Email or Password!");
        }

        if (user.isSuspended()) {
            if (user.isAccountLocked()) {
                throw new IllegalArgumentException("Your account is locked due to 5 consecutive failed login attempts. Please contact Admin.");
            }
            String msg = "Your account has been suspended by an administrator.";
            if (user.getSuspendReason() != null && !user.getSuspendReason().trim().isEmpty()) {
                msg += " Reason: " + user.getSuspendReason();
            }
            throw new IllegalArgumentException(msg);
        }

        if (BCrypt.checkpw(password, user.getPassword())) {
            if (user.getFailedLoginAttempts() > 0) {
                user.setFailedLoginAttempts(0);
                userRepository.update(user);
            }
            return user;
        } else {
            int attempts = user.getFailedLoginAttempts() + 1;
            user.setFailedLoginAttempts(attempts);
            if (attempts >= 5) {
                user.setAccountLocked(true);
                user.setSuspended(true);
                user.setSuspendedAt(LocalDateTime.now());
                userRepository.update(user);
                throw new IllegalArgumentException("Your account has been locked due to 5 consecutive failed login attempts. Please contact Admin.");
            } else {
                userRepository.update(user);
                throw new IllegalArgumentException("Invalid Email or Password! (" + attempts + " of 5 attempts)");
            }
        }
    }

    @Override
    @Transactional(readOnly = true)
    public User findById(int id) {
        return userRepository.findById(id);
    }

    @Override
    public void updateProfile(int id, String fullName, String email) {
        User user = userRepository.findById(id);
        if (user != null) {
            user.setFullName(fullName);
            user.setEmail(email);
            userRepository.update(user);
        }
    }

    @Override
    public boolean changePassword(int id, String oldPassword, String newPassword) {
        User user = userRepository.findById(id);
        if (user != null && BCrypt.checkpw(oldPassword, user.getPassword())) {
            user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            userRepository.update(user);
            return true;
        }
        return false;
    }
    
    @Override
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

    @Override
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

    @Override
    public void updateUser(User user) {
        userRepository.update(user);
    }

    // 🌟 [ADDED] UI တွင် List ထုတ်ပြရန် Repository မှတစ်ဆင့် ဒေတာဆွဲထုတ်ခြင်း
    @Override
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.getAllUsers();
    }

    // 🌟 [ADDED] Admin မှ User အား ဖျက်ရန် ဆောင်ရွက်ခြင်း
    @Override
    public void deleteUser(int id) {
        userRepository.deleteUser(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> search(String keyword, String role, String status, int page, int size) {
        return userRepository.search(keyword, role, status, page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public long countSearch(String keyword, String role, String status) {
        return userRepository.countSearch(keyword, role, status);
    }

    @Override
    @Transactional
    public com.hibernate.dto.NotificationDto suspendUser(int id, String reason, User admin, String ipAddress) {
        User user = userRepository.findById(id);
        if (user != null) {
            user.setSuspended(true);
            user.setSuspendedAt(LocalDateTime.now());
            user.setSuspendReason(reason);
            userRepository.update(user);
            auditLogService.log(admin, "User Suspended", "User", id, "Suspended user: " + user.getUsername() + ". Reason: " + reason, ipAddress);
            
            return notificationService.createNotification(
                id,
                admin != null ? admin.getId() : null,
                "Account Suspended",
                "Your account has been suspended by an administrator. Reason: " + reason,
                "USER_SUSPEND",
                "/notifications"
            );
        }
        return null;
    }

    @Override
    @Transactional
    public com.hibernate.dto.NotificationDto unsuspendUser(int id, User admin, String ipAddress) {
        User user = userRepository.findById(id);
        if (user != null) {
            user.setSuspended(false);
            user.setSuspendedAt(null);
            user.setSuspendReason(null);
            if (user.isAccountLocked()) {
                user.setAccountLocked(false);
                user.setFailedLoginAttempts(0);
            }
            userRepository.update(user);
            auditLogService.log(admin, "User Unsuspended", "User", id, "Unsuspended user: " + user.getUsername(), ipAddress);
            
            return notificationService.createNotification(
                id,
                admin != null ? admin.getId() : null,
                "Account Unsuspended",
                "Your account has been unsuspended by an administrator.",
                "USER_UNSUSPEND",
                "/notifications"
            );
        }
        return null;
    }

    @Override
    @Transactional
    public com.hibernate.dto.NotificationDto unlockUser(int id, User admin, String ipAddress) {
        User user = userRepository.findById(id);
        if (user != null) {
            user.setAccountLocked(false);
            user.setSuspended(false);
            user.setSuspendedAt(null);
            user.setSuspendReason(null);
            user.setFailedLoginAttempts(0);
            userRepository.update(user);
            auditLogService.log(admin, "Account Unlocked", "User", id, "Unlocked account for user: " + user.getUsername(), ipAddress);
            
            return notificationService.createNotification(
                id,
                admin != null ? admin.getId() : null,
                "Account Unlocked",
                "Your account has been unlocked by an administrator.",
                "USER_UNLOCK",
                "/notifications"
            );
        }
        return null;
    }

    @Override
    @Transactional
    public void changeUserRole(int id, int role, User admin, String ipAddress) {
        User user = userRepository.findById(id);
        if (user != null) {
            int oldRole = user.getRole();
            user.setRole(role);
            userRepository.update(user);
            String roleName = role == 1 ? "Admin" : "User";
            auditLogService.log(admin, "Change Role", "User", id, "Changed role of user " + user.getUsername() + " from " + (oldRole == 1 ? "Admin" : "User") + " to " + roleName, ipAddress);
        }
    }
}