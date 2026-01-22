# frozen_string_literal: true

class CreateDocumentThumbnailStatesman < ActiveRecord::Migration[7.0]
  def change
    create_table 'document_thumbnail_transitions', force: :cascade do |t|
      t.string 'to_state', null: false
      t.text 'metadata', default: '{}'
      t.integer 'sort_key', null: false
      t.uuid 'kithe_model_id', null: false
      t.boolean 'most_recent', null: false
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.index %w[kithe_model_id most_recent], name: 'thumbnail_transitions_parent_most_recent', unique: true,
                                              where: 'most_recent'
      t.index %w[kithe_model_id sort_key], name: 'thumbnail_transitions_parent_sort', unique: true
    end
  end
end
