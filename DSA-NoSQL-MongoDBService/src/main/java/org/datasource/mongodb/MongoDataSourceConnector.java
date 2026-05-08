package org.datasource.mongodb;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.bson.types.ObjectId;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MongoDataSourceConnector {
    // MongoDB are nevoie de un camp ID.
    // Folosim ObjectId sau pur si simplu il ignoram daca nu ne trebuie in Spark.
    private ObjectId id;

    private String country_name;
    private String region;
    private String capital;
}