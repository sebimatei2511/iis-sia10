package org.datasource;


import org.datasource.mongodb.entity.Countries;
import org.datasource.mongodb.restservice.CountriesRESTService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * REST Service pentru integrarea MongoDB cu Spark SQL.
 * URL: <a href="http://localhost:8095/rest/mongo/CountriesView">...</a>
 */
@RestController
@RequestMapping("/mongo")
public class RESTViewServiceMongoDB {
	private static final Logger logger = Logger.getLogger(RESTViewServiceMongoDB.class.getName());

	// Injectam serviciul care are acces la repository
	@Autowired
	private CountriesRESTService countriesRESTService;

	@GetMapping(value = "/ping", produces = MediaType.TEXT_PLAIN_VALUE)
	public String pingDataSource() {
		logger.info(">>>> NoSQL MongoDB Service is Up!");
		return "Ping response from RESTViewServiceMongoDB (Port 8095)!";
	}

	/**
	 * Endpoint pentru preluarea tarilor din MongoDB.
	 * Rezultatul este impachetat intr-un Map cu cheia "array" pentru Spark SQL.
	 */
	@GetMapping(value = "/CountriesView", produces = MediaType.APPLICATION_JSON_VALUE)
	public Map<String, Object> get_CountriesView() {
		logger.info(">>>> Fetching Countries from MongoDB...");

		try {
			// 1. Apelam serviciul corect (nu pe 'this') pentru a lua lista
			// Presupunem ca CountriesRESTService are o metoda getCountriesList() sau findAll()
			List<Countries> countriesList = countriesRESTService.findAllCountries();

			// 2. Impachetam in formatul "array" cerut de procedura Spark
			Map<String, Object> response = new HashMap<>();
			response.put("array", countriesList);

			logger.info(">>>> Found " + (countriesList != null ? countriesList.size() : 0) + " countries.");
			return response;

		} catch (Exception e) {
			logger.severe(">>>> Error fetching countries: " + e.getMessage());
			Map<String, Object> errorResponse = new HashMap<>();
			errorResponse.put("error", e.getMessage());
			return errorResponse;
		}
	}
}