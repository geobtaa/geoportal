# frozen_string_literal: true

# Notification
class Notification < ApplicationRecord
  include Noticed::Model

  belongs_to :recipient, polymorphic: true

  has_one_attached :file
end
