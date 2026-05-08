package org.datasource;

import org.dsa.model.entity.Salarii;
import org.dsa.model.repository.SalariiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/* REST Service URL pentru proiectul Salarii:
    http://localhost:8092/rest/salarii/SalariiView
*/

@RestController
@RequestMapping("/salarii") // Rădăcina serviciului pentru salarii
public class RESTViewServiceJPA {
	private static final Logger logger = Logger.getLogger(RESTViewServiceJPA.class.getName());

	@Autowired
	private SalariiRepository repository;

	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public String pingDataSource() {
		logger.info(">>>> DSA-SQL-JPAService: Salarii Service is Up!");
		return "Ping response from Salarii Data Service!";
	}

	@RequestMapping(value = "/SalariiView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE})
	public Map<String, List<Salarii>> get_SalariiView() {
		logger.info(">>>> Fetching SalariiView data from Oracle...");

		// 1. Preluăm datele prin Repository
		List<Salarii> viewList = this.repository.findAll();

		// 2. Împachetăm datele pentru Spark SQL (cerința cheii "array")
		Map<String, List<Salarii>> response = new HashMap<>();
		response.put("array", viewList);

		return response;
	}
}