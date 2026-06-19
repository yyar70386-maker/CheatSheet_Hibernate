package com.hibernate.service;

import com.hibernate.entity.User;
import com.hibernate.repository.UserRepository;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@Transactional
public class UserService {
    
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JavaMailSender mailSender; // Real Email ပို့ရန် ခေါ်ယူခြင်း

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
    }

    // [ပြောင်းလဲမှု] Email နှင့် Password ကို စစ်ဆေး၍ Login ဝင်ခွင့်ပြုခြင်း
    @Transactional(readOnly = true)
    public User authenticateByEmail(String email, String password) {
        User user = userRepository.findByEmail(email);
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public User findById(int id) { return userRepository.findById(id); }
    
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

    // [FORGOT PASSWORD] Token ထုတ်ပြီး Email ပို့ခြင်း လုပ်ငန်းစဉ်
    public boolean sendResetPasswordEmail(String email, String contextPath) {
        User user = userRepository.findByEmail(email);
        if (user == null) return false;

        // ထူးခြားဆန်းပြားသော Token တစ်ခုထုတ်ခြင်း
        String token = UUID.randomUUID().toString();
        user.setResetToken(token);
        user.setTokenExpiry(LocalDateTime.now().plusMinutes(15)); // ၁၅ မိနစ်ပဲ သက်တမ်းပေးမည်
        userRepository.update(user);

        // Link ပြင်ဆင်ခြင်း
        String resetUrl = contextPath + "/reset-password?token=" + token;

        // Email စာသား ပြင်ဆင်ပြီး ပို့ခြင်း
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(user.getEmail());
        message.setSubject("Password Reset Request");
        message.setText("သင်၏ Password အား ပြန်လည်ပြင်ဆင်ရန် အောက်ပါ Link ကို နှိပ်ပါ-\n" + resetUrl + "\n\nဤ Link သည် ၁၅ မိနစ်အတွင်းသာ အသုံးတည့်ပါမည်။");
        
        mailSender.send(message); // Real Email ထွက်သွားမည့်နေရာ
        return true;
    }

    // [RESET PASSWORD] Token မှန်ကန်ပါက Password အသစ်လဲပေးခြင်း
    public boolean resetPassword(String token, String newPassword) {
        User user = userRepository.findByResetToken(token);
        if (user == null || user.getTokenExpiry().isBefore(LocalDateTime.now())) {
            return false; // Token မရှိပါက သို့မဟုတ် သက်တမ်းကုန်သွားပါက ငြင်းပယ်မည်
        }

        user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
        user.setResetToken(null); // သုံးပြီးသား Token ကို ပြန်ဖျက်ခြင်း
        user.setTokenExpiry(null);
        userRepository.update(user);
        return true;
    }
    
 // ✨ Profile အချက်အလက်နှင့် Avatar လမ်းကြောင်းများ ပြင်ဆင်ရန်အတွက် သီးသန့် Method
    public void updateUser(User user) {
        // ဒီမှာ password hashing ရော setRole(0) ရော ထည့်စရာမလိုပါဘူး (လက်ရှိအတိုင်းပဲ သိမ်းမှာမို့လို့)
        userRepository.update(user); // သို့မဟုတ် userRepository.merge(user);
    }
}