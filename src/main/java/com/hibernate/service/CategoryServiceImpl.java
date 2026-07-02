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
    public List<CategoryEntity> findAll() {
        // Repository ထဲက findAll() ကို လှမ်းခေါ်ပြီး Controller ဆီ ပြန်ပေးလိုက်ခြင်း
        return repo.findAll();
    }
    @Override
    @Transactional
    public Integer save(CategoryEntity category) {
        return repo.save(category);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CategoryEntity> findAllActive() {
        return repo.findAllActive();
    }

    @Override
    @Transactional(readOnly = true)
    public CategoryEntity findById(Integer id) {
        return repo.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public CategoryEntity findByName(String name) {
        // 📌 ဖြည့်စွက်ချက်: ဒေတာဘေ့စ်ထဲတွင် နာမည်တူရှိမရှိ စစ်ဆေးရန် Repository ထံ ထပ်ဆင့်တောင်းဆိုခြင်း
        return repo.findByName(name);
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

    @Override
    @Transactional(readOnly = true)
    public long countAllActive() {
        return repo.countAllActive();
    }
}
