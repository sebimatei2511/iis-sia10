CREATE OR REPLACE VIEW cost_living_rest_view AS
WITH rest_doc AS (
    SELECT HTTPURITYPE.createuri('http://host.docker.internal:3000/cost_of_living').getclob() AS doc FROM dual
)
SELECT * FROM JSON_TABLE( (SELECT doc FROM rest_doc) , '$[*]'  
    COLUMNS (
        city         VARCHAR2(100)  PATH '$.city',
        country      VARCHAR2(100)  PATH '$.country',
        meal_price   NUMBER(10,2)   PATH '$.x1',
        rent_price   NUMBER(10,2)   PATH '$.x48'
    )
);