class CreateGeonamesWithGeojsonMaterializedView < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
        CREATE MATERIALIZED VIEW gazetteer_geonames_with_wof_geojson_mv AS
        SELECT 
            ggn.geoname_id,
            gwg.wok_id,
            ggn.name,
            gwg.source,
            gwg.body
        FROM 
            gazetteer_geonames_names ggn
        JOIN 
            gazetteer_wof_concordances gwc
            ON ggn.geoname_id = gwc.other_id::BIGINT
            AND gwc.other_source = 'gn:id'
        JOIN 
            gazetteer_wof_geojson gwg
            ON gwc.wok_id = gwg.wok_id;
    SQL
  end

  def down
    execute <<-SQL
      DROP MATERIALIZED VIEW IF EXISTS gazetteer_geonames_with_wof_geojson_mv;
    SQL
  end
end
