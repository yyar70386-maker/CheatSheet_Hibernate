package com.hibernate.entity;

import java.sql.Timestamp;
import java.util.List;

import javax.persistence.*;

import org.hibernate.annotations.BatchSize;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "cheatsheets")
public class CheatsheetEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "author_id")
    private User author;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private CategoryEntity category;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "description", nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(name = "content", nullable = false, columnDefinition = "LONGTEXT")
    private String content;

    @Column(name = "download_count")
    private Integer downloadCount = 0;

    @Column(name = "view_count")
    private Integer viewCount = 0;

    // 🌟 [FIXED] ပျောက်ဆုံးနေသော shareCount Field အား ပြန်လည်ထည့်သွင်းပေးခဲ့သည် (ဒါမှ setShareCount အလုပ်လုပ်မည်)
    @Column(name = "share_count")
    private Integer shareCount = 0;

    @Column(name = "visibility", columnDefinition = "ENUM('PUBLIC','PRIVATE','FRIEND-ONLY')")
    private String visibility = "PUBLIC";

    @Column(name = "status", length = 45)
    private String status = "active";

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private Timestamp createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private Timestamp updatedAt;

    @ManyToMany
    @JoinTable(
        name = "cheatsheet_tags",
        joinColumns = @JoinColumn(name = "sheet_id"),
        inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<TagEntity> tags;

    @Column(name = "banned", nullable = false)
    private boolean banned = false;

    @Column(name = "banned_reason", length = 500)
    private String bannedReason;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "banned_by")
    private User bannedBy;

    @Column(name = "banned_at")
    private Timestamp bannedAt;

    @Column(name = "deleted_at")
    private Timestamp deletedAt;

    @Column(name = "image_path", length = 255)
    private String imagePath;

    // 🌟 [FIXED] မင်းသူငယ်ချင်းရေးထားသော ပတ်သက်ဆက်နွယ်မှုအပိုင်းများ ပြန်လည်ဖြည့်စွက်ပေးထားသည်
    @OneToMany(mappedBy = "cheatsheet", fetch = FetchType.LAZY)
    @BatchSize(size = 20)
    private List<SharedCheatsheetEntity> sharedList;

    @Transient
    public int getSharedCount() {
        if (this.sharedList != null) {
            return this.sharedList.size();
        }
        return 0;
    }

    @Transient
    public String getObfuscatedId() {
        return com.hibernate.util.IdObfuscator.encode(this.id);
    }
}