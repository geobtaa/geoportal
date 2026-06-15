# frozen_string_literal: true

json.array! @bookmarks, partial: "bookmarks/bookmark", as: :bookmark
