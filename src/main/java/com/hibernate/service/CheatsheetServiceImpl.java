package com.hibernate.service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.repository.CheatsheetRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CheatsheetServiceImpl implements CheatsheetService {

    private final CheatsheetRepository repo;

    @Override
    @Transactional
    public Integer save(CheatsheetEntity cheatsheet) {
        return repo.save(cheatsheet);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findAll() {
        return repo.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public CheatsheetEntity findById(Integer id) {
        return repo.findById(id);
    }

    @Override
    @Transactional
    public void update(CheatsheetEntity cheatsheet) {
        repo.update(cheatsheet);
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        repo.delete(id);
    }

    // --- Visibility & Pagination Logics ---

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> getCheatsheetsByCategoryWithPagination(Integer categoryId, int page, int size, Integer currentUserId) {
        return repo.findByCategoryIdWithPagination(categoryId, page, size, currentUserId);
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalPagesByCategory(Integer categoryId, int size, Integer currentUserId) {
        long totalRecords = repo.countByCategoryId(categoryId, currentUserId);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        return totalPages == 0 ? 1 : totalPages;
    }

    @Override
    @Transactional(readOnly = true)
    public long countByCategoryId(Integer categoryId, Integer currentUserId) {
        return repo.countByCategoryId(categoryId, currentUserId);
    }

    // --- 🌟 Tag List With "PUBLIC ONLY" Count Logic ---
    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findTagsByCategoryId(Integer categoryId) {
        // ၁။ သတ်မှတ်ထားသော Category အောက်ရှိ Active Tag စာရင်းကို ယူခြင်း
        List<TagEntity> tags = repo.findTagsByCategoryId(categoryId);
        
        // ၂။ Repository မှ [TagId, Count] (PUBLIC Cheatsheets သီးသန့်) ရလဒ်ကို ယူခြင်း
        List<Object[]> countResults = repo.countCheatsheetsPerTagByRepository(categoryId);
        
        // ၃။ ဒေတာများကို Map ထဲသို့ စုစည်းခြင်း
        Map<Integer, Long> countMap = new HashMap<>();
        if (countResults != null) {
            for (Object[] result : countResults) {
                countMap.put((Integer) result[0], (Long) result[1]);
            }
        }
        
        // ၄။ Loop ပတ်၍ Tag နာမည်နောက်တွင် (Public Count) စာသား ထည့်သွင်းပေးခြင်း
        for (TagEntity tag : tags) {
            long count = countMap.getOrDefault(tag.getId(), 0L);
            tag.setName(tag.getName() + " (" + count + ")");
        }
        
        return tags;
    }

    // --- 🌟 Tag Filter View Logic ---
    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> getPublicCheatsheetsByTagId(Integer tagId) {
        // Tag ID အလိုက် PUBLIC ဖြစ်ပြီး Active ဖြစ်သော စာရင်းကို ဆွဲထုတ်ရန် Repository သို့ လှမ်းခေါ်ခြင်း
        return repo.findPublicCheatsheetsByTagId(tagId);
    }
}