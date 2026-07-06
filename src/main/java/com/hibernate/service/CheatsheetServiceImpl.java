package com.hibernate.service;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import com.hibernate.dto.NotificationDto;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.CheatSheetReportEntity;
import com.hibernate.entity.TagEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.CheatsheetRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor 
@Transactional
public class CheatsheetServiceImpl implements CheatsheetService {

    private final CheatsheetRepository cheatsheetRepository;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;

    // ==================== 🌟 [NEW PRIVACY LOGIC IMPLEMENTATION] ====================
    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findByUserIdAndVisibility(Integer userId, List<String> visibilities) {
        return cheatsheetRepository.findByUserIdAndVisibilityList(userId, visibilities);
    }

    // ==================== 🌟 [STORED PROCEDURE CALL IMPLEMENTATION] ====================
    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findTagsByCategoryId(Integer categoryId, Integer currentUserId) {
        List<Object[]> spResults = cheatsheetRepository.callStoredProcedureForTagCounts(categoryId, currentUserId);
        List<TagEntity> processedTags = new ArrayList<>();
        if (spResults != null) {
            for (Object[] row : spResults) {
                TagEntity tag = new TagEntity();
                tag.setId((Integer) row[0]); 
                String rawName = (String) row[1]; 
                java.math.BigInteger count = (java.math.BigInteger) row[2]; 
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
        // 🌟 [ADDED VALIDATION] Title, Description, Content များ ဗလာဖြစ်နေပါက သိမ်းဆည်းခွင့်မပြုရန် တားဆီးခြင်း
        if (cheatsheet.getTitle() == null || cheatsheet.getTitle().trim().isEmpty() ||
            cheatsheet.getDescription() == null || cheatsheet.getDescription().trim().isEmpty() ||
            cheatsheet.getContent() == null || cheatsheet.getContent().trim().isEmpty()) {
            throw new RuntimeException("Required fields (Title, Description, Content) cannot be empty!");
        }
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
        // 🌟 [ADDED VALIDATION] Update ပြုလုပ်သည့်အခါတွင်လည်း ဒေတာအလွတ်များ ဝင်မလာစေရန် စစ်ဆေးခြင်း
        if (cheatsheet.getTitle() == null || cheatsheet.getTitle().trim().isEmpty() ||
            cheatsheet.getDescription() == null || cheatsheet.getDescription().trim().isEmpty() ||
            cheatsheet.getContent() == null || cheatsheet.getContent().trim().isEmpty()) {
            throw new RuntimeException("Required fields (Title, Description, Content) cannot be empty!");
        }
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
        return cheatsheetRepository.callStoredProcedureForTagCounts(categoryId, currentUserId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findLatestPublic(String keyword, int page, int size) {
        return cheatsheetRepository.findLatestPublic(keyword, page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findPopularPublic(int size) {
        return cheatsheetRepository.findPopularPublic(size);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> findPublicCreatedBetween(java.sql.Timestamp start, java.sql.Timestamp end) {
        return cheatsheetRepository.findPublicCreatedBetween(start, end);
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
    public List<CheatsheetEntity> findPublicCheatsheetsByTagId(Integer tagId, int page, int size, Integer currentUserId, String filter) {
        return cheatsheetRepository.findPublicCheatsheetsByTagId(tagId, page, size, currentUserId, filter);
    }

    @Override
    @Transactional(readOnly = true)
    public long countByTagId(Integer tagId, Integer currentUserId, String filter) {
        return cheatsheetRepository.countByTagId(tagId, currentUserId, filter);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatsheetEntity> searchAll(String keyword, String categoryId, String status, String banned, int page, int size) {
        return cheatsheetRepository.searchAll(keyword, categoryId, status, banned, page, size);
    }

    @Override
    @Transactional(readOnly = true)
    public long countSearchAll(String keyword, String categoryId, String status, String banned) {
        return cheatsheetRepository.countSearchAll(keyword, categoryId, status, banned);
    }

    @Override
    @Transactional
    public NotificationDto banCheatsheet(Integer id, String reason, User admin, String ipAddress) {
        CheatsheetEntity cheatsheet = cheatsheetRepository.findById(id);
        if (cheatsheet != null) {
            cheatsheet.setBanned(true);
            cheatsheet.setBannedReason(reason);
            cheatsheet.setBannedBy(admin);
            cheatsheet.setBannedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            cheatsheet.setStatus("banned");
            cheatsheetRepository.update(cheatsheet);
            auditLogService.log(admin, "CheatSheet Banned", "CheatSheet", id, "Banned CheatSheet: " + cheatsheet.getTitle() + " (Reason: " + reason + ")", ipAddress);

            if (cheatsheet.getAuthor() != null) {
                return notificationService.createNotification(
                        cheatsheet.getAuthor().getId(),
                        admin != null ? admin.getId() : null,
                        "Your CheatSheet '" + cheatsheet.getTitle() + "' has been banned. Reason: " + reason,
                        "CHEATSHEET_BAN",
                        "/notifications"
                );
            }
        }
        return null;
    }

    @Override
    @Transactional
    public NotificationDto restoreCheatsheet(Integer id, User admin, String ipAddress) {
        CheatsheetEntity cheatsheet = cheatsheetRepository.findById(id);
        if (cheatsheet != null) {
            cheatsheet.setBanned(false);
            cheatsheet.setBannedReason(null);
            cheatsheet.setBannedBy(null);
            cheatsheet.setBannedAt(null);
            cheatsheet.setStatus("active");
            cheatsheetRepository.update(cheatsheet);
            auditLogService.log(admin, "CheatSheet Restored", "CheatSheet", id, "Restored CheatSheet: " + cheatsheet.getTitle(), ipAddress);
            
            if (cheatsheet.getAuthor() != null) {
                return notificationService.createNotification(
                        cheatsheet.getAuthor().getId(),
                        admin != null ? admin.getId() : null,
                        "Your CheatSheet '" + cheatsheet.getTitle() + "' has been restored.",
                        "CHEATSHEET_RESTORE",
                        "/cheatsheet/detail/" + id
                );
            }
        }
        return null;
    }

    @Override
    @Transactional
    public NotificationDto approveCheatsheet(Integer id, User admin, String ipAddress) {
        CheatsheetEntity cheatsheet = cheatsheetRepository.findById(id);
        if (cheatsheet != null) {
            cheatsheet.setStatus("active");
            cheatsheet.setBanned(false);
            cheatsheetRepository.update(cheatsheet);
            auditLogService.log(admin, "CheatSheet Approved", "CheatSheet", id, "Approved CheatSheet: " + cheatsheet.getTitle(), ipAddress);

            if (cheatsheet.getAuthor() != null) {
                return notificationService.createNotification(
                        cheatsheet.getAuthor().getId(),
                        admin != null ? admin.getId() : null,
                        "Your CheatSheet '" + cheatsheet.getTitle() + "' has been approved and published.",
                        "CHEATSHEET_APPROVAL",
                        "/cheatsheet/detail/" + id
                );
            }
        }
        return null;
    }

    @Override
    @Transactional
    public NotificationDto rejectCheatsheet(Integer id, User admin, String ipAddress) {
        CheatsheetEntity cheatsheet = cheatsheetRepository.findById(id);
        if (cheatsheet != null) {
            cheatsheet.setStatus("rejected");
            cheatsheetRepository.update(cheatsheet);
            auditLogService.log(admin, "CheatSheet Rejected", "CheatSheet", id, "Rejected CheatSheet: " + cheatsheet.getTitle(), ipAddress);

            if (cheatsheet.getAuthor() != null) {
                return notificationService.createNotification(
                        cheatsheet.getAuthor().getId(),
                        admin != null ? admin.getId() : null,
                        "Your CheatSheet '" + cheatsheet.getTitle() + "' has been rejected by an administrator.",
                        "CHEATSHEET_REJECTION",
                        "/notifications"
                );
            }
        }
        return null;
    }

    @Override
    @Transactional(readOnly = true)
    public long countBanned() {
        return cheatsheetRepository.countBanned();
    }

    @Override
    @Transactional(readOnly = true)
    public long countPublished() {
        return cheatsheetRepository.countPublished();
    }

    @Override
    @Transactional(readOnly = true)
    public List<CheatSheetReportEntity> getCheatsheetReportData(String startDate, String endDate) {
        return cheatsheetRepository.findCheatsheetReportData(startDate, endDate);
    }
}