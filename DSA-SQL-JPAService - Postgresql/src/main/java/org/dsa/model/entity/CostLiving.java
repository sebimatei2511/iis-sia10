package org.dsa.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

/**
 * Entitate pentru maparea tabelului COST_LIVING din PostgreSQL.
 * Aceasta corespunde structurii fisierului cost_living.csv.
 */
@Setter
@Getter
@NoArgsConstructor
@Entity
@Table(name = "COST_LIVING") // Schema default in Postgres este 'public', nu mai e nevoie de schema=...
public class CostLiving implements Serializable {

    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "city")
    private String city;

    @Column(name = "country")
    private String country;

    // Mapam principalii indici de cost.
    // Nota: Intr-un proiect real i-ai pune pe toti 55, aici am pus primii 10 pentru exemplificare.
    @Column(name = "x1") private Double x1;
    @Column(name = "x2") private Double x2;
    @Column(name = "x33") private Double x33;
    @Column(name = "x48") private Double x48;
    @Column(name = "x55") private Double x55;


    @Column(name = "data_quality")
    private Integer dataQuality;
}