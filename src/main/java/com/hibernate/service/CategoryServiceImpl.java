package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.CategoryEntity;
import com.hibernate.repository.CategoryRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository repo;

    @Override
    @Transactional
    public Integer save(CategoryEntity category) {
        return repo.save(category);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CategoryEntity> findAll() {
        return repo.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public CategoryEntity findById(Integer id) {
        return repo.findById(id);
    }

    @Override
    @Transactional
    public void update(CategoryEntity category) {
        repo.update(category);
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        repo.delete(id);
    }
}