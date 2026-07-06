# CheatSheet_Hibernate - PDF/Excel Export & Stored Procedures Explanation

ဤစာတမ်းသည် **CheatSheet_Hibernate** Project တွင် ပါဝင်သော **PDF/Excel Report Export (အစီရင်ခံစာထုတ်ယူခြင်းစနစ်)** နှင့် **MySQL Stored Procedures (ဒေတာဘေ့စ် လုပ်ထုံးလုပ်နည်းများ)** ၏ အလုပ်လုပ်ပုံ (Logic)၊ ကုဒ်တည်ဆောက်ပုံ (Code) နှင့် Database ချိတ်ဆက်ပုံတို့ကို အသေးစိတ် ရှင်းပြထားခြင်း ဖြစ်သည်။

---

## ဝင်ရောက်ကြည့်ရှုနိုင်သော ဖိုင်
ဖတ်ရှုရန် စီစဉ်ပေးထားသော ဖိုင်လမ်းကြောင်း: [REPORT_AND_SP_EXPLANATION.md](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/REPORT_AND_SP_EXPLANATION.md)

---

## ၁။ PDF & Excel Export System (JasperReports & Apache POI)

ဤ Project သည် Admin Dashboard တွင် Cheatsheet စာရင်းဇယားများကို PDF သို့မဟုတ် Excel ဖိုင်အဖြစ် Download ရယူနိုင်ရန် **JasperReports (6.21.0)** နှင့် **Apache POI** တို့ကို ပေါင်းစပ်အသုံးပြုထားသည်။

### က။ PDF Export Logic ([ReportExportController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/ReportExportController.java#L73))
1. **Data Retrieval**: `cheatsheetService.getCheatsheetReportData(startDate, endDate)` ကို ခေါ်ယူပြီး Date filter အတွင်းရှိ ဒေတာစာရင်းများကို `CheatSheetReportEntity` List အဖြစ် ဆွဲထုတ်သည်။
2. **Template Compiling**: `/WEB-INF/reports/CheatSheetReport.jrxml` (XML template) ဖိုင်ကို ဖတ်ယူပြီး `JasperCompileManager.compileReport()` ဖြင့် binary Java Report object အဖြစ် compile လုပ်သည်။
3. **Data Filling**: Dynamic parameters များ (ခေါင်းစဉ်၊ ထုတ်ယူသည့်အချိန်) နှင့် Java Object List ကို `JRBeanCollectionDataSource` ထဲသို့ ထည့်သွင်းပြီး `JasperFillManager.fillReport()` ဖြင့် `JasperPrint` ကို ထုတ်လုပ်သည်။
4. **Streaming to Browser**: Output configuration တွင် `response.setContentType("application/pdf")` ကို သတ်မှတ်ကာ `JasperExportManager.exportReportToPdfStream()` ဖြင့် User browser ဆီသို့ PDF dynamic file အဖြစ် တိုက်ရိုက် stream တွန်းပို့ပေးသည်။

---

### ခ။ Excel (XLSX) Export Logic ([ReportExportController.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/controller/ReportExportController.java#L125))
PDF ကဲ့သို့ပင် `JasperPrint` ကို အရင်ထုတ်လုပ်သော်လည်း Excel formats နှင့် ကိုက်ညီစေရန် **Apache POI** base ဖြစ်သော `JRXlsxExporter` ကို အသုံးပြုသည်။
* **ဆဲလ် (Cell) ပုံစံညှိနှိုင်းမှု (Excel Layout Configuration)**:
  * empty spaces များအားလုံးကို ဖယ်ရှားပေးသော configuration များကို သုံးထားသည်:
    ```java
    SimpleXlsxReportConfiguration configuration = new SimpleXlsxReportConfiguration();
    configuration.setOnePagePerSheet(false); // စာမျက်နှာတစ်ခုစီအား Sheet တစ်ခုစီမခွဲရန်
    configuration.setRemoveEmptySpaceBetweenRows(true); // Row ကြား အလွတ်များဖယ်ရှားရန်
    configuration.setRemoveEmptySpaceBetweenColumns(true); // Column ကြား အလွတ်များဖယ်ရှားရန်
    configuration.setWhitePageBackground(false); // background အဖြူရောင်ဖျောက်ရန်
    configuration.setDetectCellType(true); // ဒေတာအမျိုးအစား (ဥပမာ- ကိန်းဂဏန်း) အား auto စစ်ဆေးရန်
    ```

---

## ၂။ Database Query & Mappings (Native SQL & ResultTransformer)

ဒေတာဘေ့စ်ရှိ React Counts (Likes/Dislikes) စုစုပေါင်းနှင့် Left Join များကို မြန်ဆန်စွာ တွက်ချက်နိုင်ရန်အတွက် Repository Layer တွင် standard HQL အစား **Native SQL Query** ကို အသုံးပြုထားသည်။

### HQL/SQL Query ([CheatsheetRepositoryImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/repository/CheatsheetRepositoryImpl.java#L322)):
```sql
SELECT c.id, c.title, u.username, c.created_at, 
(SELECT COUNT(*) FROM sheet_reactions sr WHERE sr.cheatsheet_id = c.id) AS reaction_count 
FROM cheatsheets c 
LEFT JOIN users u ON c.author_id = u.id 
WHERE c.deleted_at IS NULL
-- Date filters (startDate, endDate) conditions are appended dynamically.
```

### Java Object (ORM Model) သို့ Mapping လုပ်ပုံ:
Native query ဖြစ်သောကြောင့် database tuple များကို `CheatSheetReportEntity` သို့ mapping လုပ်ပေးရန် Hibernate ၏ `ResultTransformer` ကို သုံးထားသည်:
```java
return query.setResultTransformer(new ResultTransformer() {
    @Override
    public Object transformTuple(Object[] tuple, String[] aliases) {
        CheatSheetReportEntity report = new CheatSheetReportEntity();
        report.setNo(((Number) tuple[0]).intValue());
        report.setCheatsheetName((String) tuple[1]);
        report.setCreatedUser((String) tuple[2]);
        java.sql.Timestamp ts = (java.sql.Timestamp) tuple[3];
        report.setCreatedDate(ts != null ? ts.toString() : "");
        Number rc = (Number) tuple[4];
        report.setReactionCount(rc != null ? rc.longValue() : 0L);
        return report;
    }
    // ...
}).list();
```

---

## ၃။ MySQL Stored Procedures (ဒေတာဘေ့စ် လုပ်ထုံးလုပ်နည်းများ)

ဤ Project တွင် Category အောက်ရှိ Active Tags များနှင့် ၎င်းတို့၏ Cheatsheet အရေအတွက်ကို privacy (လုံခြုံရေးစည်းမျဉ်း) စိစစ်ပြီး လျင်မြန်စွာ တွက်ချက်ရန် **MySQL Stored Procedure** ကို အသုံးပြုထားသည်။

### က။ ဘယ်နေရာမှာ သုံးထားတာလဲ
* [CheatsheetRepositoryImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/repository/CheatsheetRepositoryImpl.java#L30) ရှိ `callStoredProcedureForTagCounts()` method တွင် သုံးထားသည်-
  ```java
  return getSession()
          .createNativeQuery("CALL GetActiveTagCountsWithPrivacy(:catId, :userId)")
          .setParameter("catId", categoryId)
          .setParameter("userId", currentUserId != null ? currentUserId : 0)
          .list();
  ```

### ခ။ ဘယ်လိုအလုပ်လုပ်လဲ (Stored Procedure Logic)
1. **Input Parameters**: `catId` (ဘယ် category အောက်ကလဲ) နှင့် `userId` (လက်ရှိဝင်ထားသူရဲ့ ID) ကို ယူသည်။
2. **Privacy / Visibility Filtering**:
   * Stored Procedure (MySQL database engine) အတွင်း၌ User ဆီသို့ tag counts များတွက်ထုတ်ပေးရာတွင် **Public cheatsheets များကိုသာ တွက်ချက်မည်**။
   * သို့သော် လက်ရှိ `userId` သည် Cheatsheet ပိုင်ရှင်ဖြစ်ပါက ၎င်း၏ **Private cheatsheets များကိုပါ ပေါင်းထည့်တွက်ချက်မည်**။
   * Friend relationship ရှိပါက **Friend-only sheets များကိုပါ ပေါင်းထည့်တွက်ချက်မည်**။
3. **Java integration**: Stored Procedure မှ တွက်ချက်ပေးလိုက်သော list (`List<Object[]>`) ကို Service Layer [CheatsheetServiceImpl.java](file:///c:/Users/DELL/eclipse-workspace/CheatSheet_Hibernate/src/main/java/com/hibernate/service/CheatsheetServiceImpl.java#L38) က ဖတ်ယူပြီး dynamic tag name တွင် အရေအတွက်ကို ပူးတွဲပြသပေးသည် (ဥပမာ- `Java (15)`)။

---

## ၄။ Export & DB Connection Architecture Flow

```
[Admin Web Browser] (Clicks PDF/Excel Export button)
         │
         ▼ (HTTP GET /admin/reports/cheatsheet/pdf)
[ReportExportController] ──► Java configuration set header & content type
         │
         ▼ (cheatsheetService.getCheatsheetReportData)
[CheatsheetServiceImpl]
         │
         ▼ (cheatsheetRepository.findCheatsheetReportData)
[CheatsheetRepositoryImpl] ──► Execute Native SQL View Query to MySQL DB
         │
         ▼ (Returns ResultSet / Raw Database rows)
[ResultTransformer] ──► Convert DB rows to CheatSheetReportEntity List
         │
         ▼ (Java List returns to Controller)
[JasperReports Engine] (Compile CheatSheetReport.jrxml -> Fill Data Sources)
         │
         ├───► Export to PDF Stream ──► response.getOutputStream()
         └───► Exporter to Excel Stream ──► JRXlsxExporter output
```

ဤနည်းလမ်းများသည် ဒေတာများကို ပိုမိုမြန်ဆန်စွာ စစ်ထုတ်နိုင်ပြီး ဒေတာဘေ့စ်၏ စွမ်းဆောင်ရည်ကို အကောင်းဆုံး အသုံးချနိုင်ရန် တည်ဆောက်ထားခြင်း ဖြစ်သည်။
