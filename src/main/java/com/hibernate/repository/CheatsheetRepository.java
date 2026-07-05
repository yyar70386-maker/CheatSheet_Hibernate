package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.CheatSheetReportEntity;
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
    
    // 🌟 [STORED PROCEDURE CALL] တီချယ်ခိုင်းသည့်အတိုင်း Native Procedure အား လှမ်းခေါ်မည့် Signature
    List<Object[]> callStoredProcedureForTagCounts(Integer categoryId, Integer currentUserId);
    
    List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter);
    long countByTagId(Integer tagId, Integer currentUserId, String filter);
    
    List<CheatsheetEntity> findByUserId(Integer userId);
    List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size);
    List<CheatsheetEntity> findPopularPublic(int size);
    List<CheatsheetEntity> findPublicCreatedBetween(java.sql.Timestamp start, java.sql.Timestamp end);
    long countLatestPublic(String keyword);
    long countAllActive();
    int getTotalSheetsCount();

    List<CheatsheetEntity> searchAll(String keyword, String categoryId, String status, String banned, int page, int size);
    long countSearchAll(String keyword, String categoryId, String status, String banned);
    long countBanned();
    long countPublished();
    List<CheatSheetReportEntity> findCheatsheetReportData();
}
