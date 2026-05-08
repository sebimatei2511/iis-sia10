-- Pas 1: Invocarea endpoint-ului REST pentru Salarii
SELECT java_method(
    'org.spark.service.rest.RESTEnabledSQLService',
    'createJSONViewFromREST',
    'vw_oracle_salaries_json',
    'http://localhost:8092/DSA-SQL-OracleService/rest/salaries/SalariesView'
);

-- Pas 2: Crearea vederii structurate
CREATE OR REPLACE VIEW ds_oracle_salaries AS
SELECT v.*
FROM vw_oracle_salaries_json AS json_view 
LATERAL VIEW explode(json_view.array) AS v;