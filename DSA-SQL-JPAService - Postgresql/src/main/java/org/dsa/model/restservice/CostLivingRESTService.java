package org.dsa.model.restservice;

import org.dsa.model.entity.CostLiving;
import org.dsa.model.repository.CostLivingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/rest/cost")
public class CostLivingRESTService{

    @Autowired
    private CostLivingRepository repository;

    @GetMapping("/CostView")
    public List<CostLiving> getCostLiving() {
        return repository.findAll();
    }
}