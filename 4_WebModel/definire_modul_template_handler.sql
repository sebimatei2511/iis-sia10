BEGIN
  -- Definirea Modulului
  ORDS.DEFINE_MODULE(
      p_module_name    => 'Analiza_Economica',
      p_base_path      => '/economie/',
      p_items_per_page => 25,
      p_status         => 'PUBLISHED',
      p_comments       => 'Modul pentru statistici salariale'
  );

  -- Definirea Template-ului pentru primul API
  ORDS.DEFINE_TEMPLATE(
      p_module_name    => 'Analiza_Economica',
      p_pattern        => 'raport_venituri'
  );

  -- Definirea Handler-ului (Interogarea SQL care returnează JSON)
  ORDS.DEFINE_HANDLER(
      p_module_name    => 'Analiza_Economica',
      p_pattern        => 'raport_venituri',
      p_method         => 'GET',
      p_source_type    => 'json/query',
      p_source         => 'SELECT * FROM V_ANALYTIC_CLOUD_REPORT',
      p_items_per_page => 0
  );

  COMMIT;
END;
/