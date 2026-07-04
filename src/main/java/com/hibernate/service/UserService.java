package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.User;

public interface UserService {
    
    void registerUser(User user);
    
    User authenticateByEmail(String email, String password);
    
    User findById(int id);
    
    void updateProfile(int id, String fullName, String email);
    
    boolean changePassword(int id, String oldPassword, String newPassword);
    
    boolean sendResetPasswordEmail(String email, String contextPath);
    
    boolean resetPassword(String token, String newPassword);
    
    void updateUser(User user);
    
    // 🌟 UI တွင် List ထုတ်ပြရန် အသစ်ထည့်ထားသော ခေါင်းစဉ်
    List<User> getAllUsers();
    
    // 🌟 Admin မှ User အား ဖျက်ရန် အသစ်ထည့်ထားသော ခေါင်းစဉ်
    void deleteUser(int id);

    List<User> search(String keyword, String role, String status, int page, int size);

    long countSearch(String keyword, String role, String status);

    void suspendUser(int id, User admin, String ipAddress);

    void unsuspendUser(int id, User admin, String ipAddress);

    void unlockUser(int id, User admin, String ipAddress);

    void changeUserRole(int id, int role, User admin, String ipAddress);
}