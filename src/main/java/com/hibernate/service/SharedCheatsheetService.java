package com.hibernate.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.hibernate.entity.SharedCheatsheetEntity;
import com.hibernate.repository.SharedCheatsheetRepository;

@Service
@Transactional
public class SharedCheatsheetService {

    @Autowired
    private SharedCheatsheetRepository sharedRepository;

    public boolean sharePost(SharedCheatsheetEntity shared) {
        // အရင် Share ပြီးသားလား စစ်ထုတ်ပြီး မရှိမှ Save မည်
        if (sharedRepository.isAlreadyShared(shared.getUser().getId(), shared.getCheatsheet().getId())) {
            return false; 
        }
        sharedRepository.save(shared);
        return true;
    }

    @Transactional(readOnly = true)
    public List<SharedCheatsheetEntity> getAllSharedPosts() {
    	return sharedRepository.findAllSharedWithDetails();
    }
}