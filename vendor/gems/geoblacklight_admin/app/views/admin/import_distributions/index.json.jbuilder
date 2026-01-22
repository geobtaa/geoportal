# frozen_string_literal: true

json.array! @import_distributions, partial: "import_distributions/import_distribution", as: :import_distribution
