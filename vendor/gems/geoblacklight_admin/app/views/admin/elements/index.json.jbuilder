# frozen_string_literal: true

json.array! @elements, partial: "elements/element", as: :element
