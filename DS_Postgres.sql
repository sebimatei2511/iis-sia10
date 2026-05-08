-- Pas 1: Invocarea endpoint-ului REST și crearea vederii JSON intermediare
SELECT java_method(
    'org.spark.service.rest.RESTEnabledSQLService',
    'createJSONViewFromREST',
    'vw_cost_living_json',
    'http://localhost:8094/DSA-SQL-PostgresService/rest/cost/CostView'
);

-- Pas 2: Explodarea array-ului JSON într-un tabel SQL structurat
CREATE OR REPLACE VIEW ds_postgres_cost AS
SELECT v.*
FROM vw_cost_living_json AS json_view 
LATERAL VIEW explode(json_view.array) AS v;

-- Testare: SELECT * FROM ds_postgres_cost;