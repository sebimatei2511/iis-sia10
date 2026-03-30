--------------------------------------------------------------------------------
-- 26_AM_POSTGREST_CostLiving_View.sql
-- Rulează acest script în Oracle (FDBO) pentru a vedea datele din Postgres
--------------------------------------------------------------------------------

CREATE OR REPLACE VIEW cost_living_rest_view AS
WITH rest_doc AS (
    -- Adresa de unde Oracle "trage" datele prin PostgREST (containerul Postgres)
    SELECT HTTPURITYPE.createuri('http://host.docker.internal:3000/cost_of_living')
    .getclob() AS doc FROM dual
)
SELECT *
FROM JSON_TABLE( (SELECT doc FROM rest_doc) , '$[*]'  
            COLUMNS (
                id           NUMBER(10)     PATH '$.id',
                city         VARCHAR2(100)  PATH '$.city',
                country      VARCHAR2(100)  PATH '$.country',
                -- x1 reprezintă de obicei o masă la un restaurant ieftin
                meal_price   NUMBER(10,2)   PATH '$.x1',
                -- x2 reprezintă o masă pentru 2 persoane la un restaurant mediu
                dinner_price NUMBER(10,2)   PATH '$.x2',
                -- x48 reprezintă chiria medie pentru un apartament cu 1 dormitor
                rent_price   NUMBER(10,2)   PATH '$.x48',
                -- x54 reprezintă salariul mediu net (pentru verificare)
                salary_ref   NUMBER(10,2)   PATH '$.x54'
            )
);

-- Testăm dacă vedem datele din Postgres direct în Oracle
SELECT * FROM cost_living_rest_view WHERE ROWNUM <= 10;