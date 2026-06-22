package com.hibernate.repository;

import java.util.List;

import com.hibernate.entity.TagEntity;

public interface TagRepository {

    Integer save(TagEntity tag);

    List<TagEntity> findAll();

    TagEntity findById(Integer id);

    void update(TagEntity tag);

    void delete(Integer id);
    
    List<TagEntity> findByCategoryId(Integer categoryId);

    List<TagEntity> findByIds(List<Integer> ids);
}