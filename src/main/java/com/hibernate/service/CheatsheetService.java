package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;

public interface CheatsheetService {

    // --- မူလ CRUD စနစ်များ ---
    Integer save(CheatsheetEntity cheatsheet);
    List<CheatsheetEntity> findAll();
    CheatsheetEntity findById(Integer id);
    void update(CheatsheetEntity cheatsheet);
    void delete(Integer id);

    // --- Visibility & Pagination စနစ်များ ---
    List<CheatsheetEntity> getCheatsheetsByCategoryWithPagination(Integer categoryId, int page, int size, Integer currentUserId);
    int getTotalPagesByCategory(Integer categoryId, int size, Integer currentUserId);
    long countByCategoryId(Integer categoryId, Integer currentUserId);
    
    // --- 🌟 Tag System ပုံစံသစ်များ ---
    List<TagEntity> findTagsByCategoryId(Integer categoryId); // Public Count တွက်ပြီးသား Tag စာရင်းယူရန်
    List<CheatsheetEntity> getPublicCheatsheetsByTagId(Integer tagId); // Tag အလိုက် Public Cheatsheet သီးသန့်ဆွဲထုတ်ရန်
	int getTotalSheetsCount();
}