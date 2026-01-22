# frozen_string_literal: true

# Admin::Bookmark
module Admin
  class Bookmark < ApplicationRecord
    belongs_to :user, polymorphic: true
    belongs_to :document, polymorphic: true
    validates :user_id, presence: true

    def document_id
      document.id
    end

    def document_type
      Kithe::Model
    end
  end
end
