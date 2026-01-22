# frozen_string_literal: true

# Admin::ImportsController
#
# This controller handles the CRUD operations for Import objects within the admin namespace.
# It provides actions to list, show, create, update, and delete imports, as well as run an import.
#
# Before Actions:
# - set_import: Sets the @import instance variable for actions that require an import ID.
#
# Actions:
# - index: Lists all imports with pagination.
# - show: Displays a specific import and its associated documents, with pagination for success and failed states.
# - new: Initializes a new Import object.
# - edit: Prepares an existing Import object for editing.
# - create: Creates a new Import object and redirects to import mappings if successful.
# - update: Updates an existing Import object and redirects to the import if successful.
# - destroy: Deletes an Import object and redirects to the imports list.
# - run: Executes the import process and redirects to the import show page.
#
# Private Methods:
# - set_import: Finds and sets the import based on the provided ID.
# - permittable_params: Returns an array of permitted parameters for import.
# - import_params: Permits parameters for creating or updating an import, including nested attributes.
module Admin
  class ImportsController < Admin::AdminController
    before_action :set_import, only: %i[show edit update destroy run]

    # GET /imports
    # GET /imports.json
    # Lists all imports with pagination.
    def index
      @pagy, @imports = pagy(Import.all.order("created_at DESC"), items: 20)
    end

    # GET /imports/1
    # GET /imports/1.json
    # Displays a specific import and its associated documents, with pagination for success and failed states.
    def show
      @pagy_success, @import_success_documents = pagy(@import.import_documents.in_state(:success), items: 50, page_param: :success_page)
      @pagy_queued, @import_queued_documents = pagy(@import.import_documents.in_state(:queued), items: 50, page_param: :queued_page)
      @pagy_failed, @import_failed_documents = pagy(@import.import_documents.in_state(:failed), items: 50, page_param: :failed_page)
    end

    # GET /imports/new
    # Initializes a new Import object.
    def new
      @import = Import.new
    end

    # GET /imports/1/edit
    # Prepares an existing Import object for editing.
    def edit
    end

    # POST /imports
    # POST /imports.json
    # Creates a new Import object and redirects to import mappings if successful.
    def create
      @import = Import.new(import_params)

      respond_to do |format|
        if @import.save
          format.html do
            redirect_to admin_import_mappings_path(@import),
              notice: "Import was successful. Please set your import mapping rules."
          end
          format.json { render :show, status: :created, location: @import }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @import.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /imports/1
    # PATCH/PUT /imports/1.json
    # Updates an existing Import object and redirects to the import if successful.
    def update
      respond_to do |format|
        if @import.update(import_params)
          format.html { redirect_to admin_import_path(@import), notice: "Import was successfully updated." }
          format.json { render :show, status: :ok, location: @import }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @import.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /imports/1
    # DELETE /imports/1.json
    # Deletes an Import object and redirects to the imports list.
    def destroy
      @import.destroy
      respond_to do |format|
        format.html { redirect_to admin_imports_url, notice: "Import was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # Runs the import process and redirects to the import show page.
    def run
      @import.run!
      redirect_to admin_import_url(@import), notice: "Import is running. Check back soon for results."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets the import based on the provided ID.
    def set_import
      @import = Import.find(params[:id])
    end

    # Returns an array of permitted parameters for import.
    def permittable_params
      %i[type name filename source description row_count encoding content_type extension validity validation_result
        csv_file run]
    end

    # Permits parameters for creating or updating an import, including nested attributes.
    def import_params
      # Handle STI key
      key = (params.keys & %w[import import_btaa import_btaa_aardvark import_gblv1])[0]
      params.require(key).permit(
        permittable_params,
        mappings_attributes: %i[
          id
          source_header
          destination_field
          delimited
          transformation_method
          import_id
        ],
        headers: []
      )
    end
  end
end
