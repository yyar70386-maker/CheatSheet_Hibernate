package com.hibernate.entity;

import javax.persistence.*;
import lombok.Data;

@Entity
@Table(name = "favorites")
@Data
public class FavoriteEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // Ko Htun Hla ရဲ့ User Class
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // MG Thiri ရဲ့ CheatSheet Class
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cheatsheet_id", nullable = false)
    private CheatSheetEntity cheatSheet;
}