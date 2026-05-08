package org.dsa.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import java.io.Serializable;


//package org.dsa.model;

//import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

//import java.io.Serializable;

@Setter
@Getter
@Entity
@Table(name = "SALARIES_DATA",schema = "FDBO_Nou")
public class Salarii implements Serializable {

    // Generați Getters și Setters (Alt+Insert în IntelliJ)
    @Id
    @Column(name = "CITY")
    private String city;

    @Column(name = "COUNTRY")
    private String country;

    @Column(name = "SALARY_2010")
    private Double salary2010;

    @Column(name = "SALARY_2011")
    private Double salary2011;

    @Column(name = "SALARY_2012")
    private Double salary2012;

    @Column(name = "SALARY_2013")
    private Double salary2013;

    @Column(name = "SALARY_2014")
    private Double salary2014;

    @Column(name = "SALARY_2015")
    private Double salary2015;

    @Column(name = "SALARY_2016")
    private Double salary2016;

    @Column(name = "SALARY_2017")
    private Double salary2017;

    @Column(name = "SALARY_2018")
    private Double salary2018;

    @Column(name = "SALARY_2019")
    private Double salary2019;

    @Column(name = "SALARY_2020")
    private Double salary2020;



    public Salarii() {}

}