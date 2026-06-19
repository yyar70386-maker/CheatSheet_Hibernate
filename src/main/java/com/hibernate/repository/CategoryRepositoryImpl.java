package com.hibernate.repository;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.CategoryEntity;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class CategoryRepositoryImpl implements CategoryRepository {

    private final SessionFactory sessionFactory;

    public Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Integer save(CategoryEntity category) {
        return (Integer) getSession().save(category);
    }

    @Override
    public List<CategoryEntity> findAll() {
        return getSession()
                .createQuery("from CategoryEntity where status='active'", CategoryEntity.class)
                .list();
    }

    @Override
    public CategoryEntity findById(Integer id) {
        return getSession().get(CategoryEntity.class, id);
    }

    @Override
    public void update(CategoryEntity category) {
        CategoryEntity oldCategory = findById(category.getId());

        if (oldCategory != null) {
            oldCategory.setName(category.getName());
            getSession().update(oldCategory);
        }
    }

    @Override
    public void delete(Integer id) {
        CategoryEntity category = findById(id);

        if (category != null) {
            category.setStatus("inactive");
            getSession().update(category);
        }
    }
}