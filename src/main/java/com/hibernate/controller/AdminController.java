package com.hibernate.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.hibernate.entity.AdminMetricEntity;
import com.hibernate.entity.User;
import com.hibernate.service.AdminService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
    @Autowired
    private AdminService adminService;

    @GetMapping("/dashboard")
    public String showAdminDashboard(Model model) {
        // 1. Metrics Counter (ဥပမာ- Total Users Count) ကို ဆွဲထုတ်ပြီး Model ထဲထည့်ခြင်း
        List<AdminMetricEntity> metrics = adminService.getDashboardMetrics();
        model.addAttribute("metrics", metrics);
        
        //  ဒီနေရာမှာ သင့် AdminService ထဲက ရှိပြီးသား method နာမည်အတိုင်း getAllUsers() လို့ ပြောင်းလဲပြင်ဆင်ထားပါတယ်
        List<User> userList = adminService.getAllUsers();
        model.addAttribute("users", userList);
        
        // /WEB-INF/views/admin-dashboard.jsp သို့ ပြသရန် ညွှန်းပို့ခြင်း
        return "admin-dashboard";
    }
}
