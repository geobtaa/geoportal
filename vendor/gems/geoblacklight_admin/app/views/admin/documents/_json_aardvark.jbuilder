# See GBL Aardvark Schema
# https://docs.google.com/spreadsheets/d/1QQjUzRe8YdPGKK4h0GYoNPTow2zZ1f0KFA0zzZyHAsk/edit?ts=602d52f2#gid=252925024

# Schema
json.dct_title_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:title])
json.dct_alternative_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:alternative_title])
json.dct_description_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:description])
json.dct_language_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:language])
json.dct_creator_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:creator])
json.dct_publisher_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:publisher])
json.schema_provider_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:provider])
json.gbl_resourceClass_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:resource_class])
json.gbl_resourceType_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:resource_type])
json.dct_subject_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:subject])
json.dcat_theme_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:theme])
json.dcat_keyword_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:keyword])
json.dct_temporal_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:temporal_coverage])
json.dct_issued_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_issued])
json.gbl_indexYear_im no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:index_year])
json.gbl_dateRange_drsim no_json_blanks document.date_range_json
json.dct_spatial_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:spatial_coverage])
json.locn_geometry no_json_blanks document.derive_locn_geometry
json.dcat_bbox no_json_blanks document.derive_dcat_bbox
json.dcat_centroid no_json_blanks document.derive_dcat_centroid
json.dct_relation_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:relation])
json.pcdm_memberOf_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:member_of])
json.dct_isPartOf_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:is_part_of])
json.dct_source_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:source])
json.dct_isVersionOf_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:is_version_of])
json.dct_replaces_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:replaces])
json.dct_isReplacedBy_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:is_replaced_by])
json.dct_rights_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:rights])
json.dct_rightsHolder_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:rights_holder])
json.dct_license_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:license])
json.dct_accessRights_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:access_rights])
json.dct_format_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:format])
json.gbl_fileSize_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:file_size])
json.gbl_wxsIdentifier_s no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:wxs_identifier])
json.dct_references_s no_json_blanks document.distributions_json
json.id no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:id])
json.dct_identifier_sm no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:identifier])
json.gbl_mdModified_dt no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:updated_at])
json.gbl_mdVersion_s no_json_blanks "Aardvark"
json.gbl_suppressed_b no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:suppressed_record])
json.gbl_georeferenced_b no_json_blanks document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:georeferenced])
