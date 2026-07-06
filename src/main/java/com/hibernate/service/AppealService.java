package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.AppealEntity;

public interface AppealService {
    void createAppeal(Integer userId, String targetType, Integer targetId, String reason);
    List<AppealEntity> getAllPendingAppeals();
    void resolveAppeal(Integer appealId, String status);
    List<AppealEntity> getAppealsByUserId(Integer userId);
}
