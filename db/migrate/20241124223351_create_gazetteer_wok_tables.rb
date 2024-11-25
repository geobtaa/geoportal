class CreateGazetteerWokTables < ActiveRecord::Migration[7.0]
  def change
    rename_table :geonames, :gazetteer_geonames_names
    rename_column :gazetteer_geonames_names, :geonameid, :geoname_id

    create_table :gazetteer_wof_ancestors do |t|
      t.bigint :wok_id
      t.integer :ancestor_id
      t.string :ancestor_placetype
      t.integer :lastmodified
      t.timestamps
    end

    create_table :gazetteer_wof_concordances do |t|
      t.bigint :wok_id
      t.string :other_id
      t.string :other_source
      t.integer :lastmodified
      t.timestamps
    end

    create_table :gazetteer_wof_geojson do |t|
      t.bigint :wok_id
      t.text :body
      t.string :source
      t.string :alt_label
      t.boolean :is_alt
      t.integer :lastmodified
      t.timestamps
    end

    create_table :gazetteer_wof_names do |t|
      t.bigint :wok_id
      t.string :placetype
      t.string :country
      t.string :language
      t.string :extlang
      t.string :script
      t.string :region
      t.string :variant
      t.string :extension
      t.string :privateuse
      t.string :name
      t.integer :lastmodified
      t.timestamps
    end

    create_table :gazetteer_wof_spr do |t|
      t.bigint :wok_id
      t.integer :parent_id
      t.string :name
      t.string :placetype
      t.string :country
      t.string :repo
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :min_latitude
      t.decimal :min_longitude
      t.decimal :max_latitude
      t.decimal :max_longitude
      t.integer :is_current
      t.integer :is_deprecated
      t.integer :is_ceased
      t.integer :is_superseded
      t.integer :is_superseding
      t.integer :superseded_by
      t.integer :supersedes
      t.integer :lastmodified
      t.timestamps
    end
  end
end
