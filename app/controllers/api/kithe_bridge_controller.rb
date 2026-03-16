class Api::KitheBridgeController < ApplicationController
  protect_from_forgery with: :null_session

  DEFAULT_LIMIT = 1000
  MAX_LIMIT     = 5000

  before_action :require_bridge_token

  def index
    cursor = params[:cursor]
    limit  = [[params[:limit].to_i, 1].max, MAX_LIMIT].min rescue DEFAULT_LIMIT

    scope = KitheToResourcesBridge.order(id: :asc)
    scope = scope.where("id > ?", cursor) if cursor.present?
    rows  = scope.limit(limit).to_a

    next_cursor = rows.last&.id

    render json: {
      data: rows.map { |r| serialize_row(r) },
      next_cursor: next_cursor,
      has_more: next_cursor.present?
    }
  end

  private

  def serialize_row(r)
    r.attributes
  end

  def require_bridge_token
    expected = ENV["KITHE_BRIDGE_TOKEN"].to_s
    provided = request.headers["X-Bridge-Token"].to_s

    head :unauthorized if expected.blank? || !ActiveSupport::SecurityUtils.secure_compare(expected, provided)
  end
end

