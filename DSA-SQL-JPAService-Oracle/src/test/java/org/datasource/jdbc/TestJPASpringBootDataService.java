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

	// 1. MODIFICĂ PORTUL ȘI CALEA (Port 8092 și context-path /rest)
	private static final String serviceURL = "http://localhost:8092/rest/salarii";
	private final RestTemplate restTemplate = new RestTemplate();

	@Test
	public void test1_get_SalariiView() {
		HttpHeaders headers = new HttpHeaders();
		headers.add(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE);

		// 2. DACĂ AI EXCLUS SECURITATEA ÎN CLASA PRINCIPALĂ, POȚI COMENTA LINIA DE MAI JOS:
		// headers.setBasicAuth("developer", "iis");

		String restDataEndpoint = serviceURL + "/SalariiView";
		logger.info(">>> test1_get_SalariiView REST Data Endpoint: " + restDataEndpoint);

		try {
			ResponseEntity<String> responseEntity = this.restTemplate.exchange(
					restDataEndpoint,
					HttpMethod.GET,
					new HttpEntity<>(null, headers),
					String.class
			);

			logger.info("ResultSet JSON (Salarii): " + responseEntity.getBody());
		} catch (Exception e) {
			logger.severe("EROARE LA TEST: " + e.getMessage());
			throw e;
		}
	}

	@Test
	public void test2_ping() {
		String restDataEndpoint = serviceURL + "/ping";
		logger.info(">>> Testing Ping: " + restDataEndpoint);
		String response = this.restTemplate.getForObject(restDataEndpoint, String.class);
		logger.info("Ping Response: " + response);
	}
}