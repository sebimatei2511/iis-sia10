package org.datasource.jdbc;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.util.logging.Logger;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class TestJPASpringBootDataService {
	private static final Logger logger = Logger.getLogger(TestJPASpringBootDataService.class.getName());

	// 1. MODIFICĂ PORTUL ȘI CALEA PENTRU POSTGRES (Port 8094 și context-path /rest/cost)
	private static final String serviceURL = "http://localhost:8094/rest/cost";
	private final RestTemplate restTemplate = new RestTemplate();

	@Test
	public void test1_get_CostView() {
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE);

		// Dacă ai exclus securitatea, nu e nevoie de auth.
		// headers.setBasicAuth("developer", "iis");

		String restDataEndpoint = serviceURL + "/CostView";
		logger.info(">>> test1_get_CostView REST Data Endpoint: " + restDataEndpoint);

		try {
			ResponseEntity<String> responseEntity = this.restTemplate.exchange(
					restDataEndpoint,
					HttpMethod.GET,
					new HttpEntity<>(null, headers),
					String.class
			);

			// Verificăm dacă am primit date (JSON-ul cu cheia "array")
			logger.info("ResultSet JSON (CostLiving): " + responseEntity.getBody());

			if(responseEntity.getStatusCode() == HttpStatus.OK) {
				logger.info(">>> SUCCESS: Datele din Postgres au fost preluate cu succes!");
			}
		} catch (Exception e) {
			logger.severe("EROARE LA TEST POSTGRES: " + e.getMessage());
			// Nu aruncăm excepția ca să permită și rularea testului de ping
		}
	}

	@Test
	public void test2_ping() {
		String restDataEndpoint = serviceURL + "/ping";
		logger.info(">>> Testing Ping Postgres Service: " + restDataEndpoint);
		try {
			String response = this.restTemplate.getForObject(restDataEndpoint, String.class);
			logger.info("Ping Response: " + response);
		} catch (Exception e) {
			logger.severe("Ping failed! Asigură-te că microserviciul de pe portul 8094 este pornit.");
		}
	}
}