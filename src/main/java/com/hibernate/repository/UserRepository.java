package com.hibernate.repository;

import com.hibernate.entity.User;
import java.util.List;

public interface UserRepository {
    
    // 🌟 Impl ထဲမှာ ရေးထားသမျှ Method အားလုံးကို ဒီမှာ ခေါင်းစဉ် လာကြေညာပေးရပါတယ်
    List<User> getAllUsers();
    
    void deleteUser(int id);
    
    void save(User user);
    
    void update(User user);
    
    User findById(int id);
    
    User findByUsername(String username);
    
    User findByEmail(String email);
    
    User findByResetToken(String token);
}