package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.User;

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

    List<User> findAll();

    long countAll();
}