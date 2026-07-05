
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
    
    @Column(name = "share_count")
    private Integer shareCount = 0;
    
    @Column(name = "visibility", columnDefinition = "ENUM('PUBLIC','PRIVATE','FRIEND-ONLY')")
    private String visibility = "PUBLIC";

    @Column(name = "status", length = 45)
    private String status = "active";

    @Column(name = "banned", nullable = false)
    private Boolean banned = false;
    
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
    
    
    
    
    @OneToMany(mappedBy = "cheatsheet", fetch = FetchType.LAZY) // EAGER မှ LAZY သို့
    @BatchSize(size = 20) // ဤ Annotation ကို ထည့်ပေးပါ
    private List<SharedCheatsheetEntity> sharedList;

    @Transient
    public int getSharedCount() {
        if (this.sharedList != null) {
            return this.sharedList.size();
        }
        return 0;
    }
}