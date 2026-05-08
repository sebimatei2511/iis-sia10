package org.datasource;

import org.dsa.model.entity.CostLiving;
import org.dsa.model.repository.CostLivingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/* REST Service URL pentru proiectul Cost of Living (Postgres):
   http://localhost:8094/rest/cost/CostView
*/

@RestController
@RequestMapping("/cost") // Endpoint-ul de baza pentru acest microserviciu
public class RESTViewServiceJPA {
	private static final Logger logger = Logger.getLogger(RESTViewServiceJPA.class.getName());

	@Autowired
	private CostLivingRepository repository;

	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public String pingDataSource() {
		logger.info(">>>> DSA-SQL-Postgres-Service: Cost Living Service is Up!");
		return "Ping response from Postgres Cost Data Service!";
	}

	@RequestMapping(value = "/CostView", method = RequestMethod.GET,
			produces = {MediaType.APPLICATION_JSON_VALUE})
	public Map<String, List<CostLiving>> get_CostView() {
		logger.info(">>>> Fetching CostLiving data from PostgreSQL (Docker)...");

		// 1. Preluăm toate datele din tabelul COST_LIVING
		List<CostLiving> viewList = this.repository.findAll();

		// 2. Împachetăm datele într-un Map cu cheia "array"
		// Spark SQL va căuta această cheie pentru a crea tabelul virtual
		Map<String, List<CostLiving>> response = new HashMap<>();
		response.put("array", viewList);

		logger.info(">>>> Successfully fetched " + viewList.size() + " records.");
		return response;
	}
}