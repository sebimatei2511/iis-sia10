package org.datasource.mongodb.entity;



import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.io.Serializable;

/**
 * Clasa entitate pentru maparea colectiei "countries" din MongoDB.
 * Aceasta structura corespunde fisierului countries.json.
 */
@Setter
@Getter
@NoArgsConstructor
@Document(collection = "countries")
public class Countries implements Serializable {

    @Id
    private String id; // ID-ul unic generat de MongoDB (_id)

    @Field("name")
    private String name; // Numele tarii


    @Field("alpha2")
    private String alpha2; // Codul de 2 litere

    @Field("alpha3")
    private String alpha3; // Codul de 3 litere


    @Field("region")
    private String region; // Continentul

    @Field("capital")
    private String capital; // Capitala


}