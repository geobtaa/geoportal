class CreateDocumentDataDictionaryEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :document_data_dictionary_entries do |t|
      t.references :document_data_dictionary, null: false, foreign_key: true
      t.string :friendlier_id
      t.string :field_name
      t.string :field_type
      t.string :values
      t.string :definition
      t.string :definition_source
      t.string :parent_field_name
      t.integer :position

      t.timestamps
    end
  end
end