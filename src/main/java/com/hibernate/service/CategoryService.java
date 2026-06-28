package com.hibernate.service;

import java.util.List;
import com.hibernate.entity.CategoryEntity;

public interface CategoryService {

    // Category အသစ်သိမ်းဆည်းမည့် Method
    Integer save(CategoryEntity category);

    // ဒေတာဘေ့စ်ထဲရှိ Category အားလုံးကို ဆွဲထုတ်မည့် Method ( findAll() တစ်ခုတည်းဖြင့် စံနှုန်းသတ်မှတ်လိုက်ပါသည် )
    List<CategoryEntity> findAllActive();

    // ID အလိုက် သက်ဆိုင်ရာ Category ကို ရှာဖွေမည့် Method
    CategoryEntity findById(Integer id);

    // 📌 Professional Validation အတွက် ဖြည့်စွက်ချက်:
    // Controller ဘက်ကနေ နာမည်တူရှိမရှိ စစ်ဆေးနိုင်ရန် Service Layer တွင်ပါ ထည့်သွင်းပေးလိုက်ခြင်း ဖြစ်ပါသည်။
    CategoryEntity findByName(String name);

    // ရှိပြီးသား Category ဒေတာကို ပြင်ဆင်မည့် Method
    void update(CategoryEntity category);

    // ပေးလိုက်သော ID အလိုက် Category အား (Soft Delete) ဖျက်ပစ်မည့် Method
    void delete(Integer id);

	List<CategoryEntity> findAll();
}