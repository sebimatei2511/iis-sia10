package org.datasource.mongodb.repository;


import org.datasource.mongodb.entity.Countries;

import java.util.List;

public interface CountriesRepository {
    List<Countries> findAll();

    int count();
}
