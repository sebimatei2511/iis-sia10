BEGIN
    ORDS.ENABLE_SCHEMA(
        p_enabled             => TRUE,
        p_schema              => 'FDBO',
        p_url_mapping_type    => 'BASE_PATH',
        p_base_path           => 'economie', -- Aceasta este partea din URL: /ords/fdbo/economie/
        p_auto_rest_auth      => FALSE
    );
    COMMIT;
END;
/