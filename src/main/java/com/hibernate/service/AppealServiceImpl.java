package com.hibernate.service;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.AppealEntity;
import com.hibernate.entity.CheatsheetEntity;
import com.hibernate.entity.CommentEntity;
import com.hibernate.entity.User;
import com.hibernate.repository.AppealRepository;
import com.hibernate.repository.CheatsheetRepository;
import com.hibernate.repository.CommentRepositoryImpl;
import com.hibernate.repository.UserRepository;

@Service
@Transactional
public class AppealServiceImpl implements AppealService {

    @Autowired
    private AppealRepository appealRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CheatsheetRepository cheatsheetRepository;

    @Autowired
    private CommentRepositoryImpl commentRepository;

    @Override
    public void createAppeal(Integer userId, String targetType, Integer targetId, String reason) {
        User user = userRepository.findById(userId);
        AppealEntity appeal = AppealEntity.builder()
                .user(user)
                .targetType(targetType)
                .targetId(targetId)
                .reason(reason)
                .status("PENDING")
                .build();
        appealRepository.save(appeal);
    }

    @Override
    public List<AppealEntity> getAllPendingAppeals() {
        return appealRepository.findAllPending();
    }

    @Override
    public void resolveAppeal(Integer appealId, String status) {
        AppealEntity appeal = appealRepository.findById(appealId);
        if (appeal != null && appeal.getStatus().equals("PENDING")) {
            appeal.setStatus(status);
            appeal.setResolvedAt(new Timestamp(System.currentTimeMillis()));
            appealRepository.update(appeal);

            if ("APPROVED".equals(status)) {
                if ("CHEATSHEET".equals(appeal.getTargetType())) {
                    CheatsheetEntity sheet = cheatsheetRepository.findById(appeal.getTargetId());
                    if (sheet != null) {
                        sheet.setBanned(false);
                        sheet.setBannedReason(null);
                        sheet.setBannedAt(null);
                        sheet.setBannedBy(null);
                        cheatsheetRepository.update(sheet);
                    }
                } else if ("COMMENT".equals(appeal.getTargetType())) {
                    CommentEntity comment = commentRepository.getById(appeal.getTargetId());
                    if (comment != null) {
                        comment.setDeletedAt(null);
                        comment.setBanned(false);
                        comment.setBannedReason(null);
                        comment.setBannedAt(null);
                        comment.setBannedBy(null);
                        commentRepository.updateComment(comment);
                    }
                }
            }
        }
    }

    @Override
    public List<AppealEntity> getAppealsByUserId(Integer userId) {
        return appealRepository.findByUserId(userId);
    }
}
