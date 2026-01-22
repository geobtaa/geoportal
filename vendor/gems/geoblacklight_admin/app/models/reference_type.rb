# frozen_string_literal: true

# The ReferenceType class represents a reference entity in the application.
# It includes validations for presence and uniqueness of reference attributes,
# and manages the position of references within the system.
class ReferenceType < ApplicationRecord
  has_many :document_distributions, dependent: :destroy

  # Validations
  # Ensures that both reference_type and reference_uri are present and unique.
  validates :name, :reference_type, :reference_uri, presence: true
  validates :name, :reference_type, uniqueness: true

  # Callbacks
  # Sets the position of the reference before it is created.
  before_create :set_last_position

  # Sets the position of the reference to the next available position.
  # If no references exist, it sets the position to 1.
  #
  # @return [void]
  def set_last_position
    position = ReferenceType.all.order(position: :desc)&.first&.position
    self.position = position.blank? ? 1 : position + 1
  end

  # Class method to sort elements based on an array of IDs.
  # Updates the position of each ReferenceType according to the order in the array.
  #
  # @param id_array [Array<Integer>] An array of element IDs to be sorted.
  # @return [void]
  def self.sort_elements(id_array)
    transaction do
      logger.debug { id_array.inspect }
      id_array.each_with_index do |elm_id, i|
        ReferenceType.update(elm_id, position: i)
      end
    end
  end
end
