package org.dsa.model.restservice;


import org.dsa.model.entity.Salarii;
import org.dsa.model.repository.SalariiRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class SalariiRESTService {

    @Autowired
    private SalariiRepository repository; // Legătura cu baza de date

    @GetMapping("/salarii/SalariiView")
    public Map<String, List<Salarii>> getSalariiView() {
        List<Salarii> lista = repository.findAll(); // Execută SELECT * FROM SALARIES_DATA
        Map<String, List<Salarii>> response = new HashMap<>();
        response.put("array", lista); // SparkSQL caută cheia "array"
        return response;
    }
}