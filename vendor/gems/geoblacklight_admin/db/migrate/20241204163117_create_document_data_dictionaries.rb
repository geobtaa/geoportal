class CreateDocumentDataDictionaries < ActiveRecord::Migration[7.2]
  def change
    create_table :document_data_dictionaries do |t|
      t.string :friendlier_id
      t.string :name
      t.text :description
      t.text :staff_notes
      t.string :tags, limit: 4096, default: "", null: false
      t.integer :position
      
      t.timestamps
    end
  end
end
