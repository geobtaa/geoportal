namespace :geoportal do
  namespace :imagery do
    desc 'Harvest New Thumbnails'
    task harvest_new_thumbnails: [:environment] do
      cursor_mark = "*"
      loop do
        response = Blacklight.default_index.connection.get(
          "select", params: {
            q: "*:*", # all docs
            fl: "geomg_id_s, id",  # just id field
            cursorMark: cursor_mark, # use the cursor mark to handle paging
            rows: 1000,
            sort: "geomg_id_s asc" # must sort by id to use the cursor mark
          }
        )

        response["response"]["docs"].each do |doc|

          puts "Processing #{doc["id"]}"

          document = Document.find_by(friendlier_id: doc["id"])
          next unless document.present?
          GeoblacklightAdmin::StoreImageJob.perform_later(document.friendlier_id) unless document.thumbnail.present?
        end

        break if response["nextCursorMark"] == cursor_mark # this means the result set is finished
        cursor_mark = response["nextCursorMark"]
      end
    end
  end
end