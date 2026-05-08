----------------------------------------------------------------------------------
--- DS_Oracle_Salaries_SparkSQL_Views.sql
----------------------------------------------------------------------------------

-- 1. Verificarea sursei de date brute (Port 8092 pentru Salarii)
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8092/rest/salaries/SalariesView');

-- 2. Definirea Schemei JSON (Exemplu bazat pe datele tale de salarii)
SELECT schema_of_json('[{"id":1, "city":"Bucharest", "country":"Romania", "salary_2020":1500.5}]');

----------------------------------------------------------------------------------
-- 3. Crearea Vederii Remote pentru Salarii
-- DROP VIEW salaries_view;
CREATE OR REPLACE VIEW salaries_view AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<
                        id: INT,
                        city: STRING,
                        country: STRING,
                         salary_2010: DOUBLE,
                          salary_2011: DOUBLE,
                          salary_2012: DOUBLE,
                          salary_2013: DOUBLE,
                          salary_2014: DOUBLE,
                          salary_2015: DOUBLE,
                         salary_2016: DOUBLE,
                         salary_2017: DOUBLE,
                        salary_2018: DOUBLE,
                        salary_2019: DOUBLE,
                        salary_2020: DOUBLE
                     >>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8092/rest/salaries/SalariesView')
        as data) json_raw
)
SELECT v.*
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 4. Testare Vedere Oracle
SELECT * FROM salaries_view ORDER BY salary_2020 DESC;