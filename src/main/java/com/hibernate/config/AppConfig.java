package com.hibernate.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import com.hibernate.interceptor.AdminInterceptor;



@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.hibernate") // Component အားလုံးကို ရှာဖွေဖတ်ရှုရန်
public class AppConfig implements WebMvcConfigurer {
	

    @Autowired
    private AdminInterceptor adminInterceptor;

    /**
     * ၁။ View Resolver ပြင်ဆင်ခြင်း
     * Controller မှ return ပြန်လိုက်သော String နာမည်များကို JSP ဖိုင်များအဖြစ် ပြောင်းလဲပေးသည်။
     */
    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setViewClass(JstlView.class);
        resolver.setPrefix("/WEB-INF/views/"); // JSP ဖိုင်များ ရှိမည့်နေရာ
        resolver.setSuffix(".jsp");            // ဖိုင်အမျိုးအစား extension
        return resolver;
    }

    /**
     * ၂။ Static Resources (CSS, JS, Images) လမ်းကြောင်း သတ်မှတ်ခြင်း
     * Bootstrap သို့မဟုတ် Custom CSS/JS ဖိုင်များကို ခေါ်ယူသုံးစွဲနိုင်ရန်
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");
    }

    /**
     * ၃။ AdminInterceptor ကို စနစ်အတွင်းသို့ ထည့်သွင်းခြင်း
     * /admin/ ဟု စတင်သော လမ်းကြောင်းမှန်သမျှကို Admin ဖြစ်မှသာ ဝင်ခွင့်ပေးရန် စစ်ဆေးမည်။
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(adminInterceptor)
                .addPathPatterns("/admin/**"); // Admin Dashboard လမ်းကြောင်းအားလုံးကို ကာကွယ်ရန်
    }
}