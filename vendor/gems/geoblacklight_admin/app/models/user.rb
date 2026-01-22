# frozen_string_literal: true

require "devise"

# User
class User < ApplicationRecord
  extend Devise::Models
  include Blacklight::User

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :bookmarks, dependent: :destroy, as: :user
  has_many :notifications, dependent: :destroy, as: :recipient

  def bookmarks_for_documents(documents = [])
    if documents.any?
      bookmarks.where(document_type: documents.first.class.base_class.to_s, document_id: documents.map(&:id))
    else
      []
    end
  end

  def document_is_bookmarked?(document)
    bookmarks_for_documents([document]).any?
  end
end
