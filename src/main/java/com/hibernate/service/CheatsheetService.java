package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;

public interface CheatsheetService {
    Integer save(CheatsheetEntity cheatsheet);
    List<CheatsheetEntity> findAll();
    CheatsheetEntity findById(Integer id);
    void update(CheatsheetEntity cheatsheet);
    void delete(Integer id);
    
    // 🌟 [ADDED] Controller မှ လှမ်းခေါ်နိုင်ရန် Interface တွင် လာရောက်ကြေညာပေးခြင်း
    List<CheatsheetEntity> findByUserId(Integer userId);

    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId);
    long countByCategoryId(Integer categoryId, Integer currentUserId);
    List<TagEntity> findTagsByCategoryId(Integer categoryId);
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId);
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId);
}