package com.hibernate.service;

import java.util.List;
import java.util.ArrayList;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.repository.CheatsheetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor 
@Transactional
public class CheatsheetServiceImpl implements CheatsheetService {

    private final CheatsheetRepository cheatsheetRepository;

    // ==================== 🌟 [UPDATED WITH STORED PROCEDURE] ====================
    // တီချယ်ပြောသလို စားဖိုမှူး (Service Layer) အလုပ်မရှုပ်တော့ဘဲ SQL ဘက်က တွက်ပြီးသားကို တန်းယူသုံးသည့် စနစ်သစ်
    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findTagsByCategoryId(Integer categoryId, Integer currentUserId) {
        // ၁။ Repository မှတစ်ဆင့် Database ၏ Native Stored Procedure ကို CALL ခေါ်ယူခြင်း
        List<Object[]> spResults = cheatsheetRepository.callStoredProcedureForTagCounts(categoryId, currentUserId);
        
        List<TagEntity> processedTags = new ArrayList<>();
        
        // ၂။ Database က တွက်ချက်ပြီးသား ဟင်းချက်ရုံအသားတုံး (ရလဒ်အချော) များကို Object ထဲသို့ တိုက်ရိုက်မြေပုံညွှန်း (Mapping) လုပ်ခြင်း
        if (spResults != null) {
            for (Object[] row : spResults) {
                TagEntity tag = new TagEntity();
                tag.setId((Integer) row[0]); // tag_id
                
                String rawName = (String) row[1]; // tag_name
                
                // Stored Procedure ၏ COUNT() ရလဒ်အား BigInteger သို့မဟုတ် Long ပုံစံဖြင့် လက်ခံခြင်း
                java.math.BigInteger count = (java.math.BigInteger) row[2]; // cheatsheet_count
                
                // Java ထဲတွင် Logic များ လိုက်တွက်စရာမလိုဘဲ ချက်ချင်း Name (Count) စာသား တွဲပေးလိုက်ရုံသာ
                tag.setName(rawName + " (" + count + ")");
                processedTags.add(tag);
            }
        }
        return processedTags;
    }

    @Override
    @Transactional(readOnly = true)
    public int getTotalSheetsCount() {
        return cheatsheetRepository.getTotalSheetsCount();
    }

    @Override
    @Transactional
    public Integer save(CheatsheetEntity cheatsheet) {
        return cheatsheetRepository.save(cheatsheet);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findAll() {
        return cheatsheetRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public CheatsheetEntity findById(Integer id) {
        return cheatsheetRepository.findById(id);
    }

    @Override
    @Transactional
    public void update(CheatsheetEntity cheatsheet) {
        cheatsheetRepository.update(cheatsheet);
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        cheatsheetRepository.delete(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findByUserId(Integer userId) {
        return cheatsheetRepository.findByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId, String filter) {
        return cheatsheetRepository.findByCategoryIdWithPagination(categoryId, page, size, currentUserId, filter);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByCategoryId(Integer categoryId, Integer currentUserId, String filter) {
        return cheatsheetRepository.countByCategoryId(categoryId, currentUserId, filter);
    }

    // Legacy method Mapping -> တီချယ်ခိုင်းသည့်အမိန့်အရ Procedure ခေါ်ဆိုမှုဆီသို့ အလိုအလျောက် လွှဲပြောင်းပေးထားသည်
    @Override
    @Transactional(readOnly = true)
    public List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId, Integer currentUserId) {
        return cheatsheetRepository.callStoredProcedureForTagCounts(categoryId, currentUserId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size) {
        return cheatsheetRepository.findLatestPublic(keyword, page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public long countLatestPublic(String keyword) {
        return cheatsheetRepository.countLatestPublic(keyword);
    }

    @Override
    @Transactional(readOnly = true)
    public long countAllActive() {
        return cheatsheetRepository.countAllActive();
    }

    // ==================== 🌟 TAG BROWSE WITH FILTER AND PAGINATION ====================
    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter) {
        return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId, page, size, currentUserId, filter);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByTagId(Integer tagId, Integer currentUserId, String filter) {
        return cheatsheetRepository.countByTagId(tagId, currentUserId, filter);
    }
}