----------------------------------------------------------------------------------
--- DS2_ORACLE_SparkSQL_Salaries_Views.sql
--- Port: 8092 | Path: /rest/salaries/SalariesView
----------------------------------------------------------------------------------

-- 1. Crearea vederii JSON brute din microserviciul de Oracle
-- Metoda 'createJSONViewFromREST' detecteaza automat campurile din 'array'
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'SALARIES_JSON_RAW_V',
               'http://localhost:8092/rest/salaries/SalariesView');

-- Verificam daca Spark vede datele din Oracle
SELECT * FROM SALARIES_JSON_RAW_V;

----------------------------------------------------------------------------------
-- 2. Crearea vederii SQL Finale (Platizarea datelor)
-- Extragem campurile reale din baza ta de date Oracle
-- DROP VIEW salaries_view;
CREATE OR REPLACE VIEW salaries_view AS
SELECT
    v.id,
    v.city,
    v.country,
    v.salary_2020 as salary
FROM SALARIES_JSON_RAW_V as json_view
    LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 3. Testare Vedere Salarii
SELECT * FROM salaries_view ORDER BY salary DESC;