package org.datasource;



import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@SpringBootApplication
@EnableMongoRepositories(basePackages = "org.datasource.mongodb.repository") // <--- ADAUGĂ ASTA
public class SpringBootNoSQLMongoDBService {
	public static void main(String[] args) {
		SpringApplication.run(SpringBootNoSQLMongoDBService.class, args);
	}
}