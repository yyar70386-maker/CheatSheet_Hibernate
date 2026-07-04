package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.entity.User;
import com.hibernate.dto.NotificationDto;

public interface CheatsheetService {
    Integer save(CheatsheetEntity cheatsheet);
    List<CheatsheetEntity> findAll();
    CheatsheetEntity findById(Integer id);
    void update(CheatsheetEntity cheatsheet);
    void delete(Integer id);
    
    List<CheatsheetEntity> findByUserId(Integer userId);

    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId, String filter);
    long countByCategoryId(Integer categoryId, Integer currentUserId, String filter);
    
    List<TagEntity> findTagsByCategoryId(Integer categoryId, Integer currentUserId); 
    
    // 🌟 [FIXED] Interface အတွင်း ထပ်နေသော မက်သတ်အဟောင်းအား ဖယ်ရှား၍ ပုံစံသစ်ကိုသာ စနစ်တကျ ထားရှိခြင်း
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter);
    long countByTagId(Integer tagId, Integer currentUserId, String filter);
    
    int getTotalSheetsCount(); 
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId, Integer currentUserId);
    List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size);
    long countLatestPublic(String keyword);
    long countAllActive();

    List<CheatsheetEntity> searchAll(String keyword, String categoryId, String status, String banned, int page, int size);
    long countSearchAll(String keyword, String categoryId, String status, String banned);
    NotificationDto banCheatsheet(Integer id, String reason, User admin, String ipAddress);
    NotificationDto restoreCheatsheet(Integer id, User admin, String ipAddress);
    NotificationDto approveCheatsheet(Integer id, User admin, String ipAddress);
    NotificationDto rejectCheatsheet(Integer id, User admin, String ipAddress);
    long countBanned();
    long countPublished();
}