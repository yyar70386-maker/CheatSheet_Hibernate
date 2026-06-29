package com.hibernate.repository;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.FavoriteEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class FavoriteRepositoryImpl implements FavoriteRepository {
    
    private final SessionFactory sessionFactory;
    
    public Session getSession() { 
        return sessionFactory.getCurrentSession(); 
    }

    @Override
    public Integer insertFavorite(FavoriteEntity obj) { 
        return (Integer) getSession().save(obj); 
    }

    @Override
    public void deleteFavorite(FavoriteEntity obj) { 
        getSession().delete(obj); 
    }

    @Override
    public FavoriteEntity getByUserIdAndSheetId(Integer userId, Integer cheatSheetId) {
        String hql = "FROM FavoriteEntity f WHERE f.user.id = :uId AND f.cheatSheet.id = :cId";
        return getSession().createQuery(hql, FavoriteEntity.class)
                .setParameter("uId", userId)
                .setParameter("cId", cheatSheetId)
                .uniqueResult();
    }
}