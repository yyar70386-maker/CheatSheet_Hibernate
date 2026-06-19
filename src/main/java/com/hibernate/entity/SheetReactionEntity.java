package com.hibernate.entity;

import javax.persistence.*;
import lombok.Data;

@Entity
@Table(name = "sheet_reactions")
@Data
public class SheetReactionEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private Boolean isLike;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cheatsheet_id", nullable = false)
    private CheatSheetEntity cheatSheet;
}