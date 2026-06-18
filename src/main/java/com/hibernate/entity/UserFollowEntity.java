package com.hibernate.entity;

import java.time.LocalDateTime;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "user_follows")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserFollowEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer follower_id;
	private Integer following_id;
	private LocalDateTime createdAt;

}
