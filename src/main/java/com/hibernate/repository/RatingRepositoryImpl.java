package com.hibernate.repository;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.RatingEntity;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class RatingRepositoryImpl implements RatingRepository {
    private final SessionFactory sessionFactory;
    public Session getSession() { return sessionFactory.getCurrentSession(); }

    @Override public Integer insertRating(RatingEntity obj) { return (Integer) getSession().save(obj); }
    @Override public void updateRating(RatingEntity obj) { getSession().update(obj); }
    @Override public void deleteRating(RatingEntity obj) { getSession().delete(obj); } // 🌟 Rating ဖြုတ်ရန် အသစ်

    @Override
    public RatingEntity getByUserAndSheetId(Integer userId, Integer cheatSheetId) {
        String hql = "FROM RatingEntity r WHERE r.user.id = :userId AND r.cheatSheet.id = :cheatSheetId";
        return getSession().createQuery(hql, RatingEntity.class)
                .setParameter("userId", userId).setParameter("cheatSheetId", cheatSheetId).uniqueResult();
    }

    @Override
    public Double getAverageRatingBySheetId(Integer sheetId) {
        String hql = "SELECT AVG(CAST(r.stars as double)) FROM RatingEntity r WHERE r.cheatSheet.id = :sheetId";
        Double avg = (Double) getSession().createQuery(hql).setParameter("sheetId", sheetId).uniqueResult();
        return avg != null ? Math.round(avg * 10.0) / 10.0 : 0.0; 
    }
}