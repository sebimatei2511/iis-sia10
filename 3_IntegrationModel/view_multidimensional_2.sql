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
