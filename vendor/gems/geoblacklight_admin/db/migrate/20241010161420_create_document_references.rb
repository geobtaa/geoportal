class CreateDocumentReferences < ActiveRecord::Migration[7.2]
  def change
    create_table :document_references do |t|
      t.string :friendlier_id, null: false
      t.references :reference_type, null: false, foreign_key: true
      t.string :url
      t.string :label
      t.integer :position
      t.timestamps

      t.index [:friendlier_id, :reference_type_id, :url], unique: true
    end
  end
end