class CreateSolrDocumentUris < ActiveRecord::Migration[5.1]
  def change
    create_table :solr_document_uris do |t|
      t.string "document_id"
      t.string "document_type"
      t.string "uri_key"
      t.string "uri_value"
      t.integer "version", :limit => 8

      t.index ["document_type", "document_id"], name: "solr_document_uris_solr_document"
      t.timestamps
    end
  end
end
