package com.hibernate.entity;

import javax.persistence.*;
import lombok.Data;

@Entity
@Table(name = "ratings")
@Data
public class RatingEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private Integer stars; // ဥပမာ - ၁ ကနေ ၅ အထိ

  
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // MG Thiri ရဲ့ CheatSheet Class နဲ့ ချိတ်ဆက်ခြင်း
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cheatsheet_id", nullable = false)
    private CheatSheetEntity cheatSheet;
}