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
