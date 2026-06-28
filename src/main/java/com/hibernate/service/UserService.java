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
}