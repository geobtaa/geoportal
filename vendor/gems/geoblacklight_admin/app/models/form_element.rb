# frozen_string_literal: true

class FormElement < ApplicationRecord
  belongs_to :element, foreign_key: :element_solr_field, primary_key: :solr_field, optional: true

  before_create :set_last_position

  def set_last_position
    position = FormElement.all.order(position: :desc)&.first&.position
    self.position = position.blank? ? 1 : position + 1
  end

  def self.sort_elements(id_array)
    transaction do
      logger.debug { id_array.inspect }
      id_array.each_with_index do |elm_id, i|
        FormElement.update(elm_id, position: i)
      end
    end
  end
end
