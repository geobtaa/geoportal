SELECT
  COALESCE(friendlier_id::varchar, id::varchar)::varchar AS "id",
  title AS "dct_title_s",
  publication_state AS "publication_state",
  import_id::varchar AS "import_id",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_alternative_sm')) AS "dct_alternative_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_description_sm')) AS "dct_description_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_language_sm')) AS "dct_language_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'gbl_displayNote_sm')) AS "gbl_displayNote_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_creator_sm')) AS "dct_creator_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_publisher_sm')) AS "dct_publisher_sm",
  json_attributes->>'schema_provider_s' AS "schema_provider_s",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'gbl_resourceClass_sm')) AS "gbl_resourceClass_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'gbl_resourceType_sm')) AS "gbl_resourceType_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_subject_sm')) AS "dct_subject_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dcat_theme_sm')) AS "dcat_theme_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dcat_keyword_sm')) AS "dcat_keyword_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_temporal_sm')) AS "dct_temporal_sm",
  json_attributes->>'dct_issued_s' AS "dct_issued_s",
  ARRAY(
    SELECT (
      jsonb_array_elements_text(
        CASE
          WHEN jsonb_typeof(json_attributes->'gbl_indexYear_im') = 'array'
            THEN json_attributes->'gbl_indexYear_im'
          WHEN jsonb_typeof(json_attributes->'gbl_indexYear_im') = 'string'
            THEN jsonb_build_array(json_attributes->'gbl_indexYear_im')
          ELSE '[]'::jsonb
        END
      )
    )::integer
  ) AS "gbl_indexYear_im",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'gbl_dateRange_drsim')) AS "gbl_dateRange_drsim",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_spatial_sm')) AS "dct_spatial_sm",
  json_attributes->>'locn_geometry' AS "locn_geometry",
  json_attributes->>'dcat_bbox' AS "dcat_bbox",
  json_attributes->>'dcat_centroid' AS "dcat_centroid",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_relation_sm')) AS "dct_relation_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'pcdm_memberOf_sm')) AS "pcdm_memberOf_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_isPartOf_sm')) AS "dct_isPartOf_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_source_sm')) AS "dct_source_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_isVersionOf_sm')) AS "dct_isVersionOf_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_replaces_sm')) AS "dct_replaces_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_isReplacedBy_sm')) AS "dct_isReplacedBy_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_rights_sm')) AS "dct_rights_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_rightsHolder_sm')) AS "dct_rightsHolder_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_license_sm')) AS "dct_license_sm",
  json_attributes->>'dct_accessRights_s' AS "dct_accessRights_s",
  json_attributes->>'dct_format_s' AS "dct_format_s",
  json_attributes->>'gbl_fileSize_s' AS "gbl_fileSize_s",
  json_attributes->>'gbl_wxsIdentifier_s' AS "gbl_wxsIdentifier_s",
  json_attributes->>'dct_references_s' AS "dct_references_s",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'dct_identifier_sm')) AS "dct_identifier_sm",
  NULLIF(NULLIF(json_attributes->>'gbl_mdModified_dt', ''), 'null')::timestamp AS "gbl_mdModified_dt",
  json_attributes->>'gbl_mdVersion_s' AS "gbl_mdVersion_s",
  NULLIF(NULLIF(json_attributes->>'gbl_suppressed_b', ''), 'null')::boolean AS "gbl_suppressed_b",
  NULLIF(NULLIF(json_attributes->>'gbl_georeferenced_b', ''), 'null')::boolean AS "gbl_georeferenced_b",
  json_attributes->>'b1g_code_s' AS "b1g_code_s",
  json_attributes->>'b1g_status_s' AS "b1g_status_s",
  json_attributes->>'b1g_dct_accrualMethod_s' AS "b1g_dct_accrualMethod_s",
  json_attributes->>'b1g_dct_accrualPeriodicity_s' AS "b1g_dct_accrualPeriodicity_s",
  NULLIF(NULLIF(json_attributes->>'b1g_dateAccessioned_s', ''), 'null')::date AS "b1g_dateAccessioned_s",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_dateAccessioned_sm')) AS "b1g_dateAccessioned_sm",
  NULLIF(NULLIF(json_attributes->>'b1g_dateRetired_s', ''), 'null')::date AS "b1g_dateRetired_s",
  NULLIF(NULLIF(json_attributes->>'b1g_child_record_b', ''), 'null')::boolean AS "b1g_child_record_b",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_dct_mediator_sm')) AS "b1g_dct_mediator_sm",
  CASE
    WHEN json_attributes->'b1g_access_s' IS NULL
      OR json_attributes->'b1g_access_s' = 'null'::jsonb
    THEN NULL
    WHEN jsonb_typeof(json_attributes->'b1g_access_s') = 'string'
    THEN CASE
      WHEN NULLIF(NULLIF(json_attributes->>'b1g_access_s', ''), 'null') IS NULL
      THEN NULL
      ELSE to_jsonb(json_attributes->>'b1g_access_s')
    END
    ELSE json_attributes->'b1g_access_s'
  END AS "b1g_access_s",
  json_attributes->>'b1g_image_ss' AS "b1g_image_ss",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_geonames_sm')) AS "b1g_geonames_sm",
  json_attributes->>'b1g_publication_state_s' AS "b1g_publication_state_s",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_language_sm')) AS "b1g_language_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_creatorID_sm')) AS "b1g_creatorID_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_dct_conformsTo_sm')) AS "b1g_dct_conformsTo_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_dcat_spatialResolutionInMeters_sm')) AS "b1g_dcat_spatialResolutionInMeters_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_geodcat_spatialResolutionAsText_sm')) AS "b1g_geodcat_spatialResolutionAsText_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_dct_provenanceStatement_sm')) AS "b1g_dct_provenanceStatement_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_adminTags_sm')) AS "b1g_adminTags_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_adms_supportedSchema_sm')) AS "b1g_adms_supportedSchema_sm",
  json_attributes->>'b1g_dcat_endpointDescription_s' AS "b1g_dcat_endpointDescription_s",
  json_attributes->>'b1g_dcat_endpointURL_s' AS "b1g_dcat_endpointURL_s",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_dcat_inSeries_sm')) AS "b1g_dcat_inSeries_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_localCollectionLabel_sm')) AS "b1g_localCollectionLabel_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_prov_softwareAgent_sm')) AS "b1g_prov_softwareAgent_sm",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_prov_wasGeneratedBy_sm')) AS "b1g_prov_wasGeneratedBy_sm",
  COALESCE(
    NULLIF(NULLIF(json_attributes->>'date_created_dtsi', ''), 'null')::timestamp,
    created_at
  ) AS "date_created_dtsi",
  COALESCE(
    NULLIF(NULLIF(json_attributes->>'date_modified_dtsi', ''), 'null')::timestamp,
    updated_at
  ) AS "date_modified_dtsi",
  json_attributes->>'geomg_id_s' AS "geomg_id_s",
  ARRAY(SELECT jsonb_array_elements_text(json_attributes->'b1g_adminNote_sm')) AS "b1g_adminNote_sm",
  COALESCE(
    NULLIF(NULLIF(json_attributes->>'b1g_dateAccessioned_dt', ''), 'null')::timestamp,
    NULLIF(NULLIF(json_attributes->>'b1g_dateAccessioned_s', ''), 'null')::date::timestamp
  ) AS "b1g_dateAccessioned_dt",
  COALESCE(
    NULLIF(NULLIF(json_attributes->>'b1g_dateRetired_dt', ''), 'null')::timestamp,
    NULLIF(NULLIF(json_attributes->>'b1g_dateRetired_s', ''), 'null')::date::timestamp
  ) AS "b1g_dateRetired_dt",
  NULLIF(NULLIF(json_attributes->>'b1g_deprioritized_b', ''), 'null')::boolean AS "b1g_deprioritized_b",
  json_attributes->>'b1g_harvestWorkflow_s' AS "b1g_harvestWorkflow_s",
  NULLIF(NULLIF(json_attributes->>'b1g_isHarvested_b', ''), 'null')::boolean AS "b1g_isHarvested_b",
  NULLIF(NULLIF(json_attributes->>'b1g_lastHarvested_dt', ''), 'null')::timestamp AS "b1g_lastHarvested_dt",
  ARRAY(
    SELECT jsonb_array_elements_text(
      CASE
        WHEN jsonb_typeof(
          COALESCE(
            json_attributes->'b1g_dct_provenance_sm',
            json_attributes->'b1g_dct_provenanceStatement_sm'
          )
        ) = 'array'
        THEN COALESCE(
          json_attributes->'b1g_dct_provenance_sm',
          json_attributes->'b1g_dct_provenanceStatement_sm'
        )
        WHEN jsonb_typeof(
          COALESCE(
            json_attributes->'b1g_dct_provenance_sm',
            json_attributes->'b1g_dct_provenanceStatement_sm'
          )
        ) = 'string'
        THEN jsonb_build_array(
          COALESCE(
            json_attributes->'b1g_dct_provenance_sm',
            json_attributes->'b1g_dct_provenanceStatement_sm'
          )
        )
        ELSE '[]'::jsonb
      END
    )
  ) AS "b1g_dct_provenance_sm",
  COALESCE(
    NULLIF(NULLIF(json_attributes->>'b1g_dcat_spatialResolutionInMeters_s', ''), 'null'),
    NULLIF(NULLIF((json_attributes->'b1g_dcat_spatialResolutionInMeters_sm'->>0), ''), 'null')
  ) AS "b1g_dcat_spatialResolutionInMeters_s",
  json_attributes->>'b1g_websitePlatform_s' AS "b1g_websitePlatform_s"
FROM kithe_models
WHERE type = 'Document'
  AND publication_state = 'published';