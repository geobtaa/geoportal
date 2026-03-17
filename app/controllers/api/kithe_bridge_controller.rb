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

    data =
      if params[:v1] == "raw"
        rows.map(&:attributes)
      else
        rows.map { |row| BridgeExportSerializer.new(row).as_json }
      end

    render json: {
      data: data,
      next_cursor: next_cursor,
      has_more: next_cursor.present?
    }
  end

  def show
    record = KitheToResourcesBridge.find_by(id: params[:id])

    unless record
      head :not_found
      return
    end

    if params[:v1] == "raw"
      render json: record.attributes
    else
      render json: BridgeExportSerializer.new(record).as_json
    end
  end

  private

  def v1_assets
    cursor = params[:cursor]
    limit  = [[params[:limit].to_i, 1].max, MAX_LIMIT].min rescue DEFAULT_LIMIT

    scope = Asset.order(id: :asc)
    scope = scope.where("id > ?", cursor) if cursor.present?
    scope = scope.includes(:parent)

    rows = scope.limit(limit).to_a
    next_cursor = rows.last&.id

    render json: {
      data: rows.map { |asset| AssetExportSerializer.new(asset).as_json },
      next_cursor: next_cursor,
      has_more: next_cursor.present?
    }
  end

  def require_bridge_token
    expected = ENV["KITHE_BRIDGE_TOKEN"].to_s
    provided = request.headers["X-Bridge-Token"].to_s

    head :unauthorized if expected.blank? || !ActiveSupport::SecurityUtils.secure_compare(expected, provided)
  end
end

