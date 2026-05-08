package org.datasource.mongodb.restservice;

import org.datasource.mongodb.entity.Countries;
import org.datasource.mongodb.repository.CountriesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.logging.Logger;

/**
 * Clasa de tip Service care gestioneaza logica de business pentru entitatea Countries.
 */
@Service
public class CountriesRESTService {
    private static final Logger logger = Logger.getLogger(CountriesRESTService.class.getName());

    @Autowired
    private CountriesRepository repository;

    /**
     * Preluam toate tarile din colectia MongoDB folosind repository-ul.
     * @return Lista de obiecte Countries
     */
    public List<Countries> findAllCountries() {
        logger.info(">>>> Apel repository.findAll() pentru colectia countries...");

        // Aceasta este metoda care lipsea: returnam rezultatul interogarii
        return repository.findAll();
    }

    /**
     * Metoda de verificare a conexiunii la nivel de serviciu.
     */
    public boolean isServiceHealthy() {
        return repository.count() >= 0;
    }
}
