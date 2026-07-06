package com.hibernate.entity;

import java.sql.Timestamp;
import javax.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor  // 📌 Hibernate အတွက် မရှိမဖြစ်လိုအပ်သော default constructor ထည့်ပေးခြင်း
@AllArgsConstructor // 📌 အလွယ်တကူ Object ဆောက်ပြီး ဒေတာထည့်နိုင်ရန် constructor ထည့်ပေးခြင်း
@Entity
@Table(name = "categories")
public class CategoryEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(length = 100, nullable = false, unique = true)
    private String name;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private Timestamp createdAt;

    // 📌 UI ဘက်က Badge ပုံစံတွေနဲ့ ကိုက်ညီစေဖို့ Default Value ကို စာလုံးကြီး "ACTIVE" သို့မဟုတ် "INACTIVE" သို့ ပြောင်းလဲပေးထားပါတယ်
    @Column(length = 45)
    private String status = "ACTIVE"; 

    @Transient
    public String getObfuscatedId() {
        return com.hibernate.util.IdObfuscator.encode(this.id);
    }
}