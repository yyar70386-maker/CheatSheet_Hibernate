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
	@JoinColumn(name = "user_id")
	private User user_id;

	@Column(columnDefinition = "TEXT")
	private String message;

	@Column(name ="is_read")
	private Boolean isRead;
	
	@Column(name = "notification_type")
	private String notificationType;

	
	@Column(name = "linkUrl")
	private String linkUrl;

	@Column(name ="created_at")
	private LocalDateTime createdAt;

}
