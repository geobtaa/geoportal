# frozen_string_literal: true

# Admin::AssetsController
#
# This controller handles the management of assets within the admin namespace.
# It provides actions to list, show, edit, update, and destroy assets.
# Additionally, it supports attaching files to assets.
#
# Actions:
# - index: Lists all assets with optional search functionality.
# - show: Displays a specific asset.
# - edit: Provides a form to edit an asset.
# - update: Updates an asset with new data.
# - destroy: Deletes an asset.
# - display_attach_form: Displays a form to attach files to an asset.
# - attach_files: Attaches files to an asset based on provided JSON data.
#
# Private Methods:
# - parent_id_via_friendly_id: Finds a document's ID using its friendlier_id.
# - set_asset: Finds and sets an asset based on the provided ID.
# - asset_params: Permits only trusted parameters for asset updates.
# - date_check?: Checks if a value can be converted to a date.
module Admin
  class AssetsController < Admin::AdminController
    before_action :set_asset, only: %i[show edit update destroy]

    # GET /admin/asset_files
    #
    # Lists all assets. Supports searching by ID, friendlier_id, title, or parent_id.
    # If a date is provided as a search query, it filters assets created on that date.
    def index
      scope = Asset
      search_query = params[:q].strip if params[:q].present?

      # Basic search functionality
      if search_query.present?
        scope = if date_check?(search_query)
          Asset.where("created_at BETWEEN ? AND ?", search_query.to_date.beginning_of_day, search_query.to_date.end_of_day)
        else
          scope.where(id: search_query).or(
            Asset.where(friendlier_id: search_query)
          ).or(
            Asset.where("title like ?", "%" + Asset.sanitize_sql_like(search_query) + "%")
          ).or(
            Asset.where(parent_id: search_query)
          )
        end
      end

      @pagy, @assets = pagy(scope, items: 20)
    end

    # GET /assets/1 or /assets/1.json
    #
    # Displays a specific asset.
    def show
    end

    # GET /assets/1/edit
    #
    # Provides a form to edit an asset.
    def edit
    end

    # PATCH/PUT /assets/1 or /assets/1.json
    #
    # Updates an asset with new data. If successful, redirects to the asset's page.
    # Otherwise, re-renders the edit form with errors.
    def update
      respond_to do |format|
        if @asset.update(asset_params.merge!(parent_id: parent_id_via_friendly_id(asset_params[:parent_id])))
          format.html { redirect_to admin_asset_url(@asset.id), notice: "Asset was successfully updated." }
          format.json { render :show, status: :ok, location: @asset }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @asset.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /assets/1 or /assets/1.json
    #
    # Deletes an asset and redirects to the assets list with a success notice.
    def destroy
      @asset.destroy

      respond_to do |format|
        format.html { redirect_to admin_assets_url, notice: "Asset was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # /assets/display_attach_form
    #
    # Displays a form to attach files to an asset.
    def display_attach_form
    end

    # POST /assets/ingest
    #
    # Receives JSON hashes for direct uploaded files in params[:files],
    # and id in params[:id] (friendlier_id). Creates filesets for them and attaches.
    # Redirects to the assets list with a success notice.
    def attach_files
      # @parent = Document.find_by_friendlier_id!(params[:id])

      # current_position = @parent.members.maximum(:position) || 0

      files_params = (params[:cached_files] || [])
        .collect { |s| JSON.parse(s) }
        .sort_by { |h| h&.dig("metadata", "filename") }

      files_params.each do |file_data|
        asset = Asset.new

        # if derivative_storage_type = params.dig(:storage_type_for, file_data["id"])
        #  asset.derivative_storage_type = derivative_storage_type
        # end

        # asset.position = (current_position += 1)
        # asset.parent_id = @parent.id
        asset.file = file_data
        asset.title = (asset.file&.original_filename || "Untitled")
        asset.save!
      end

      # @parent.update(representative: @parent.members.order(:position).first) if @parent.representative_id.nil?

      redirect_to admin_assets_url, notice: "Files attached successfully."
    end

    private

    # Finds a document's ID using its friendlier_id.
    def parent_id_via_friendly_id(friendlier_id)
      Document.find_by_friendlier_id(friendlier_id)&.id
    end

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets an asset based on the provided ID.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def asset_params
      params.require(:asset).permit(:parent_id, :thumbnail)
    end

    # Checks if a value can be converted to a date.
    def date_check?(val)
      val.to_date
    rescue Date::Error
      false
    end
  end
end
