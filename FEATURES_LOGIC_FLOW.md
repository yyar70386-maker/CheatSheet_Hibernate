# CheatSheet_Hibernate Project - Detailed Features Logic & Code Flow

ဤစာမျက်နှာသည် **CheatSheet_Hibernate** Project တွင် ပါဝင်သော **Admin Core Features** နှင့် **User Features** များ၏ အလုပ်လုပ်ပုံ (Logic)၊ ကုဒ်တည်ဆောက်ပုံ (Code) နှင့် သွားလာပုံ (Flow) တို့ကို မြန်မာဘာသာဖြင့် သရုပ်ခွဲ ရှင်းပြထားခြင်း ဖြစ်သည်။

---

## ဝင်ရောက်ကြည့်ရှုနိုင်သော ဖိုင်
သင်ကြည့်ရှုနိုင်ရန် စီစဉ်ပေးထားသော ဖိုင်လမ်းကြောင်း: [FEATURES_LOGIC_FLOW.md](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/FEATURES_LOGIC_FLOW.md)

---

## ၁။ Admin Core Features (အုပ်ချုပ်သူအပိုင်း လုပ်ဆောင်ချက်များ)

### က။ User Management (အသုံးပြုသူများ စီမံခန့်ခွဲခြင်း)
* **ရည်ရွယ်ချက်**: System အတွင်းရှိ User များကို စောင့်ကြည့်ပြီး Suspend (ပိတ်ပင်ခြင်း)၊ Role Promoted (Admin အဖြစ်မြှင့်တင်ခြင်း)၊ Account Unlocking (သော့ဖွင့်ပေးခြင်း) နှင့် Delete (ဖျက်သိမ်းခြင်း) လုပ်ဆောင်ရန်။
* **အဓိက Logic**:
  * Action တိုင်းတွင် `@Controller` မှ [AdminUserController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/AdminUserController.java) ၌ `isAdmin()` method ကိုခေါ်ယူပြီး လက်ရှိ session ဝင်ထားသူသည် Admin (role = 1) ဟုတ်မဟုတ် စစ်ဆေးသည်။
  * မိမိကိုယ်ကိုယ် Suspend လုပ်ခြင်း၊ Role ပြောင်းလဲခြင်း သို့မဟုတ် Delete လုပ်ခြင်းများ မဖြစ်စေရန် `currentUser.getId().equals(targetId)` ဖြင့် စစ်ဆေးတားဆီးထားသည်။
  * Action များလုပ်ဆောင်ပြီးတိုင်း `auditLogService.log(...)` ကို ခေါ်ယူပြီး ဘယ် Admin က ဘယ် User ကို ဘာလုပ်လိုက်သည်ကို Database တွင် မှတ်တမ်းတင်သည်။
* **ကုဒ်စီးဆင်းမှု (Code Flow)**:
  ```
  Admin Browser (JSP Post Form) 
      --> [AdminUserController] (isAdmin() Check -> preventSelfAction Check)
      --> [UserService] (suspendUser() / changeUserRole())
      --> [UserRepository] (Hibernate update state)
      --> [AuditLogService] (Save log to audit_logs table)
  ```

---

### ခ။ Cheatsheets Management (Cheatsheet များအား စီမံခန့်ခွဲခြင်း)
* **ရည်ရွယ်ချက်**: User တင်ထားသော Cheatsheet များကို စိစစ်ပြီး Approve (ခွင့်ပြုရန်)၊ Reject (ငြင်းပယ်ရန်)၊ Ban (ပိတ်ပင်ရန်) နှင့် Restore (ပြန်ဖွင့်ပေးရန်) လုပ်ဆောင်ရန်။
* **အဓိက Logic**:
  * [AdminCheatsheetController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/AdminCheatsheetController.java) တွင် User တင်ထားသော Cheatsheet များကို Admin မှ ပျက်ပြယ်အောင် တိုက်ရိုက် Delete လုပ်ခွင့်မရှိပေ။ `isUserSubmitted(sheet)` ကိုသုံးပြီး User ဖန်တီးထားသော အရာဖြစ်ပါက **Ban** သို့မဟုတ် **Restore** သာ လုပ်ခွင့်ပေးပြီး Data Loss မဖြစ်အောင် Logic ဖြင့် ကန့်သတ်ထားသည်။
  * Ban/Restore/Approve/Reject လုပ်လိုက်သည့်အခါ Action ပြီးမြောက်ပါက `NotificationDto` ကို ဖန်တီးပေးပြီး `notificationSocketService.broadcastToUser(userId, notification)` မှတစ်ဆင့် WebSocket ဖြင့် အဆိုပါ Cheatsheet ပိုင်ရှင် User ဆီသို့ Real-time notification ပို့ပေးသည်။
* **ကုဒ်စီးဆင်းမှု (Code Flow)**:
  ```
  Admin Click (Ban/Approve) 
      --> [AdminCheatsheetController] 
      --> [CheatsheetService.banCheatsheet()] (Update status to BANNED in DB)
      --> [NotificationService] (Create notification & return DTO)
      --> [NotificationSocketService] (Broadcast via STOMP to target user's browser)
  ```

---

### ဂ။ Cheatsheets Report (စာရင်းဇယား PDF/Excel ထုတ်ယူခြင်း)
* **ရည်ရွယ်ချက်**: သတ်မှတ်ထားသော ကာလအပိုင်းအခြားအတွင်း တင်ထားသော Cheatsheets များကို Admin ဘက်မှ စာရင်းထုတ်ယူရန်။
* **အဓိက Logic**:
  * [ReportExportController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/ReportExportController.java) တွင် Date filter (startDate, endDate) ကို လက်ခံသည်။
  * `cheatsheetService.getCheatsheetReportData()` မှတစ်ဆင့် Database မှ သက်ဆိုင်ရာ စာရင်းကို ဆွဲထုတ်သည်။
  * **JasperReports Engine** ကို အသုံးပြုပြီး Dynamic `.jrxml` ကို compile လုပ်ကာ PDF file stream သို့မဟုတ် **Apache POI** ၏ `JRXlsxExporter` ကို သုံးပြီး Excel File format ဖြင့် browser ဆီ download ပြန်ချပေးသည်။

---

### ဃ။ Comment Management (မှတ်ချက်များ စီမံခန့်ခွဲခြင်း)
* **ရည်ရွယ်ချက်**: မသင့်တော်သော comment များကို ဖျက်ခြင်း သို့မဟုတ် Ban လုပ်ခြင်း။
* **အဓိက Logic**:
  * [AdminCommentController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/AdminCommentController.java) တွင် Ban လုပ်ပါက comment state ကို BANNED သို့ပြောင်းလဲပြီး၊ စာရေးသူ User ဆီသို့ Comment Banned ဖြစ်သွားကြောင်း real-time notification ပို့သည်။
  * အပြီးသတ်ဖျက်လိုပါက permanent delete ဖြင့် DB မှ ဖယ်ထုတ်သည်။

---

### င။ Announcements (စနစ်သတိပေးချက် ထုတ်ပြန်ခြင်း)
* **ရည်ရွယ်ချက်**: စနစ်အတွင်းရှိ User အားလုံး မြင်နိုင်ရန် Announcement သတင်းထုတ်ပြန်ချက်များ ထုတ်ပြန်ခြင်း။
* **အဓိက Logic**:
  * ဤအပိုင်းသည် **One-to-Many Broadcast** ပုံစံဖြစ်သည်။
  * Admin က Announcement အသစ်တစ်ခု သိမ်းဆည်းလိုက်သည်နှင့် [AnnouncementController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/AnnouncementController.java) မှ `notificationService.createAnnouncementNotifications()` ကိုခေါ်ပြီး **Active User အားလုံး**အတွက် Notification တန်းစီဖန်တီးသည်။
  * ၎င်းနောက် `notificationSocketService.broadcastNotifications(notifications)` ကိုသုံးကာ WebSocket ဖြင့် လက်ရှိ Online ဖြစ်နေသော User အားလုံး၏ client (browser) ဆီသို့ realtime pop-up တက်လာစေသည်။

---

### စ။ Notifications & Audit Logs (အကြောင်းကြားစာနှင့် လှုပ်ရှားမှုမှတ်တမ်း)
* **Notifications**: Admin က User တစ်ဦးတည်းကိုသော်လည်းကောင်း၊ User အားလုံးကိုသော်လည်းကောင်း Notification တိုက်ရိုက် ရေးသားပေးပို့နိုင်သည်။
* **Audit Logs**:
  * Database ထဲရှိ `audit_logs` table တွင် user_id (ဘယ်သူလုပ်တာလဲ)၊ action (ဘာလုပ်တာလဲ)၊ entity_name (ဘယ်အရာကိုလဲ)၊ entity_id (၎င်းရဲ့ key)၊ description (ဖော်ပြချက်) နှင့် ip_address (ပြုလုပ်သူရဲ့ IP) တို့ကို `@Transactional` scope ဖြင့် အမြဲ သိမ်းဆည်းပေးသည်။

---

## ၂။ User Features & Business Logics (အသုံးပြုသူအပိုင်း လုပ်ဆောင်ချက်များ)

### က။ User Following System (အပြန်အလှန် Follow လုပ်ခြင်း)
* **ရည်ရွယ်ချက်**: User အချင်းချင်း follow လုပ်နိုင်ရန်နှင့် သတင်းအချက်အလက် မျှဝေရန်။
* **အဓိက Logic**:
  * [UserFollowServiceImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/service/UserFollowServiceImpl.java) တွင် follow လုပ်သည့်အခါ:
    1. `userFollowRepository.isFollowing(followerId, followingId)` ဖြင့် ယခင်က follow လုပ်ထားခြင်း ရှိမရှိ အရင်စစ်သည်။
    2. Follow မလုပ်ရသေးပါက Database table `user_follows` ထဲသို့ follower-following binding entry သွားထည့်သည်။
    3. Follow ခံရသော target user ဆီသို့ notification record တစ်ခု သွားဆောက်ပြီး ၎င်းအား realtime websocket မှတစ်ဆင့် လှမ်းအကြောင်းကြားသည်။
    4. Audit Log တွင် "User Followed Another User" ဟု မှတ်တမ်းတင်သည်။

---

### ခ။ Popular Cheatsheets Logic (လူကြိုက်အများဆုံး Cheatsheets များတွက်ချက်ပုံ)
* **ရည်ရွယ်ချက်**: Home Screen Dashboard တွင် Popular အဖြစ်ဆုံး cheatsheets များကို ဖော်ပြရန်။
* **အဓိက Logic (အလေးချိန်တွက်ချက်ပုံ)**:
  * ဤသည်မှာ ဤ Project ၏ စိတ်ဝင်စားစရာ အကောင်းဆုံး **HQL Query Formula** ဖြစ်သည်။ လူကြိုက်များမှု ရမှတ် (Popularity Score) ကို အောက်ပါအတိုင်း dynamic အလေးချိန် (Weights) ပေး၍ တွက်ချက်ထားသည်:
    * **Like Reaction Count**: Likes အရေအတွက်ကို **အလေးချိန် 3 ဆ** မြှောက်သည်။
    * **View Count**: Cheatsheet ဖတ်ရှုမှု အကြိမ်ရေကို **1 ဆ** ပေါင်းသည်။
    * **Rating Average Stars**: Cheatsheet ကိုပေးထားသော ကြယ်ပွင့် ပျမ်းမျှတန်ဖိုးကို **အလေးချိန် 10 ဆ** မြှောက်သည်။
  * **HQL Formula (HQL Expression)**:
    ```sql
    select distinct c from CheatsheetEntity c 
    left join fetch c.author left join fetch c.category left join fetch c.tags 
    where c.status = 'active' and c.visibility = 'PUBLIC' 
    order by 
      ((select count(sr) from SheetReactionEntity sr where sr.cheatSheet.id = c.id and sr.isLike = true) * 3 
      + coalesce(c.viewCount, 0) 
      + (select coalesce(avg(r.stars), 0) from RatingEntity r where r.cheatSheet.id = c.id) * 10) desc, 
      c.createdAt desc, c.id desc
    ```
  * ဤတွက်ချက်မှုမှ ထွက်လာသော Score အမြင့်ဆုံး cheatsheet များကို ရွေးထုတ်ပြီး Home screen ပေါ်ရှိ Popular post များအဖြစ် ပြသပေးသည်။

---

### ဂ။ Latest Cheatsheets Logic (နောက်ဆုံးတင်ထားသော Cheatsheets များ)
* **ရည်ရွယ်ချက်**: System အတွင်းသို့ အသစ်တင်လိုက်သော PUBLIC cheatsheet များကို ပထမဆုံး စာမျက်နှာတွင် အရင်မြင်တွေ့နိုင်ရန်။
* **အဓိက Logic**:
  * [CheatsheetRepositoryImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/repository/CheatsheetRepositoryImpl.java) ၏ `findLatestPublic()` တွင်:
    1. Visibility သည် `PUBLIC` ဖြစ်ပြီး Status သည် `active` ဖြစ်သော အရာများကိုသာ စစ်ထုတ်သည်။
    2. Search Keyword ပါဝင်လာပါက `title`, `description` သို့မဟုတ် `content` ထဲတွင် matching ဖြစ်မဖြစ် `like :likeKeyword` ဖြင့် ရှာဖွေပေးသည်။
    3. `order by c.createdAt desc, c.id desc` ဖြင့် နေ့စွဲအသစ်ဆုံးမှ အဟောင်းသို့ စီစဉ်ပေးသည်။
    4. `.setFirstResult((page - 1) * size)` နှင့် `.setMaxResults(size)` ကို သုံးပြီး Pagination (စာမျက်နှာအလိုက်ခွဲပြခြင်း) ကို သေသပ်စွာ လုပ်ဆောင်ထားသည်။

---

ဤကုဒ်များနှင့် လော့ဂျစ်စီးဆင်းမှုများသည် standard Spring MVC architecture အတိုင်း dynamic presentation layer မှတစ်ဆင့် business logic layer သို့ သွားရောက်ကာ Hibernate Session မှတစ်ဆင့် relational database ဆီသို့ တစ်ဆင့်ပြီးတစ်ဆင့် အချိတ်အဆက်မိမိ လုပ်ဆောင်သွားခြင်း ဖြစ်သည်။
