package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;

public interface CheatSheetService {
    Integer save(CheatsheetEntity cheatsheet);
    List<CheatsheetEntity> findAll();
    CheatsheetEntity findById(Integer id);
    void update(CheatsheetEntity cheatsheet);
    void delete(Integer id);
    
    // 🌟 Controller မှ လှမ်းခေါ်နိုင်ရန် Interface တွင် လာရောက်ကြေညာပေးခြင်း
    List<CheatsheetEntity> findByUserId(Integer userId);

    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId);
    long countByCategoryId(Integer categoryId, Integer currentUserId);
    
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId);
    
    List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size);
    long countLatestPublic(String keyword);
    long countAllActive();

    // --- 🌟 Tag System ပုံစံသစ်များနှင့် Merged Methods ---
    List<TagEntity> findTagsByCategoryId(Integer categoryId); // Both branches
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId); // From HEAD
    List<CheatsheetEntity> getPublicCheatsheetsByTagId(Integer tagId); // From incoming branch
    
    int getTotalSheetsCount(); // From incoming branch
}