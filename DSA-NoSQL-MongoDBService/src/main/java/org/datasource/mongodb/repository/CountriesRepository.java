package org.datasource.mongodb.repository;


import org.datasource.mongodb.entity.Countries;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CountriesRepository extends MongoRepository<Countries, String> {
    // String trebuie să fie tipul ID-ului din clasa Countries
}