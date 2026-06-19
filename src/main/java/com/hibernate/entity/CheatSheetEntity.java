package com.hibernate.entity;

import javax.persistence.*;
import lombok.Data;

@Entity
@Table(name = "cheatsheets")
@Data
public class CheatSheetEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // ယာယီ Run လို့ရအောင် Title လေးတစ်ခုပဲ ထည့်ထားပါမယ်
    @Column(nullable = false)
    private String title; 

    // လောလောဆယ် တခြား field တွေ မလိုသေးပါဘူး
}