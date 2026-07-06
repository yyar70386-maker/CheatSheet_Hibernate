# CheatSheet_Hibernate - Real-Time Notification System Explanation

ဤစာတမ်းသည် **CheatSheet_Hibernate** Project တွင် ပါဝင်သော **Real-Time Notification System (အကြောင်းကြားစာစနစ်)** ၏ အလုပ်လုပ်ပုံ၊ Database ချိတ်ဆက်ပုံ၊ Server-Side WebSocket configuration များနှင့် Client-Side (JSP/JavaScript) ချိတ်ဆက်ပုံ (Integration Flow) တို့ကို အသေးစိတ် တည်ဆောက်ပုံဇယားများဖြင့် ရှင်းပြထားခြင်း ဖြစ်သည်။

---

## ဝင်ရောက်ကြည့်ရှုနိုင်သော ဖိုင်
ဖတ်ရှုရန် စီစဉ်ပေးထားသော ဖိုင်လမ်းကြောင်း: [NOTIFICATION_SYSTEM.md](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/NOTIFICATION_SYSTEM.md)

---

## ၁။ စနစ်၏ ရည်ရွယ်ချက်နှင့် စွမ်းဆောင်ရည် (Notification Functions)

ဤစနစ်သည် User များ လုပ်ဆောင်သည့် အောက်ပါ Action များ ဖြစ်ပေါ်လာတိုင်း သက်ဆိုင်ရာ User ဆီသို့ စာမျက်နှာကို refresh လုပ်စရာမလိုဘဲ real-time (ချက်ချင်း) notification တက်လာစေရန် လုပ်ဆောင်ပေးသည်-

* **FOLLOW**: User A က User B ကို follow လုပ်သည့်အခါ User B ဆီသို့ notification ပို့သည်။
* **COMMENT / REPLY**: User A က User B ၏ cheatsheet ပေါ်တွင် comment ရေးလျှင် သော်လည်းကောင်း၊ comment အား reply ပြန်လျှင်သော်လည်းကောင်း ပိုင်ရှင်ဆီသို့ ပို့သည်။
* **SHARE**: User A က User B ၏ cheatsheet အား share လုပ်လိုက်လျှင် User B ဆီသို့ alert ပို့သည်။
* **ANNOUNCEMENT**: Admin မှ စနစ်တစ်ခုလုံးသို့ Announcement ထုတ်ပြန်လိုက်လျှင် **Online ဖြစ်နေသော User အားလုံး**ဆီသို့ တစ်ပြိုင်နက် broadcast ပို့သည်။
* **ADMIN MODERATION**: Admin က Cheatsheet/Comment ကို Ban (ပိတ်ပင်ခြင်း) သို့မဟုတ် Restore (ပြန်ဖွင့်ခြင်း) ပြုလုပ်ပါက သက်ဆိုင်ရာ User ဆီသို့ ပို့သည်။

---

## ၂။ Table & Entity Structure (ဒေတာဘေ့စ် ဒီဇိုင်း)

Notification တိုင်းကို ဒေတာဘေ့စ်တွင် အမြဲသိမ်းဆည်းထားပြီး User က offline ဖြစ်နေသော်လည်း နောက်တစ်ကြိမ် login ဝင်ချိန်တွင် ပြန်ဖတ်နိုင်ရန် [NotificationEntity.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/entity/NotificationEntity.java) ဖြင့် သိမ်းဆည်းသည်။

| Entity Field (Column) | Datatype | အဓိပ္ပာယ် ရှင်းလင်းချက် |
| :--- | :--- | :--- |
| `id` | Integer | Primary Key (Auto Increment) |
| `user` (`user_id`) | User | Notification လက်ခံမည့်သူ (Recipient) |
| `sender` (`sender_id`) | User | Event ဖြစ်ပေါ်အောင် ပြုလုပ်သူ (Sender) - System က ပို့လျှင် `null` ဖြစ်နိုင်သည်။ |
| `title` | String | အကြောင်းကြားစာ ခေါင်းစဉ် (ဥပမာ- "New follower") |
| `message` | String | အကြောင်းကြားစာ အသေးစိတ်စာတန်း |
| `isRead` (`is_read`) | Boolean | User ဖတ်ပြီးပြီလား (Default = `false`) |
| `notificationType` | String | Event အမျိုးအစား (FOLLOW, COMMENT, LIKE, SHARE, ANNOUNCEMENT) |
| `linkUrl` | String | Notification ကို နှိပ်လိုက်လျှင် Browser က သွားမည့် URL လမ်းကြောင်း |
| `createdAt` | DateTime | Notification ပေးပို့သည့် နေ့စွဲအချိန် |

---

## ၃။ Server-Side Connection Layer (ဆာဗာဘက်မှ ချိတ်ဆက်ပုံ)

Notification စနစ်သည် Spring WebSocket ၏ **STOMP (Simple Text Orientated Messaging Protocol)** ကို အသုံးပြုထားသည်။

### က။ Configuration ([WebSocketConfig.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/config/WebSocketConfig.java)):
* **Message Broker**: `/topic` ဟူသော prefix ကို ညွှန်းဆိုပြီး endpoint သတ်မှတ်ထားသည်။
* **SockJS Fallback**: WebSocket ကို browser က support မလုပ်ပါက SockJS library သို့ ပြောင်းလဲချိတ်ဆက်စေရန် `/ws-notifications` ကို SockJS connection point အဖြစ် သတ်မှတ်ထားသည်။

### ခ။ Socket Service ([NotificationSocketService.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/websocket/NotificationSocketService.java)):
* `SimpMessagingTemplate` ကို အသုံးပြုပြီး သီးသန့် User တစ်ယောက်တည်းဆီသို့ ဒေတာတွန်းပို့ရန် `/topic/notifications/{userId}` လမ်းကြောင်းသို့ [NotificationDto](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/dto/NotificationDto.java) payload ကို convert လုပ်၍ ပို့ပေးသည်။

---

## ၄။ Client-Side (JSP / JavaScript) ချိတ်ဆက်ပုံ

စာမျက်နှာများအားလုံး၏ Header ဖြစ်သော [header.jsp](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/webapp/WEB-INF/views/header.jsp#L425) တွင် JavaScript (SockJS + StompClient) ဖြင့် အောက်ပါအတိုင်း ချိတ်ဆက်လုပ်ဆောင်ထားသည်-

### ၁။ ဒေတာဟောင်းများအား ဆွဲဖတ်ခြင်း (AJAX Get Fetch)
စာမျက်နှာ စတင်ပွင့်ချိန်တွင် API Endpoint `/notifications/recent` သို့ လှမ်းခေါ်ပြီး မဖတ်ရသေးသော စုစုပေါင်းအရေအတွက်နှင့် notification စာရင်းဟောင်းများကို dropdown view တွင် ထည့်သွင်းပြသသည်။

### ၂။ WebSocket Real-time Connection
1. `SockJS` ဖြင့် End-point ကို ချိတ်ဆက်သည်:
   ```javascript
   var socket = new SockJS(contextPath + '/ws-notifications');
   var stompClient = Stomp.over(socket);
   ```
2. ချိတ်ဆက်မှု အောင်မြင်ပါက လက်ရှိ Login ဝင်ထားသော `currentUserId` လမ်းကြောင်းကို Subscribe လုပ်သည်:
   ```javascript
   stompClient.subscribe('/topic/notifications/' + currentUserId, function(message){
       var notification = JSON.parse(message.body);
       window.myUnreadCount++; 
       updateBadgeDisplay(); // Badge အရေအတွက်ကို dynamic တိုးမြှင့်ပြသခြင်း
       appendNotification(notification, true); // Dropdown List ထဲသို့ ထည့်ခြင်း
       showNotificationAlert(notification); // Top-right Toast Popup ပြသခြင်း
   });
   ```

---

## ၅။ တစ်ခုနှင့်တစ်ခု ချိတ်ဆက်ပုံ စီးဆင်းမှုပုံရိပ် (Connection Flow)

ဥပမာ- **User A က User B ၏ CheatSheet ကို Share လိုက်သည့်အခါ** ဖြစ်ပေါ်လာသော Flow:

```
[User A Browser] (Clicks Share Button)
       │
       ▼ (HTTP POST /interaction/share-post)
[InteractionController]
       │
       ├─► 1. Save SharedCheatsheetEntity to Database
       │
       ├─► 2. Save NotificationEntity to Database (Recipient = User B, Sender = User A)
       │
       ▼ 3. Notification Service creates NotificationDto & triggers SimpMessagingTemplate
[Spring WebSocket SimpleBroker] (Pushes message to queue: /topic/notifications/{UserB_ID})
       │
       ▼ (Real-time TCP Stream Socket Delivery)
[User B Browser Stomp Listener] (Active connection on header.jsp)
       │
       ├─► Update Notification Badge count (+1) dynamically
       ├─► Prepend new message in the notification dropdown
       └─► Trigger SweetAlert / Toast popup to show: "A shared your cheatsheet!"
```

ဤနည်းလမ်းအတိုင်း လုပ်ငန်းစဉ်တစ်ခုစီ (Like, Comment, Follow, Announcement) တို့သည် Controller/Service Layer မှတစ်ဆင့် Notification Data ကို MySQL DB တွင်အမြဲသိမ်းဆည်းပြီး WebSocket dynamic queue မှတစ်ဆင့် user browser ဆီသို့ ချက်ချင်းလှမ်းပို့ပေးခြင်းဖြင့် အလုပ်လုပ်ဆောင်ပါသည်။
