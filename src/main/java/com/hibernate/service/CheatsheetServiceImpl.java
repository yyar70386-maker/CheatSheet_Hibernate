package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.repository.CheatsheetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor // Repository ကို Constructor Injection အလိုအလျောက်လုပ်ပေးရန်
@Transactional
public class CheatsheetServiceImpl implements CheatsheetService {

    private final CheatsheetRepository cheatsheetRepository;

    // 🌟 [ADDED] Сheatsheets အရေအတွက်ကို Repository ဆီကနေတစ်ဆင့် လှမ်းယူပေးမည့် မက်သတ်
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
    public List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId) {
        return cheatsheetRepository.findByCategoryIdWithPagination(categoryId, page, size, currentUserId);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByCategoryId(Integer categoryId, Integer currentUserId) {
        return cheatsheetRepository.countByCategoryId(categoryId, currentUserId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId) {
        return cheatsheetRepository.countCheatsheetsPerTagByRepository(categoryId);
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

    // --- 🌟 Tag System မက်သတ်များ ---

    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findTagsByCategoryId(Integer categoryId) {
        return cheatsheetRepository.findTagsByCategoryId(categoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId) {
        return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> getPublicCheatsheetsByTagId(Integer tagId) {
        // Interface ထဲမှာ နာမည်ကွဲနေတဲ့အတွက် မက်သတ်နှစ်ခုလုံးက တစ်ခုတည်းကိုပဲ လှမ်းခေါ်အောင် ညွှန်းပေးထားပါတယ်
        return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId);
    }
}