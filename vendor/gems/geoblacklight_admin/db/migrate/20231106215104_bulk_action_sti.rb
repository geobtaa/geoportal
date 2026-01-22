# frozen_string_literal: true

class BulkActionSti < ActiveRecord::Migration[6.1]
  def change
    add_column :bulk_actions, :bulk_action_type, :string, default: "ChangePublicationState", null: false
    add_column :bulk_actions, :action, :string, null: true
    change_column :bulk_actions, :field_name, :string, null: true
    change_column :bulk_actions, :field_value, :string, null: true
  end
end
