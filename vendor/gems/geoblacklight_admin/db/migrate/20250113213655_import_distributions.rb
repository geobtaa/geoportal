class ImportDistributions < ActiveRecord::Migration[7.2]
  def change
    add_column :document_distributions, :import_distribution_id, :bigint
    
    create_table :import_distributions do |t|
      t.string :name
      t.string :source
      t.text :description
      t.string :filename
      t.integer :row_count
      t.text :headers, default: [], array: true
      t.string :encoding
      t.string :content_type
      t.string :extension
      t.boolean :validity, default: false
      t.text :validation_result

      t.timestamps
    end

    create_table :import_distribution_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :import_distribution_id, null: false
      t.boolean :most_recent, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index ["import_distribution_id", "most_recent"], name: "index_import_distribution_transitions_parent_most_recent", unique: true, where: "most_recent"
      t.index ["import_distribution_id", "sort_key"], name: "index_import_distribution_transitions_parent_sort", unique: true
    end

    create_table :import_document_distributions do |t|
      t.string :friendlier_id
      t.string :reference_type
      t.text :distribution_url
      t.string :label
      t.bigint :import_distribution_id, null: false
      t.index ["import_distribution_id"], name: "index_import_distributions_on_import_distribution_id"

      t.timestamps
    end

    create_table :import_document_distribution_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :import_document_distribution_id, null: false
      t.boolean :most_recent, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.index ["import_document_distribution_id", "most_recent"], name: "index_import_doc_distribution_transitions_parent_most_recent", unique: true, where: "most_recent"
      t.index ["import_document_distribution_id", "sort_key"], name: "index_import_doc_distribution_transitions_parent_sort", unique: true
    end
  end
end