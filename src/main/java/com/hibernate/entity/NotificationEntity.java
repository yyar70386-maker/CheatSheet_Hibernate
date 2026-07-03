package com.hibernate.entity;

import java.time.LocalDateTime;
import javax.persistence.*;

import org.hibernate.annotations.CreationTimestamp;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "notifications")
public class NotificationEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    // 🔔 အကြောင်းကြားစာ လက်ခံမည့်သူ (Recipient)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // 👤 လုပ်ဆောင်ချက် ပြုလုပ်သူ (Sender) - ဥပမာ: လာ Follow သည့်သူ
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id")
    private User sender;

    @Column(length = 150)
    private String title;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String message;

    // Default အနေဖြင့် မဖတ်ရသေး (false) ဟု သတ်မှတ်မည်
    @Column(name = "is_read", nullable = false)
    private Boolean isRead = false;
    
    @Column(name = "notification_type", length = 50)
    private String notificationType; // FOLLOW, COMMENT, LIKE, ANNOUNCEMENT

    @Column(name = "link_url")
    private String linkUrl; // နှိပ်လိုက်ရင် သွားမည့် လမ်းကြောင်း

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
