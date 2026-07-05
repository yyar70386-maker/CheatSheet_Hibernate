package com.hibernate.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.hibernate.entity.User;
@Repository
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

    List<User> findLatest(int limit);

    List<User> search(String keyword, String role, String status, int page, int size);

    long countSearch(String keyword, String role, String status);

    long countSuspended();

    long countLocked();
}
