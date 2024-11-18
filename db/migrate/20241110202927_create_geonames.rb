class CreateGeonames < ActiveRecord::Migration[7.0]
  def change
    create_table :geonames do |t|
      t.bigint :geonameid
      t.string :name
      t.string :asciiname
      t.text :alternatenames
      t.decimal :latitude
      t.decimal :longitude
      t.string :feature_class
      t.string :feature_code
      t.string :country_code
      t.string :cc2
      t.string :admin1_code
      t.string :admin2_code
      t.string :admin3_code
      t.string :admin4_code
      t.bigint :population
      t.integer :elevation
      t.integer :dem
      t.string :timezone
      t.date :modification_date

      t.timestamps
    end
    
    # Indexes
    # add_index :geonames, :geonameid, unique: true
    # add_index :geonames, :name
    # add_index :geonames, :asciiname
    # add_index :geonames, [:latitude, :longitude]
    # add_index :geonames, :country_code
    # add_index :geonames, :feature_class
    # add_index :geonames, :feature_code
    # add_index :geonames, :admin1_code
    # add_index :geonames, :admin2_code
    # add_index :geonames, :admin3_code
    # add_index :geonames, :admin4_code
    # add_index :geonames, :population
    # add_index :geonames, :timezone
    # add_index :geonames, [:country_code, :admin1_code]
    # add_index :geonames, [:feature_class, :population]
  end
end
