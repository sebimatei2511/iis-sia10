----------------------------------------------------------------------------------
--- DS5_MongoDB_SparkSQL_Countries_Views.sql
----------------------------------------------------------------------------------

-- 1. Obținerea schemei JSON pentru Țări (Port 8095)
-- Utile pentru a verifica dacă microserviciul răspunde
SELECT java_method(
               'org.spark.service.rest.QueryRESTDataService',
               'getRESTDataDocument',
               'http://localhost:8095/rest/mongo/CountriesView');

-- Schema extrasă din countries.json (adaptată la formatul tău)
SELECT schema_of_json('[{"name":"Romania","alpha2":"RO","alpha3":"ROU","region":"Europe","capital":"Bucharest"}]');

----------------------------------------------------------------------------------
-- 2. Creare Vedere Remote pentru Țări (Folosind structura ta avansată)
-- Această metodă este mai sigură deoarece definește tipurile de date (STRING)
CREATE OR REPLACE VIEW countries_mongodb_v AS
WITH json_view AS (
    SELECT from_json(json_raw.data,
                     'ARRAY<
                        STRUCT<
                            name: STRING,
                            alpha2: STRING,
                            alpha3: STRING,
                            region: STRING,
                            capital: STRING

                     >>') array
    FROM (SELECT java_method('org.spark.service.rest.QueryRESTDataService', 'getRESTDataDocument',
        'http://localhost:8095/rest/mongo/CountriesView')
        as data) json_raw
)
SELECT v.*
FROM json_view LATERAL VIEW explode(json_view.array) AS v;

----------------------------------------------------------------------------------
-- 3. Testare Vedere
SELECT * FROM countries_mongodb_v WHERE region = 'Europe';

----------------------------------------------------------------------------------
-- 4. Exemplu de JOIN OLAP (Unirea celor 3 lumi: Oracle, Postgres, MongoDB)
-- Aici demonstrezi utilitatea proiectului P2
CREATE OR REPLACE VIEW olap_global_report AS
SELECT
    s.city,
    s.country as country_name,
    s.salary_2020 as salary,
    c.x1 as restaurant_price,
    m.region as continent
FROM salarii_v s
         INNER JOIN cost_living_v c ON lower(s.city) = lower(c.city)
         INNER JOIN countries_mongodb_v m ON lower(s.country) = lower(m.name);

SELECT * FROM olap_global_report;