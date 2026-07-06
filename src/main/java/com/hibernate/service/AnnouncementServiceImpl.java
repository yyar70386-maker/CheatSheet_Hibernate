package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.AnnouncementEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.AnnouncementRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AnnouncementServiceImpl implements AnnouncementService {

    private final AnnouncementRepository announcementRepository;
    private final AuditLogService auditLogService;

    @Override
    @Transactional
    public Integer save(AnnouncementEntity announcement, User createdBy) {
        announcement.setCreatedBy(createdBy);
        announcement.setStatus("active");
        Integer id = announcementRepository.save(announcement);
        auditLogService.log(createdBy, "Announcement Posted", "Announcement", id);
        return id;
    }

    @Override
    @Transactional
    public void update(AnnouncementEntity announcement) {
        announcementRepository.update(announcement);
        auditLogService.log(null, "Announcement Updated", "Announcement", announcement.getId());
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        announcementRepository.delete(id);
        auditLogService.log(null, "Announcement Deleted", "Announcement", id);
    }

    @Override
    @Transactional(readOnly = true)
    public AnnouncementEntity findById(Integer id) {
        return announcementRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<AnnouncementEntity> findAllActive() {
        return announcementRepository.findAllActive();
    }

    @Override
    @Transactional(readOnly = true)
    public List<AnnouncementEntity> findAll() {
        return announcementRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<AnnouncementEntity> findLatest(int limit) {
        return announcementRepository.findLatest(limit);
    }

    @Override
    @Transactional(readOnly = true)
    public long countAllActive() {
        return announcementRepository.countAllActive();
    }

    @Override
    @Transactional
    public void updateStatus(Integer id, String status, User admin) {
        announcementRepository.updateStatus(id, status);
        auditLogService.log(admin, "Announcement Status Changed", "Announcement", id,
                "Status changed to " + status + ".", null);
    }
}
