package com.hibernate.service;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
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

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId, Integer currentUserId) {
        return cheatsheetRepository.countCheatsheetsPerTagByRepository(categoryId, currentUserId);
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

    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findTagsByCategoryId(Integer categoryId, Integer currentUserId) {
        List<TagEntity> tags = cheatsheetRepository.findTagsByCategoryId(categoryId);
        List<Object[]> countResults = cheatsheetRepository.countCheatsheetsPerTagByRepository(categoryId, currentUserId);
        
        Map<Integer, Long> countMap = new HashMap<>();
        if (countResults != null) {
            for (Object[] result : countResults) {
                countMap.put((Integer) result[0], (Long) result[1]);
            }
        }
        
        if (tags != null) {
            for (TagEntity tag : tags) {
                if (tag != null) {
                    long count = countMap.getOrDefault(tag.getId(), 0L);
                    tag.setName(tag.getName() + " (" + count + ")");
                }
            }
        }
        return tags;
    }

    // ==================== 🌟 [ADDED & OVERRIDDEN] TAG BROWSE WITH FILTER AND PAGINATION ====================
    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter) {
        // 🌟 Controller မှ ပို့လိုက်သော Pagination + Filter parameter အသစ်များအား Repository သို့ တိုက်ရိုက် ဆင့်ကဲပေးပို့ခြင်း
        return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId, page, size, currentUserId, filter);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByTagId(Integer tagId, Integer currentUserId, String filter) {
        return cheatsheetRepository.countByTagId(tagId, currentUserId, filter);
    }
}