# frozen_string_literal: true

class Element < ApplicationRecord
  serialize :html_attributes, coder: JSON

  has_many :form_elements, foreign_key: :element_solr_field, primary_key: :solr_field, dependent: :destroy

  # Scopes
  scope :formable, -> { where(formable: true) }
  scope :importable, -> { where(importable: true) }
  scope :exportable, -> { where(exportable: true) }
  scope :indexable, -> { where(indexable: true) }

  # Callbacks
  # @TODO: watch schema timestamp file and restart systemd services if it changes?
  # - Necessary for JSON Attr and Sidekiq to pick up new fields or changes
  # - https://unix.stackexchange.com/questions/708286/automatically-restart-a-systemd-service-when-a-file-is-modified-on-disk
  # - fswatch?
  # - cap deploy:restart

  before_destroy :store_solr_field_for_cleanup
  after_save :update_schema_timestamp
  after_destroy :update_schema_timestamp
  after_commit :enqueue_attribute_removal_job, on: :destroy

  # Validations
  validates :label, :solr_field, :field_type, presence: true
  validates :label, uniqueness: true
  validates :solr_field, uniqueness: true

  FIELD_TYPES = %w[
    string
    text
    integer
    boolean
    date
    datetime
  ].freeze

  # Find by solr_field shortcut
  def self.at(field)
    Element.find_by_solr_field(field)
  end

  # Element Field List (Labels as Symbols)
  def self.list
    @list ||= Element.all.map { |e| e.label.parameterize(separator: "_").to_sym }
  end

  def constantized_label
    label.parameterize(separator: "_").upcase
  end

  # Index value
  def index_value
    if index_transformation_method.present?
      index_transformation_method
    else
      solr_field
    end
  end

  # Export value
  def export_value
    if export_transformation_method.present?
      export_transformation_method
    else
      solr_field
    end
  end

  def self.label_nocase(label)
    Element.where("LOWER(label) = ?", label.to_s.tr("_", " ").downcase).first
  end

  # Class Level - Method Missing
  # ex. :title => "Title"
  def self.method_missing(m, *args, &block)
    if list.include?(m)
      label_nocase(m)
    else
      super
    end
  end

  def self.sort_elements(id_array)
    transaction do
      logger.debug { id_array.inspect }
      id_array.each_with_index do |elm_id, i|
        Element.update(elm_id, position: i)
      end
    end
  end

  def self.respond_to_missing?(method_name, include_private = false)
    label_nocase(method_name).present? || super
  end

  private

  def store_solr_field_for_cleanup
    @solr_field_for_cleanup = solr_field
  end

  def enqueue_attribute_removal_job
    return unless @solr_field_for_cleanup.present?

    GeoblacklightAdmin::RemoveElementAttributeJob.perform_later(@solr_field_for_cleanup)
  end

  def update_schema_timestamp
    File.write(Rails.root.join("tmp/schema_timestamp.txt").to_s, Time.now.to_s)
  end
end
