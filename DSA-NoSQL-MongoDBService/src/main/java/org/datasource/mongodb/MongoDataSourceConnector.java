package org.datasource.mongodb;
import org.springframework.stereotype.Service;
import org.springframework.web.context.annotation.ApplicationScope;
import jakarta.persistence.*;

@Service
@ApplicationScope // Garantează că există o singură instanță pe toată durata aplicației
public class MongoDataSourceConnector {


    @PersistenceContext
    private EntityManager em;

    public EntityManager getEntityManager(){
        return em;
    }
}

