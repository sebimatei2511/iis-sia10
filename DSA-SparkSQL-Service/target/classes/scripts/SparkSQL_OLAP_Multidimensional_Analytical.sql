------ Preparing ---------------------------------------------------------------
--- DSA-SQL-JPAService access to: ORCL Data Source SALARIES_DATA (Oracle)
--- DSA-SQL-JDBCService: PostgreSQL Data Source COST_LIVING_DATA (Postgres)
----DSA-NoSQL-MongoDBService COUNTRIES (Mongo)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
--- Dimensions
--- D1: leagă Salariile de Regiunile din Mongo
CREATE OR REPLACE VIEW V_DIM_GEOGRAPHY_HIERARCHY AS
SELECT DISTINCT
    LOWER(TRIM(s.CITY)) AS CITY_KEY, -- Cheia de legătură cu Tabelele de Fapte
    s.CITY AS CITY_NAME,
    s.COUNTRY AS COUNTRY_NAME,
    c.region AS CONTINENT_NAME
FROM SALARIES_DATA s
         JOIN mongodb_countries_view c ON
    LOWER(TRIM(s.COUNTRY)) LIKE '%' || LOWER(TRIM(c.country_name)) || '%'
        OR LOWER(TRIM(c.country_name)) LIKE '%' || LOWER(TRIM(s.COUNTRY)) || '%';
--- D2: identifică dacă un oraș este capitală ---------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_DIM_CITY_STATUS AS
SELECT
    LOWER(TRIM(s.CITY)) AS CITY_KEY,
    CASE
        WHEN LOWER(TRIM(s.CITY)) = LOWER(TRIM(c.capital)) THEN 'Capital City'
        ELSE 'Other City'
        END AS CITY_CATEGORY,
    c.capital AS CAPITAL_NAME
FROM SALARIES_DATA s
         JOIN mongodb_countries_view c ON
    LOWER(TRIM(s.COUNTRY)) LIKE '%' || LOWER(TRIM(c.country_name)) || '%';

-------------------------------------------------------------------------------
--
--- D3:clasifică orașele în Low/Medium/High Income ------------------------------------------------------------
CREATE OR REPLACE VIEW V_DIM_INCOME_BRACKETS AS
SELECT
    LOWER(TRIM(s.CITY)) AS CITY_KEY,
    s.CITY AS CITY_NAME,
    CASE
        WHEN s.AVERAGE_MONTHLY_SALARY_AFTER_TAX_IN_2020 < 1000 THEN 'Low Income (<1000$)'
        WHEN s.AVERAGE_MONTHLY_SALARY_AFTER_TAX_IN_2020 BETWEEN 1000 AND 3000 THEN 'Medium Income (1k-3k$)'
        WHEN s.AVERAGE_MONTHLY_SALARY_AFTER_TAX_IN_2020 BETWEEN 3000 AND 5000 THEN 'High Income (3k-5k$)'
        ELSE 'Ultra-High Income (>5000$)'
        END AS INCOME_SEGMENT
FROM SALARIES_DATA s
WHERE s.AVERAGE_MONTHLY_SALARY_AFTER_TAX_IN_2020 > 0;

-
--- Analytical Views
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_ANALYTIC_REGIONAL_HIERARCHY AS
SELECT
    d.CONTINENT_NAME,
    d.COUNTRY_NAME,
    COUNT(f.CITY_KEY) AS NUMAR_ORASE,
    ROUND(AVG(f.SALARIU_NET), 2) AS MEDIE_SALARIU,
    ROUND(AVG(f.COST_CHIRIE), 2) AS MEDIE_CHIRIE
FROM V_FACT_RENTABILITY_INDEX f
         JOIN V_DIM_GEOGRAPHY_HIERARCHY d ON f.CITY_KEY = d.CITY_KEY
GROUP BY ROLLUP(d.CONTINENT_NAME, d.COUNTRY_NAME);

---
CREATE OR REPLACE VIEW V_ANALYTIC_INCOME_VS_CAPITAL AS
SELECT
    d1.INCOME_SEGMENT,
    d2.CITY_CATEGORY,
    ROUND(AVG(f.RATIO_PUTERE_CUMPARARE), 2) AS PUTERE_CUMPARARE_MEDIE
FROM V_FACT_ECONOMIC_EFFICIENCY f
         JOIN V_DIM_INCOME_BRACKETS d1 ON f.CITY_KEY = d1.CITY_KEY
         JOIN V_DIM_CITY_STATUS d2 ON f.CITY_KEY = d2.CITY_KEY
GROUP BY CUBE(d1.INCOME_SEGMENT, d2.CITY_CATEGORY);

---
--------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_ANALYTIC_TOP_AFFORDABILITY AS
SELECT
    d.INCOME_SEGMENT,
    COUNT(*) AS TOTAL_ORASE,
    ROUND(AVG(f.PROCENT_CHIRIE), 2) AS PROCENT_MEDIU_CHIRIE,
    MIN(f.PROCENT_CHIRIE) AS MIN_POVARA,
    MAX(f.PROCENT_CHIRIE) AS MAX_POVARA
FROM V_FACT_RENTABILITY_INDEX f
         JOIN V_DIM_INCOME_BRACKETS d ON f.CITY_KEY = d.CITY_KEY
GROUP BY d.INCOME_SEGMENT
ORDER BY PROCENT_MEDIU_CHIRIE ASC;
;
---
--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--REST Service URL:
--	http://localhost:9990/DSA-SparkSQL-Service/rest/view/{VIEW_NAME}
--	http://localhost:9990/DSA-SparkSQL-Service/rest/STRUCT/{VIEW_NAME}

-- http://localhost:9990/DSA-SparkSQL-Service/rest/view/OLAP_VIEW_SALES_CTG_PROD_CITIES

