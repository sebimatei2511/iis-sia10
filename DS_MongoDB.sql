-- Pas 1: Invocarea endpoint-ului REST pentru MongoDB
SELECT java_method(
    'org.spark.service.rest.RESTEnabledSQLService',
    'createJSONViewFromREST',
    'vw_mongo_countries_json',
    'http://localhost:8095/DSA-NoSQL-MongoDBService/rest/mongo/CountriesView'
);

-- Pas 2: Crearea vederii structurate
CREATE OR REPLACE VIEW ds_mongo_countries AS
SELECT v.*
FROM vw_mongo_countries_json AS json_view 
LATERAL VIEW explode(json_view.array) AS v;

-- Testare: SELECT * FROM ds_mongo_countries;