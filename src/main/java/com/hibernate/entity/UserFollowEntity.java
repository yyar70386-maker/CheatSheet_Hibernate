package com.hibernate.entity;

import java.time.LocalDateTime;
import javax.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "user_follows")
@Getter
@Setter
public class UserFollowEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    // 💡 Integer အစား User Object ကို @ManyToOne ဖြင့် ပြောင်းလဲချိတ်ဆက်ပါမည်
    // သင့် User Class ထဲက mappedBy="follower" သည် ဤနေရာက "follower" Property ကို ညွှန်းခြင်းဖြစ်သည်
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "follower_id", nullable = false)
    private User follower;

    // 💡 သင့် User Class ထဲက mappedBy="following" သည် ဤနေရာက "following" Property ကို ညွှန်းခြင်းဖြစ်သည်
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "following_id", nullable = false)
    private User following;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

}