package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.AppealEntity;

public interface AppealRepository {
    Integer save(AppealEntity appeal);
    AppealEntity findById(Integer id);
    void update(AppealEntity appeal);
    List<AppealEntity> findAllPending();
    List<AppealEntity> findByUserId(Integer userId);
    List<AppealEntity> findByTarget(String targetType, Integer targetId);
}
