package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;

public interface CheatsheetRepository {

    Integer save(CheatsheetEntity cheatsheet);
    List<CheatsheetEntity> findAll();
    CheatsheetEntity findById(Integer id);
    void update(CheatsheetEntity cheatsheet);
    void delete(Integer id);

    // 🌟 Visibility System ပါဝင်သော ပုံစံသစ်များ
    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId);
    long countByCategoryId(Integer categoryId, Integer currentUserId);
    
    List<TagEntity> findTagsByCategoryId(Integer categoryId);
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId);
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId);
 // 💡 CheatsheetRepository.java ရဲ့ အောက်ဆုံးနားတွင် ထည့်ရန်
    List<CheatsheetEntity> findByUserId(Integer userId);
}