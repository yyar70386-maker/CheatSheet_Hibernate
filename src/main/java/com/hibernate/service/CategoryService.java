package com.hibernate.service;

import java.util.List;

import com.hibernate.entity.CategoryEntity;

public interface CategoryService {

    Integer save(CategoryEntity category);

    List<CategoryEntity> findAll();

    CategoryEntity findById(Integer id);

    void update(CategoryEntity category);

    void delete(Integer id);
}