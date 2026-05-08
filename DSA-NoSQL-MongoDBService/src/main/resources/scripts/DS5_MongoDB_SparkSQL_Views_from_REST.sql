----------------------------------------------------------------------------------
--- DS5_MongoDB_SparkSQL_Countries.sql
----------------------------------------------------------------------------------

-- 1. Crearea View-ului JSON inițial (Sursa: MongoDB Port 8095)
-- Folosim metoda simplă care mapează automat array-ul JSON
SELECT java_method(
               'org.spark.service.rest.RESTEnabledSQLService',
               'createJSONViewFromREST',
               'COUNTRIES_JSON_RAW_V',
               'http://localhost:8095/rest/mongo/CountriesView');

-- Verificăm dacă datele au ajuns în Spark
SELECT * FROM COUNTRIES_JSON_RAW_V;

----------------------------------------------------------------------------------
-- 2. Crearea Vederii Finale (Platizarea datelor)
-- Extragem câmpurile din 'countries.json' (name, region, capital)
-- DROP VIEW countries_view;
CREATE OR REPLACE VIEW countries_view AS
SELECT
    v.name as country_name,
    v.region,
    v.capital,
    v.alpha3 as code
FROM COUNTRIES_JSON_RAW_V as json_view
    LATERAL VIEW explode(json_view.array) AS v;

-- 3. Test Remote View
SELECT * FROM countries_view;

----------------------------------------------------------------------------------
-- 4. ANALIZA CROSS-DATABASE (OLAP)
-- Aici unești tot: Oracle (8092) + Postgres (8094) + MongoDB (8095)
----------------------------------------------------------------------------------
CREATE OR REPLACE VIEW big_data_integration_v AS
SELECT
    s.city,
    s.salary_2020,
    c.x1 as meal_price,
    m.region as continent
FROM SALARII_V s
         INNER JOIN COST_LIVING_V c ON lower(s.city) = lower(c.city)
         INNER JOIN countries_view m ON lower(s.country) = lower(m.country_name);

-- Rezultatul final al proiectului tău
SELECT * FROM big_data_integration_v;