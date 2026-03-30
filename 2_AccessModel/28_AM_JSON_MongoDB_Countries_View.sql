--------------------------------------------------------------------------------
-- 28_AM_JSON_MongoDB_Countries_View.sql
-- Rulează acest script în Oracle (FDBO) pentru a vedea datele din MongoDB
--------------------------------------------------------------------------------

-- 1. Definim funcția de ajutor pentru comunicarea cu RESTHeart (dacă nu e deja creată)
CREATE OR REPLACE FUNCTION get_restheart_countries(pURL VARCHAR2, pUserPass VARCHAR2) 
RETURN clob IS
  l_req   UTL_HTTP.req;
  l_resp  UTL_HTTP.resp;
  l_buffer clob; 
BEGIN
  l_req  := UTL_HTTP.begin_request(pURL);
  -- RESTHeart folosește autentificare Basic (implicit admin:secret)
  UTL_HTTP.set_header(l_req, 'Authorization', 'Basic ' || 
    UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(UTL_I18N.string_to_raw(pUserPass, 'AL32UTF8')))); 
  l_resp := UTL_HTTP.get_response(l_req);
  UTL_HTTP.READ_TEXT(l_resp, l_buffer);
  UTL_HTTP.end_response(l_resp);
  RETURN l_buffer;
EXCEPTION
  WHEN OTHERS THEN
    IF l_buffer IS NOT NULL THEN UTL_HTTP.end_response(l_resp); END IF;
    RAISE;
END;
/

-- 2. Creăm Vizualizarea care mapează JSON-ul din Mongo în coloane Oracle
CREATE OR REPLACE VIEW mongodb_countries_view AS
WITH json_data AS (
    -- Adresa URL către colecția din Mongo via RESTHeart
    -- Presupunem: DB 'mds' și Collection 'countries'
    SELECT get_restheart_countries('http://host.docker.internal:8081/mds/countries', 'admin:secret') AS doc FROM dual
)
SELECT *
FROM JSON_TABLE( (SELECT doc FROM json_data) , '$[*]'  
            COLUMNS (
                country_name    VARCHAR2(100) PATH '$.name',
                alpha2_code     VARCHAR2(5)   PATH '$.alpha2',
                alpha3_code     VARCHAR2(5)   PATH '$.alpha3',
                region          VARCHAR2(50)  PATH '$.region',
                capital         VARCHAR2(100) PATH '$.capital',
                dial_code       VARCHAR2(10)  PATH '$.dialCode',
                -- Extragem date din obiectul imbricat "geo"
                latitude        NUMBER        PATH '$.geo.lat',
                longitude       NUMBER        PATH '$.geo.long'
            )
);

-- Testăm vizualizarea
SELECT country_name, capital, region, latitude FROM mongodb_countries_view WHERE ROWNUM <= 10;