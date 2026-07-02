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

    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId);
    long countByCategoryId(Integer categoryId, Integer currentUserId);
    
    List<TagEntity> findTagsByCategoryId(Integer categoryId);
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId);
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId);
    List<CheatsheetEntity> findByUserId(Integer userId);
    List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size);
    long countLatestPublic(String keyword);
    long countAllActive();
    int getTotalSheetsCount();

    // 🌟 ဤ Method ၂ ခု မရှိ၍ Error တက်နေခြင်းဖြစ်သည် (ယခု ထည့်ပေးလိုက်ပါပြီ)
    List<CheatsheetEntity> findAllSortedByLikes();
    List<CheatsheetEntity> findAllSortedByDislikes();
}