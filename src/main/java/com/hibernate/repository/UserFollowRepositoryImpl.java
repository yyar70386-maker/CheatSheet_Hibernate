package com.hibernate.repository;

import java.util.List;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.hibernate.entity.User;
import com.hibernate.entity.UserFollowEntity;

@Repository
public class UserFollowRepositoryImpl implements UserFollowRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void follow(Integer followerId, Integer followingId) {
        // သင့်၏ မူလ follow သွင်းသည့် ကုဒ်တည်ဆောက်ပုံအတိုင်း ရေးရန်
        UserFollowEntity followEntity = new UserFollowEntity();
        
        User follower = sessionFactory.getCurrentSession().get(User.class, followerId);
        User following = sessionFactory.getCurrentSession().get(User.class, followingId);
        
        followEntity.setFollower(follower);
        followEntity.setFollowing(following);
        
        sessionFactory.getCurrentSession().save(followEntity);
    }

    @Override
    public void unfollow(Integer followerId, Integer followingId) {
        String hql = "delete from UserFollowEntity f where f.follower.id = :followerId and f.following.id = :followingId";
        sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("followerId", followerId)
                .setParameter("followingId", followingId)
                .executeUpdate();
    }

    @Override
    public boolean isFollowing(Integer followerId, Integer followingId) {
        String hql = "select count(f) from UserFollowEntity f where f.follower.id = :followerId and f.following.id = :followingId";
        Long count = (Long) sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("followerId", followerId)
                .setParameter("followingId", followingId)
                .uniqueResult();
        return count > 0;
    }

    @Override
    public Long countFollowers(Integer userId) {
        String hql = "select count(f) from UserFollowEntity f where f.following.id = :userId";
        return (Long) sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("userId", userId)
                .uniqueResult();
    }

    @Override
    public Long countFollowing(Integer userId) {
        String hql = "select count(f) from UserFollowEntity f where f.follower.id = :userId";
        return (Long) sessionFactory.getCurrentSession()
                .createQuery(hql)
                .setParameter("userId", userId)
                .uniqueResult();
    }

    // 👥 [ADDED] သင့်အား Follow လုပ်ထားသော User Object များကို HQL ဖြင့် ရှာဖွေခြင်း
    @Override
    public List<User> findFollowersByUserId(Integer userId) {
        String hql = "select f.follower from UserFollowEntity f where f.following.id = :userId";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, User.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    // 🤝 [ADDED] သင်မှ Follow လုပ်ထားသော User Object များကို HQL ဖြင့် ရှာဖွေခြင်း
    @Override
    public List<User> findFollowingByUserId(Integer userId) {
        String hql = "select f.following from UserFollowEntity f where f.follower.id = :userId";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, User.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    public long countAll() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("select count(f) from UserFollowEntity f", Long.class)
                .uniqueResult();
        return count != null ? count : 0;
    }

    @Override
    public long countMutualFollowers(Integer currentUserId, Integer targetUserId) {
        if (currentUserId == null || targetUserId == null) {
            return 0;
        }

        String hql = "select count(f1.id) from UserFollowEntity f1 "
                   + "where f1.following.id = :targetUserId "
                   + "and f1.follower.id in ("
                   + "  select f2.following.id from UserFollowEntity f2 where f2.follower.id = :currentUserId"
                   + ")";

        Long count = sessionFactory.getCurrentSession()
                .createQuery(hql, Long.class)
                .setParameter("targetUserId", targetUserId)
                .setParameter("currentUserId", currentUserId)
                .uniqueResult();
        return count != null ? count : 0;
    }
}
