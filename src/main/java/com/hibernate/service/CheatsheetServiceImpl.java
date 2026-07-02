package com.hibernate.service;

import java.util.List;
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
    public int getTotalSheetsCount() { return cheatsheetRepository.getTotalSheetsCount(); }

    @Override
    @Transactional
    public Integer save(CheatsheetEntity cheatsheet) { return cheatsheetRepository.save(cheatsheet); }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findAll() { return cheatsheetRepository.findAll(); }

    @Override
    @Transactional(readOnly = true)
    public CheatsheetEntity findById(Integer id) { return cheatsheetRepository.findById(id); }

    @Override
    @Transactional
    public void update(CheatsheetEntity cheatsheet) { cheatsheetRepository.update(cheatsheet); }

    @Override
    @Transactional
    public void delete(Integer id) { cheatsheetRepository.delete(id); }

    // 🌟 Admin Dashboard အတွက် Filter စနစ်
    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findAllAdmin(String filter) {
        if ("mostLikes".equals(filter)) {
            return cheatsheetRepository.findAllSortedByLikes();
        } else if ("mostDislikes".equals(filter)) {
            return cheatsheetRepository.findAllSortedByDislikes();
        }
        return cheatsheetRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findAllSortedByLikes() { return cheatsheetRepository.findAllSortedByLikes(); }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findAllSortedByDislikes() { return cheatsheetRepository.findAllSortedByDislikes(); }

    @Override
    @Transactional
    public void banCheatsheet(Integer id, String reason) {
        CheatsheetEntity sheet = cheatsheetRepository.findById(id);
        if(sheet != null) {
            sheet.setVisibility("BANNED");
            cheatsheetRepository.update(sheet);
        }
    }

    // --- အခြား Method များ ---
    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findByUserId(Integer userId) { return cheatsheetRepository.findByUserId(userId); }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findByCategoryIdWithPagination(Integer categoryId, int page, int size, Integer currentUserId) {
        return cheatsheetRepository.findByCategoryIdWithPagination(categoryId, page, size, currentUserId);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByCategoryId(Integer categoryId, Integer currentUserId) { return cheatsheetRepository.countByCategoryId(categoryId, currentUserId); }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> countCheatsheetsPerTagByRepository(Integer categoryId) { return cheatsheetRepository.countCheatsheetsPerTagByRepository(categoryId); }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size) { return cheatsheetRepository.findLatestPublic(keyword, page, size); }

    @Override
    @Transactional(readOnly = true)
    public long countLatestPublic(String keyword) { return cheatsheetRepository.countLatestPublic(keyword); }

    @Override
    @Transactional(readOnly = true)
    public long countAllActive() { return cheatsheetRepository.countAllActive(); }

    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findTagsByCategoryId(Integer categoryId) { return cheatsheetRepository.findTagsByCategoryId(categoryId); }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId) { return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId); }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> getPublicCheatsheetsByTagId(Integer tagId) { return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId); }
}