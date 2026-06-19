package com.hibernate.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestViewController {

    // Browser ကနေ /test-panel လို့ ခေါ်ရင် ဒီ method အလုပ်လုပ်ပါမယ်
    @GetMapping("/test-panel")
    public String showTestPanel() {
        
        // src/main/webapp/WEB-INF/views/ အောက်က test-features.jsp ကို လှမ်းခေါ်ပေးတာပါ
        return "test-features"; 
    }
}