----------------------------------------------------------------------------------
--- DS2_POSTGRES_SparkSQL_CostLiving_Views.sql
----------------------------------------------------------------------------------

-- 1. Crearea vederii JSON brute din REST (Port 8094)
-- Metoda 'createJSONViewFromREST' va genera automat schema pe baza obiectului 'array' returnat de Java
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'COST_LIVING_JSON_RAW_V',
               'http://localhost:8094/rest/cost/CostView');

-- Verificăm dacă datele brute sunt vizibile
SELECT * FROM COST_LIVING_JSON_RAW_V;

----------------------------------------------------------------------------------
-- 2. Crearea vederii SQL finale (platizarea array-ului)
-- DROP VIEW cost_living_view;
CREATE OR REPLACE VIEW cost_living_view AS
SELECT
    v.id,
    v.city,
    v.country,
    v.x1 as meal_price,
    v.x2 as water_price
FROM COST_LIVING_JSON_RAW_V as json_view
    LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 3. Testarea vederii
SELECT * FROM cost_living_view LIMIT 10;