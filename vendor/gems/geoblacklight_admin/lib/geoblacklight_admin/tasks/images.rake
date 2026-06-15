require "rake"
require "csv"

namespace :geoblacklight_admin do
  namespace :images do
    desc "Harvest image for specific document - priority queue"
    task harvest_doc_id: :environment do
      GeoblacklightAdmin::StoreImageJob.perform_later(ENV["DOC_ID"], nil, :priority)
    end

    desc "Harvest all images - uses low priority queue"
    task harvest_all: [:environment] do
      cursor_mark = "*"
      loop do
        response = Blacklight.default_index.connection.get(
          "select", params: {
            q: "*:*", # all docs
            fl: "geomg_id_s, id",
            cursorMark: cursor_mark, # use the cursor mark to handle paging
            rows: 1000,
            sort: "geomg_id_s asc" # must sort by id to use the cursor mark
          }
        )

        response["response"]["docs"].each do |doc|
          GeoblacklightAdmin::StoreImageJob.perform_later(doc["id"], nil, :low_priority)
        end

        break if response["nextCursorMark"] == cursor_mark # this means the result set is finished
        cursor_mark = response["nextCursorMark"]
      end
    end
  end
end
