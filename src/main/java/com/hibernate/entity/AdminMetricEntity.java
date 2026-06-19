package com.hibernate.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "admin_metrics")
@Getter
@Setter
public class AdminMetricEntity {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String metricName;
    private Long metricValue;

    // Constructors
    public AdminMetricEntity() {}

    public AdminMetricEntity(String metricName, Long metricValue) {
        this.metricName = metricName;
        this.metricValue = metricValue;
    }
}
