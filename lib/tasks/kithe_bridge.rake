# frozen_string_literal: true

namespace :geoportal do
  desc "Refresh the kithe_to_resources_bridge materialized view"
  task refresh_kithe_to_resources_bridge: :environment do
    view_name = "kithe_to_resources_bridge"

    puts "[geoportal] Refreshing materialized view #{view_name}..."

    # Use CONCURRENTLY when possible so reads aren't blocked. If the MV
    # doesn't have a unique index (e.g., after a definition bump), fall back
    # to a non-concurrent refresh.
    begin
      sql = "REFRESH MATERIALIZED VIEW CONCURRENTLY #{view_name};"
      ActiveRecord::Base.connection.execute(sql)
    rescue ActiveRecord::StatementInvalid => e
      if e.message =~ /cannot refresh materialized view.*concurrently/i
        puts "[geoportal] Concurrent refresh not possible; falling back to non-concurrent: #{e.message}"
        sql = "REFRESH MATERIALIZED VIEW #{view_name};"
        ActiveRecord::Base.connection.execute(sql)
      else
        raise
      end
    end

    puts "[geoportal] Refresh of #{view_name} completed."
  end
end

