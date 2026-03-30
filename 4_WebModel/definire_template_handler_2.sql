BEGIN
  -- Definirea Template-ului pentru al doilea API
  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'Analiza_Economica',
      p_pattern        => 'detalii_salarii'
  );

  -- Definirea Handler-ului pentru date brute
  ORDS.DEFINE_HANDLER(
      p_module_name    => 'Analiza_Economica',
      p_pattern        => 'detalii_salarii',
      p_method         => 'GET',
      p_source_type    => 'json/query',
      p_source         => 'SELECT * FROM V_FACT_SALARY_STATS',
      p_items_per_page => 0
  );

  COMMIT;
END;
/