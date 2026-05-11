--------------------------------------------------------------------------------
--- SparkSQL_OLAP.sql - MODEL ANALITIC MULTIDIMENSIONAL (Java4DI)
--- Integrare: Oracle (Salaries) + Postgres (Cost Living) + MongoDB (Countries)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 1. TABELA DE FAPTE (Facts)
-- Combină metricile brute: Salariul (Oracle) și Costurile (Postgres)
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_FACT_ECONOMIC_INDICATORS AS
SELECT 
    LOWER(TRIM(s.city)) AS city_key,
    s.salary_amount AS salariu_net,
    p.x1 AS pret_masa,
    p.x48 AS pret_chirie,
    ROUND(s.salary_amount / p.x1, 2) AS ratio_purchasing_power,
    ROUND((p.x48 / s.salary_amount) * 100, 2) AS procent_povara_chirie
FROM ds_oracle_salaries s
JOIN ds_postgres_cost p ON LOWER(TRIM(s.city)) = LOWER(TRIM(p.city));

--------------------------------------------------------------------------------
-- 2. DIMENSIUNI (Dimensions)
--------------------------------------------------------------------------------

-- D1: Ierarhia Geografică (Oraș -> Țară -> Continent din MongoDB)
CREATE OR REPLACE VIEW V_DIM_GEOGRAPHY AS
SELECT DISTINCT
    LOWER(TRIM(s.city)) AS city_key,
    s.city AS city_name,
    s.country AS country_name,
    m.region AS continent_name
FROM ds_oracle_salaries s
JOIN ds_mongo_countries m ON LOWER(TRIM(s.country)) = LOWER(TRIM(m.country_name));

-- D2: Segmente de Venit (Clasificare bazată pe nivelul salariului)
CREATE OR REPLACE VIEW V_DIM_INCOME_BRACKETS AS
SELECT 
    city_key,
    CASE 
        WHEN salariu_net < 1000 THEN 'Low Income'
        WHEN salariu_net BETWEEN 1000 AND 3000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS income_segment
FROM V_FACT_ECONOMIC_INDICATORS;

--------------------------------------------------------------------------------
-- 3. VEDERI ANALITICE (Analytical Views - ROLLUP / CUBE)
--------------------------------------------------------------------------------

-- Raport 1: Ierarhia regională (ROLLUP) - De la Continent la Oraș
CREATE OR REPLACE VIEW OLAP_VIEW_REGIONAL_ANALYSIS AS
SELECT 
    g.continent_name,
    g.country_name,
    AVG(f.salariu_net) as medie_salariu,
    AVG(f.ratio_purchasing_power) as medie_putere_cumparare
FROM V_FACT_ECONOMIC_INDICATORS f
JOIN V_DIM_GEOGRAPHY g ON f.city_key = g.city_key
GROUP BY ROLLUP (g.continent_name, g.country_name)
ORDER BY 1, 2;

-- Raport 2: Analiză Cross-Tab (CUBE) - Venit vs Continent
CREATE OR REPLACE VIEW OLAP_VIEW_INCOME_VS_REGION AS
SELECT 
    i.income_segment,
    g.continent_name,
    COUNT(*) as nr_orase,
    AVG(f.procent_povara_chirie) as medie_povara_chirie
FROM V_FACT_ECONOMIC_INDICATORS f
JOIN V_DIM_GEOGRAPHY g ON f.city_key = g.city_key
JOIN V_DIM_INCOME_BRACKETS i ON f.city_key = i.city_key
GROUP BY CUBE (i.income_segment, g.continent_name)
ORDER BY 1, 2;

--------------------------------------------------------------------------------
-- 4. TESTARE FINALA
--------------------------------------------------------------------------------
SELECT * FROM OLAP_VIEW_REGIONAL_ANALYSIS;
SELECT * FROM OLAP_VIEW_INCOME_VS_REGION;
-------------------------------------------------------------------------
integrarea a 3 tehnologii diferite (SQL, NoSQL, Documente).
-----------------------------------------------------------------------------
CREATE OR REPLACE VIEW view_olap_salary_analysis AS
SELECT 
    s.City, 
    c.region as Continent,
    s.`Average Monthly Salary after Tax in 2020` as Net_Salary,
    cl.meal_price as Cost_of_Meal,
    (s.`Average Monthly Salary after Tax in 2020` / cl.meal_price) as Purchasing_Power_Index
FROM view_salaries_doc s
JOIN view_countries_mongo c ON s.Country = c.name
JOIN view_cost_living_doc cl ON s.City = cl.city
WHERE s.`Average Monthly Salary after Tax in 2020` > 0;
