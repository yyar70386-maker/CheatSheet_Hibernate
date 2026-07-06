package com.hibernate.repository;

import java.util.List;
import com.hibernate.entity.CategoryEntity;

public interface CategoryRepository {

    // Category အသစ်သိမ်းပြီး Generated ID (Integer) ပြန်ပေးမည့် Method
    Integer save(CategoryEntity category);

    // ဒေတာဘေ့စ်ထဲရှိ Category အားလုံးကို List ပုံစံဖြင့် ဆွဲထုတ်မည့် Method
    List<CategoryEntity> findAllActive();

    // ပေးလိုက်သော ID အလိုက် သက်ဆိုင်ရာ Category ကို ရှာဖွေမည့် Method
    CategoryEntity findById(Integer id);

    // 📌 Professional Validation အတွက် ဖြည့်စွက်ချက်:
    // Category နာမည် တူ/မတူ စစ်ဆေးရန် ဒေတာဘေ့စ်ထဲတွင် နာမည်ဖြင့် ရှာဖွေမည့် Method
    CategoryEntity findByName(String name);

    // ရှိပြီးသား Category ဒေတာကို ပြင်ဆင်မည့် Method
    void update(CategoryEntity category);

    // ပေးလိုက်သော ID အလိုက် Category အား ဖျက်ပစ်မည့် Method
    void delete(Integer id);

	List<CategoryEntity> findAll();

    long countAllActive();
}
