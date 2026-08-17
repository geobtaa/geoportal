class ReconcilePlaceheldThumbnailAssets < ActiveRecord::Migration[7.2]
  def up
    reconciled = 0

    say_with_time "Reconciling placeheld thumbnail states with attached thumbnail assets" do
      Document.where(id: placeheld_document_ids_with_thumbnail_assets).find_each do |document|
        next unless document.thumbnail_state_machine.current_state.to_s == "placeheld"

        document.thumbnail_state_machine.transition_to!(
          :succeeded,
          {
            "solr_doc_id" => document.friendlier_id,
            "source" => "reconcile_placeheld_thumbnail_assets"
          }
        )

        touch_document_for_bridge(document)
        reconciled += 1
      end

      reconciled
    end

    refresh_bridge_view if reconciled.positive? && bridge_view_exists?
  end

  def down
    # Data reconciliation only. We do not know which records were intentionally
    # succeeded before this migration, so this is intentionally irreversible.
  end

  private

  def placeheld_document_ids_with_thumbnail_assets
    select_values(<<~SQL.squish)
      SELECT documents.id
      FROM kithe_models documents
      JOIN document_thumbnail_transitions transitions
        ON transitions.kithe_model_id = documents.id
       AND transitions.most_recent = TRUE
       AND transitions.to_state = 'placeheld'
      WHERE documents.type = 'Document'
        AND EXISTS (
          SELECT 1
          FROM kithe_models assets
          WHERE assets.parent_id = documents.id
            AND assets.type = 'Asset'
            AND assets.file_data IS NOT NULL
            AND assets.json_attributes->>'thumbnail' = 'true'
        )
    SQL
  end

  def bridge_view_exists?
    select_value("SELECT to_regclass('kithe_to_resources_bridge')::text").present?
  end

  def touch_document_for_bridge(document)
    now = Time.current.utc
    json = document.json_attributes.is_a?(Hash) ? document.json_attributes : {}
    json["date_modified_dtsi"] = now.iso8601

    document.update_columns(
      json_attributes: json,
      updated_at: now
    )
  end

  def refresh_bridge_view
    say_with_time "Refreshing kithe_to_resources_bridge materialized view" do
      execute "REFRESH MATERIALIZED VIEW kithe_to_resources_bridge"
    end
  end
end
