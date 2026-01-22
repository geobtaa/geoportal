# frozen_string_literal: true

json.array! @bulk_actions, partial: "bulk_actions/bulk_action", as: :bulk_action
