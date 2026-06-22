package com.hibernate.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hibernate.entity.TagEntity;
import com.hibernate.repository.TagRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TagServiceImpl implements TagService {

    private final TagRepository repo;

    @Override
    @Transactional
    public Integer save(TagEntity tag) {
        return repo.save(tag);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findAll() {
        return repo.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public TagEntity findById(Integer id) {
        return repo.findById(id);
    }

    @Override
    @Transactional
    public void update(TagEntity tag) {
        repo.update(tag);
    }

    @Override
    @Transactional
    public void delete(Integer id) {
        repo.delete(id);
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findByCategoryId(Integer categoryId) {
        return repo.findByCategoryId(categoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TagEntity> findByIds(List<Integer> ids) {
        return repo.findByIds(ids);
    }
    
}