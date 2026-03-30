CREATE OR REPLACE VIEW mongodb_countries_view AS
WITH json_data AS (
    -- Acum Oracle va apela funcția creată la pasul 1
    SELECT get_restheart_countries('http://host.docker.internal:8081/mds/countries', 'admin:secret') AS doc FROM dual
)
SELECT * FROM JSON_TABLE( (SELECT doc FROM json_data) , '$[*]'  
    COLUMNS (
        country_name    VARCHAR2(100) PATH '$.name',
        alpha3_code     VARCHAR2(5)   PATH '$.alpha3',
        region          VARCHAR2(50)  PATH '$.region',
        capital         VARCHAR2(100) PATH '$.capital'
    )
);