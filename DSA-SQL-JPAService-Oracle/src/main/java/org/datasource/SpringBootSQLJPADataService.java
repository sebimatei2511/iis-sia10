package org.datasource;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.boot.autoconfigure.domain.EntityScan;

import java.util.logging.Logger;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
// 1. ComponentScan: Găsește Controller-ele și Serviciile din ambele ierarhii
@ComponentScan(basePackages = {"org.datasource", "org.dsa"})
// 2. EnableJpaRepositories: Găsește interfața SalariiRepository
@EnableJpaRepositories(basePackages = "org.dsa.model.repository")
// 3. EntityScan: Găsește clasa @Entity Salarii
@EntityScan(basePackages = "org.dsa.model.entity")

public class SpringBootSQLJPADataService extends SpringBootServletInitializer {
	private static final Logger logger = Logger.getLogger(SpringBootSQLJPADataService.class.getName());

	public static void main(String[] args) {
		logger.info("Loading ... SpringBootSQLJPADataService Default Settings ... JPA");
		SpringApplication.run(SpringBootSQLJPADataService.class, args);
	}
}