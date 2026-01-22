# frozen_string_literal: true

# @TODO
# - Centroids
# - GeoNames
module GeoblacklightAdmin
  class FieldMappingsGblv1
    def self.call
      {
        dc_title_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:title],
          delimited: false,
          transformation_method: nil
        },
        alternativeTitle_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:alternative_title],
          delimited: true,
          transformation_method: nil
        },
        dct_alternativeTitle_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:alternative_title],
          delimited: true,
          transformation_method: nil
        },
        dc_description_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:description],
          delimited: false,
          transformation_method: nil
        },
        dc_language_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:language],
          delimited: true,
          transformation_method: nil
        },
        dc_language_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:language],
          delimited: true,
          transformation_method: nil
        },
        dc_publisher_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:publisher],
          delimited: true,
          transformation_method: nil
        },
        dc_publisher_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:publisher],
          delimited: true,
          transformation_method: nil
        },
        dc_creator_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:creator],
          delimited: true,
          transformation_method: nil
        },
        b1g_genre_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:resource_class],
          delimited: true,
          transformation_method: nil
        },
        dc_subject_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:subject],
          delimited: true,
          transformation_method: nil
        },
        b1g_keyword_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:keyword],
          delimited: true,
          transformation_method: nil
        },
        dct_issued_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:date_issued],
          delimited: false,
          transformation_method: nil
        },
        dct_temporal_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:temporal_coverage],
          delimited: true,
          transformation_method: nil
        },
        b1g_date_range_drsim: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:date_range],
          delimited: true,
          transformation_method: nil
        },
        dct_spatial_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:spatial_coverage],
          delimited: true,
          transformation_method: nil
        },
        b1g_geonames_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:geonames],
          delimited: true,
          transformation_method: nil
        },
        solr_geom: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:geometry],
          delimited: false,
          transformation_method: nil
        },
        dc_format_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:format],
          delimited: false,
          transformation_method: nil
        },
        layer_geom_type_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:resource_type],
          delimited: false,
          transformation_method: nil
        },
        layer_id_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:wxs_identifier],
          delimited: false,
          transformation_method: nil
        },
        dct_references_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:reference],
          delimited: false,
          transformation_method: "build_dct_references"
        },
        b1g_image_ss: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:b1g_image_url],
          delimited: false,
          transformation_method: nil
        },
        dc_identifier_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:identifier],
          delimited: false,
          transformation_method: nil
        },
        layer_slug_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:id],
          delimited: false,
          transformation_method: nil
        },
        dct_provenance_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:provider],
          delimited: false,
          transformation_method: nil
        },
        b1g_code_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:code],
          delimited: false,
          transformation_method: nil
        },
        dct_isPartOf_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:is_part_of],
          delimited: true,
          transformation_method: nil
        },
        dc_source_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:source],
          delimited: true,
          transformation_method: nil
        },
        dct_accrualMethod_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:accrual_method],
          delimited: false,
          transformation_method: nil
        },
        "Accrual Periodicity": {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:accrual_periodicity],
          delimited: false,
          transformation_method: nil
        },
        b1g_lastHarvested_dt: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:last_harvested],
          delimited: false,
          transformation_method: nil
        },
        b1g_isHarvested_b: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:is_harvested],
          delimited: false,
          transformation_method: nil
        },
        b1g_adminNote_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:admin_note],
          delimited: true,
          transformation_method: nil
        },
        b1g_deprioritized_b: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:deprioritized],
          delimited: false,
          transformation_method: nil
        },
        b1g_dct_provenance_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:provenance],
          delimited: true,
          transformation_method: nil
        },
        b1g_websitePlatform_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:website_platform],
          delimited: false,
          transformation_method: nil
        },
        b1g_harvestWorkflow_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:harvest_workflow],
          delimited: false,
          transformation_method: nil
        },
        b1g_dateAccessioned_dt: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:date_accessioned],
          delimited: false,
          transformation_method: nil
        },
        b1g_dateRetired_dt: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:date_retired],
          delimited: false,
          transformation_method: nil
        },
        dc_rights_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:rights],
          delimited: false,
          transformation_method: nil
        },
        dct_accessRights_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:access_rights],
          delimited: true,
          transformation_method: nil
        },
        suppressed_b: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:suppressed_record],
          delimited: false,
          transformation_method: nil
        },
        solr_year_i: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:index_year],
          delimited: false,
          transformation_method: nil
        },
        layer_modified_dt: {
          destination: "layer_modified_dt",
          delimited: false,
          transformation_method: nil
        },
        dct_mediator_sm: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:mediator],
          delimited: false,
          transformation_method: nil
        },
        score: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        cugir_category_sm: {
          destination: "cugir_category_sm",
          delimited: false,
          transformation_method: nil
        },
        solr_bboxtype: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        b1g_access_s: {
          destination: GeoblacklightAdmin::Schema.instance.solr_fields[:access],
          delimited: false,
          transformation_method: nil
        },
        geoblacklight_version: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        nyu_addl_dspace_s: {
          destination: "nyu_addl_dspace_s",
          delimited: false,
          transformation_method: nil
        },
        b1g_collection_sm: {
          destination: "b1g_collection_sm",
          delimited: false,
          transformation_method: nil
        },
        georss_polygon_s: {
          destination: "georss_polygon_s",
          delimited: false,
          transformation_method: nil
        },
        dct_accrual_sm: {
          destination: "dct_accrual_sm",
          delimited: false,
          transformation_method: nil
        },
        solr_bboxtype__maxX: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        solr_bboxtype__minX: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        solr_bboxtype__maxY: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        solr_bboxtype__minY: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        call_number_s: {
          destination: "call_number_s",
          delimited: false,
          transformation_method: nil
        },
        timestamp: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        b1g_centroid_ss: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        cugir_addl_downloads_s: {
          destination: "cugir_addl_downloads_s",
          delimited: false,
          transformation_method: nil
        },
        cugir_filesize_s: {
          destination: "cugir_filesize_s",
          delimited: false,
          transformation_method: nil
        },
        _version_: {
          destination: "Discard",
          delimited: false,
          transformation_method: nil
        },
        stanford_rights_metadata_s: {
          destination: "stanford_rights_metadata_s",
          delimited: false,
          transformation_method: nil
        }
      }
    end

    def self.uri_2_category_references_mappings
      ActiveSupport::HashWithIndifferentAccess.new({
        "http://www.opengis.net/def/serviceType/ogc/wcs": "wcs",
        "http://www.opengis.net/def/serviceType/ogc/wms": "wms",
        "http://www.opengis.net/def/serviceType/ogc/wfs": "wfs",
        "http://iiif.io/api/image": "iiif_image",
        "http://iiif.io/api/presentation#manifest": "iiif_manifest",
        "http://schema.org/image": "image",
        "http://schema.org/downloadUrl": "download",
        "http://schema.org/thumbnailUrl": "thumbnail",
        "http://lccn.loc.gov/sh85035852": "documentation_download",
        "http://schema.org/url": "documentation_external",
        "http://www.isotc211.org/schemas/2005/gmd/": "metadata_iso",
        "http://www.opengis.net/cat/csw/csdgm": "metadata_fgdc",
        "http://www.loc.gov/mods/v3": "metadata_mods",
        "http://www.w3.org/1999/xhtml": "metadata_html",
        "urn:x-esri:serviceType:ArcGIS#FeatureLayer": "arcgis_feature_layer",
        "urn:x-esri:serviceType:ArcGIS#TiledMapLayer": "arcgis_tiled_map_layer",
        "urn:x-esri:serviceType:ArcGIS#DynamicMapLayer": "arcgis_dynamic_map_layer",
        "urn:x-esri:serviceType:ArcGIS#ImageMapLayer": "arcgis_image_map_layer",
        "http://schema.org/DownloadAction": "harvard",
        "https://openindexmaps.org": "open_index_map",
        "https://oembed.com": "oembed"
      })
    end
  end
end
