# CheatSheet_Hibernate - Users Following System Analysis & Guide

ဤစာတမ်းသည် **CheatSheet_Hibernate** Project တွင် ပါဝင်သော **Users Following System (အချင်းချင်း Follow/Unfollow ပြုလုပ်ခြင်း)** မည်သို့ အလုပ်လုပ်ပုံ၊ ၎င်း၏ Database Database Table ပတ်သက်မှု၊ Java Entities များနှင့် HQL Logic များ၊ Code Flow နှင့် လက်ရှိကုဒ်ရှိ **လိုအပ်ချက်** များကို အသေးစိတ် သရုပ်ခွဲ ရှင်းပြထားခြင်း ဖြစ်သည်။

---

## ဝင်ရောက်ကြည့်ရှုနိုင်သော ဖိုင်
ဖတ်ရှုရန် စီစဉ်ပေးထားသော ဖိုင်လမ်းကြောင်း: [USER_FOLLOWING_SYSTEM.md](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/USER_FOLLOWING_SYSTEM.md)

---

## ၁။ Database Relationship & Entity Layer (ဒေတာဘေ့စ်နှင့် ချိတ်ဆက်ပုံ)

User တစ်ယောက်နှင့်တစ်ယောက် Follow လုပ်ခြင်းသည် **Many-to-Many** (အသုံးပြုသူများစွာသည် အသုံးပြုသူများစွာကို follow လုပ်နိုင်ခြင်း) ပတ်သက်မှု ဖြစ်သည်။ ဤ Project တွင် ၎င်းကို ကြားခံ Entity ဖြစ်သော [UserFollowEntity.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/entity/UserFollowEntity.java) ဖြင့် ဖွဲ့စည်းတည်ဆောက်ထားသည်။

### Entity Structural Logic:
* **`follower` (သူတစ်ပါးအား follow လုပ်သူ)**: `@ManyToOne` mapping ဖြင့် `User` entity သို့ ချိတ်ဆက်ထားသည်။
* **`following` (follow အလုပ်ခံရသူ)**: `@ManyToOne` mapping ဖြင့် `User` entity သို့ ချိတ်ဆက်ထားသည်။

```
[user_follows Table]
+-------------+-----------------+
| follower_id | -> User (ID)    |
| following_id| -> User (ID)    |
+-------------+-----------------+
```

---

## ၂။ Repository Layer HQL Logics (ဒေတာဘေ့စ် လုပ်ဆောင်ချက်များ)

[UserFollowRepositoryImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/repository/UserFollowRepositoryImpl.java) တွင် Database operation များကို Hibernate SessionFactory ဖြင့် အောက်ပါအတိုင်း ရေးသားထားသည်-

* **Follow (သူငယ်ချင်းအား စတင် follow ခြင်း)**:
  ```java
  User follower = sessionFactory.getCurrentSession().get(User.class, followerId);
  User following = sessionFactory.getCurrentSession().get(User.class, followingId);
  followEntity.setFollower(follower);
  followEntity.setFollowing(following);
  sessionFactory.getCurrentSession().save(followEntity);
  ```
* **Unfollow (Follow ထားခြင်းအား ရပ်စဲခြင်း)**: HQL Delete Query ဖြင့် follower_id နှင့် following_id ကို တိုက်ရိုက်ဖျက်သည်။
  ```sql
  delete from UserFollowEntity f where f.follower.id = :followerId and f.following.id = :followingId
  ```
* **Is Following Checking (Follow လုပ်ထားခြင်းရှိမရှိစစ်ဆေးခြင်း)**:
  ```sql
  select count(f) from UserFollowEntity f where f.follower.id = :followerId and f.following.id = :followingId
  ```
* **Mutual Followers (နှစ်ဦးနှစ်ဖက် အပြန်အလှန် follow ထားသော အရေအတွက်)**: HQL count ဖြင့် တွက်ချက်သည်။

---

## ၃။ Service Layer Logic (လုပ်ငန်းစဉ်ဆိုင်ရာ စည်းမျဉ်းများ)

[UserFollowServiceImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/service/UserFollowServiceImpl.java) တွင် အောက်ပါ Logic သုံးမျိုးကို `@Transactional` boundary အောက်၌ စုစည်းလုပ်ဆောင်သည်-

1. **စစ်ဆေးခြင်း (Validation Check)**:
   * `userFollowRepository.isFollowing(followerId, followingId)` ကို ခေါ်ယူပြီး အကယ်၍ Follow လုပ်ပြီးသား ဖြစ်ပါက ဒေတာ ထပ်မံမသိမ်းဆည်းရန် တားဆီးသည်။
2. **ဒေတာသိမ်းဆည်းခြင်း (Data Persistence)**:
   * စစ်ဆေးချက်အောင်မြင်ပါက `userFollowRepository.follow(followerId, followingId)` ကို သုံး၍ Table တွင် စာရင်းသွင်းသည်။
3. **အကြောင်းကြားစာပေးပို့ခြင်း (Real-time Notification & Audit)**:
   * Follow ခံရသူဆီသို့ "X followed your profile" ဟု database တွင် notification record သွားဆောက်ပြီး Web socket push လုပ်ရန် `NotificationDto` ကို Controller ဆီ ပြန်လည်ပေးပို့သည်။
   * လုပ်ဆောင်ချက်ကို `auditLogService.log(...)` ဖြင့် မှတ်တမ်းတင်သည်။

---

## ၄။ ⚠️ လက်ရှိကုဒ်၏ အဓိက လိုအပ်ချက် (Critical Code Gap)

သင်၏ Frontend View များဖြစ်သော [user-profile.jsp](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/webapp/WEB-INF/views/user-profile.jsp#L181) နှင့် [follow_list.jsp](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/webapp/WEB-INF/views/follow_list.jsp#L97) တို့တွင် Follow/Unfollow ခလုတ်များကို နှိပ်ပါက POST method ဖြင့် အောက်ပါ URL များသို့ Submit လုပ်ရန် ညွှန်းဆိုထားပါသည်-
* `${pageContext.request.contextPath}/follow/{targetUserId}`
* `${pageContext.request.contextPath}/unfollow/{targetUserId}`

သို့သော်လည်း **လက်ရှိ Java Controller Layer တွင် အဆိုပါ URL mappings များကို လက်ခံဖြေရှင်းပေးမည့် Controller Method လုံးဝ မရှိသေးပါ** (အကယ်၍ ယခုအတိုင်း ခလုတ်နှိပ်ပါက Browser တွင် **HTTP 404 / 405 error** တက်မည်ဖြစ်သည်)။

---

## ၅။ ပြင်ဆင်ရန် အကြံပြုချက် (How to implement Controller Mapping)

ဤစနစ် ကောင်းမွန်စွာ လည်ပတ်နိုင်ရန်အတွက် [ProfileController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/ProfileController.java) သို့မဟုတ် Controller အသစ်တစ်ခုတွင် အောက်ပါကုဒ်များကို ဖြည့်စွက်ပေးရန် လိုအပ်ပါသည်-

```java
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.hibernate.dto.NotificationDto;
import com.hibernate.websocket.NotificationSocketService;

// ProfileController ထဲတွင် notificationSocketService အား @Autowired ထည့်သွင်းပါ
@Autowired
private NotificationSocketService notificationSocketService;

// ==================== ➕ Follow Request Handler ====================
@PostMapping("/follow/{id}")
public String followUser(@PathVariable("id") String encodedId, HttpSession session, RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        return "redirect:/login";
    }
    
    Integer targetUserId = com.hibernate.util.IdObfuscator.decode(encodedId);
    if (targetUserId == null) {
        try {
            targetUserId = Integer.parseInt(encodedId);
        } catch (NumberFormatException e) {
            return "redirect:/home";
        }
    }

    // မိမိကိုယ်ကိုယ် follow လုပ်ခြင်းမှ တားဆီးရန်
    if (currentUser.getId().equals(targetUserId)) {
        redirectAttributes.addFlashAttribute("errorMsg", "You cannot follow yourself!");
        return "redirect:/profile/" + encodedId;
    }

    NotificationDto notification = userFollowService.followUser(currentUser.getId(), targetUserId);
    
    // Real-time Notification ပို့ပေးခြင်း
    if (notification != null) {
        notificationSocketService.broadcastToUser(targetUserId, notification);
    }
    
    redirectAttributes.addFlashAttribute("successMsg", "User followed successfully.");
    return "redirect:/profile/" + encodedId;
}

// ==================== ➖ Unfollow Request Handler ====================
@PostMapping("/unfollow/{id}")
public String unfollowUser(@PathVariable("id") String encodedId, HttpSession session, RedirectAttributes redirectAttributes) {
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        return "redirect:/login";
    }
    
    Integer targetUserId = com.hibernate.util.IdObfuscator.decode(encodedId);
    if (targetUserId == null) {
        try {
            targetUserId = Integer.parseInt(encodedId);
        } catch (NumberFormatException e) {
            return "redirect:/home";
        }
    }

    userFollowService.unfollowUser(currentUser.getId(), targetUserId);
    
    redirectAttributes.addFlashAttribute("successMsg", "User unfollowed successfully.");
    return "redirect:/profile/" + encodedId;
}
```

---

## ၆။ အကျဉ်းချုပ် အလုပ်လုပ်ပုံ စီးဆင်းမှု (Full Code Flow Diagram)

```
[Browser UI] (Click Follow Button)
     │
     ▼ (POST /follow/{encodedUserId})
[ProfileController] (Decode targetId -> Validate not self-follow)
     │
     ▼ (userFollowService.followUser(follower, following))
[UserFollowServiceImpl] (Check isFollowing -> Save relation -> Create Follow Notify)
     ├──> [UserFollowRepository] (Hibernate: Save UserFollowEntity to DB)
     ├──> [NotificationService] (Hibernate: Save NotificationEntity to DB)
     └──> [AuditLogService] (Hibernate: Write audit logs)
     │
     ▼ (Return NotificationDto)
[ProfileController] (Call notificationSocketService.broadcastToUser)
     │
     ▼ (Push Event to STOMP Broker)
[WebSocket Broker] ─────────► [Online Followed User Browser] (Real-time SweetAlert!)
```

ဤလေ့လာမှုသည် ယူဆချက်များနှင့် လောဂျစ်များကို လက်တွေ့ အကောင်အထည်ဖော်ရာတွင် အကူအညီဖြစ်စေရန် ရည်ရွယ်ပါသည်။
