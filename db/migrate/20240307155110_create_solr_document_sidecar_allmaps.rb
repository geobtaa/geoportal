class CreateSolrDocumentSidecarAllmaps < ActiveRecord::Migration[7.0]
  def change
    create_table :blacklight_allmaps_sidecars do |t|
      t.string :solr_document_id, index: true
      t.string :document_type, default: "SolrDocument"
      t.string :manifest_id, index: true
      t.boolean :annotated, default: false
      t.string :allmaps_id, index: true
      t.text :iiif_manifest
      t.text :allmaps_annotation
      t.bigint :solr_version
      t.timestamps
    end
  end
end
