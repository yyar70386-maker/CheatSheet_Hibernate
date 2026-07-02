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
    
    List<CheatsheetEntity> findByUserId(Integer userId);
    List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId);
    long countByCategoryId(Integer categoryId, Integer currentUserId);
    List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId);
    List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size);
    long countLatestPublic(String keyword);
    long countAllActive();
    int getTotalSheetsCount();

    List<TagEntity> findTagsByCategoryId(Integer categoryId); 
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId); 
    List<CheatsheetEntity> getPublicCheatsheetsByTagId(Integer tagId); 

    // 🌟 Admin Dashboard အတွက် Method များ (Error ရှင်းသွားပါမည်)
    List<CheatsheetEntity> findAllAdmin(String filter);
    List<CheatsheetEntity> findAllSortedByLikes();
    List<CheatsheetEntity> findAllSortedByDislikes();
    void banCheatsheet(Integer id, String reason);
}