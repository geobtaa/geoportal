class CreateAdminReferenceTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :reference_types do |t|
      t.string :name                    # short name, ex: "cog"
      t.string :reference_type          # human-readable name, ex: "Cloud Optimized GeoTIFF (COG)"
      t.string :reference_uri           # key name, ex: "https://github.com/cogeotiff/cog-spec"
      t.boolean :label, default: false  # optional download label
      t.text :note                      # optional note
      t.integer :position               # position for sorting
      t.timestamps
    end
  end
end