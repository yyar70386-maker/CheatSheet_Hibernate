package com.hibernate.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.Getter;

import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="notifications")
public class NotificationEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name =)
	private Integer user_id;

	@Column(columnDefinition = "TEXT")
	private String message;

	private Boolean isRead;
	private String notificationType;

	private String linkUrl;

	private LocalDateTime createdAt;

}
