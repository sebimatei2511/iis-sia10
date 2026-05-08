----------------------------------------------------------------------------------
--- DS_Postgres_CostLiving_SparkSQL.sql
----------------------------------------------------------------------------------

-- 1. Verificarea documentului JSON brut (Port 8094)
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8094/rest/cost/CostView');

-- 2. Definirea Schemei (bazată pe câmpurile din entitatea ta CostLiving)
-- Am inclus ID, City, Country și câțiva indici X
SELECT schema_of_json('[{"id":1,"city":"Kabul","country":"Afghanistan","x1":0.55,"x2":1.26,"dataQuality":1}]');

----------------------------------------------------------------------------------
-- 3. Crearea Vederii Remote (Cea mai sigură metodă cu STRUCT)
-- DROP VIEW cost_living_view;
CREATE OR REPLACE VIEW cost_living_view AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<STRUCT<
                        id: INT,
                        city: STRING,
                        country: STRING,
                        x1: DOUBLE,
                        x2: DOUBLE,
                        x33: DOUBLE,
                        x48: DOUBLE,
                        x55: DOUBLE
                     >>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8094/rest/cost/CostView')
        as data) json_raw
)
SELECT v.*
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 4. Testare Vedere Postgres
SELECT * FROM cost_living_view WHERE lower(country) = 'romania';