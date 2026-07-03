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

    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId, String filter);
    long countByCategoryId(Integer categoryId, Integer currentUserId, String filter);
    
    List<TagEntity> findTagsByCategoryId(Integer categoryId);
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId, Integer currentUserId);
    
    // 🌟 Tag Detail အတွက် အသုံးပြုမည့် Pagination + Filter စနစ်သစ်
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter);
    long countByTagId(Integer tagId, Integer currentUserId, String filter);
    
    List<CheatsheetEntity> findByUserId(Integer userId);
    List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size);
    long countLatestPublic(String keyword);
    long countAllActive();
    int getTotalSheetsCount();
}