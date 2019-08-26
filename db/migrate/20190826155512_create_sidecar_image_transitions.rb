class CreateSidecarImageTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :sidecar_image_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata
      t.integer :sort_key, null: false
      t.bigint :solr_document_sidecar_id, null: false
      t.boolean :most_recent
      t.timestamps null: false
    end

    add_foreign_key :sidecar_image_transitions, :solr_document_sidecars

    add_index(:sidecar_image_transitions,
              [:solr_document_sidecar_id, :sort_key],
              unique: true,
              name: "index_sidecar_image_transitions_parent_sort")

    # MIGRATION TASK - COPY ASSETS
    # Attaches Carrierwave image to ActiveStorage
    #
    puts "MIGRATION TASK - COPY CARRIERWAVE ASSETS to ACTIVE_STOREAGE"
    SolrDocumentSidecar.in_state(:succeeded).each do |sidecar|
      begin
        sidecar.as_image.attach(io: open(sidecar.image.file.file), filename: sidecar.image.file.filename)
        puts "#{sidecar.id} - asset successfully migrated"
      rescue => e
        puts "#{sidecar.id} - asset failed to migrate"
        puts e.inspect
      end
    end

    # MIGRATION TASK - COPY STATE DATA
    # Copy image_upload_transation data into sidecar_image_transitions
    #
    puts "MIGRATION TASK - COPY IMAGE STATE DATA"
    sql = 'INSERT INTO sidecar_image_transitions SELECT * FROM image_upload_transitions ORDER BY id'
    ActiveRecord::Base.connection.execute(sql)
    puts "TASK - COPY IMAGE STATE DATA - COMPLETE"
  end
end
