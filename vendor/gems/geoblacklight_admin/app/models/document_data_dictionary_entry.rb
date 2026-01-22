# frozen_string_literal: true

class DocumentDataDictionaryEntry < ApplicationRecord
  # Associations
  belongs_to :document_data_dictionary

  # Validations
  validates :friendlier_id, :field_name, presence: true
  validates :friendlier_id, uniqueness: {scope: :field_name, message: "and field_name combination must be unique"}
end
