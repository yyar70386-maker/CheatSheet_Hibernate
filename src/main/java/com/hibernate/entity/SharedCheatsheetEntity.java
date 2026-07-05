package com.hibernate.entity;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.*;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
@Entity
@Table(name = "shared_cheatsheets")
public class SharedCheatsheetEntity implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user; // မိတ်ဆွေရဲ့ User Entity Class အမည်နှင့် ကိုက်ညီပါစေ

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cheatsheet_id", nullable = false)
    private CheatsheetEntity cheatsheet; // မိတ်ဆွေရဲ့ Cheatsheet Entity Class အမည်နှင့် ကိုက်ညီပါစေ

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "shared_at", insertable = false, updatable = false)
    private Date sharedAt;

    
}