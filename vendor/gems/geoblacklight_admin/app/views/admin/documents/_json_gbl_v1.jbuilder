# See OpenGeoMetadata Legacy Versions
# https://opengeometadata.org/docs/gbl-1.0

# Required
json.geoblacklight_version "1.0"
json.dc_identifier_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:identifier]).join("|")
json.dc_rights_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:access_rights])
json.dc_title_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:title])
json.dct_provenance_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:provider])
json.layer_slug_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:id])
json.solr_geom no_json_blanks document.derive_dcat_bbox

# Recommended
json.solr_year_i no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:index_year])&.first
json.dc_creator_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:creator])
json.dc_description_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:description]).join("|")
json.dc_format_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:format])
json.dc_subject_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:subject])
json.dct_references_s no_json_blanks document.distributions_json
json.dct_spatial_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:spatial_coverage])
json.layer_modified_dt no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:updated_at])

# Optional
json.dc_language_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:language])
json.dc_publisher_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:publisher]).join("|")
json.dc_source_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:source])
json.dct_issued_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_issued])
json.dct_temporal_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:temporal_coverage])
json.layer_id_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:wxs_identifier])
json.suppressed_b no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:suppressed_record])
