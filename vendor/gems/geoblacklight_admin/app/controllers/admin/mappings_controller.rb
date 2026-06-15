# frozen_string_literal: true

# Admin::MappingsController
# This controller manages the CRUD operations for Mappings within an Import context.
# It provides actions to list, show, create, update, and destroy mappings.
module Admin
  class MappingsController < Admin::AdminController
    before_action :set_import
    before_action :set_mapping, only: %i[show edit update destroy]

    # GET /import/:id/mappings
    # GET /import/:id/mappings.json
    # Lists all mappings for a specific import. If no mappings exist, it initializes a new one.
    def index
      @mappings = Mapping.where(import_id: @import)

      # Build mappings unless we already have
      @import.mappings.build if @import.mappings.blank?
    end

    # GET /mappings/1
    # GET /mappings/1.json
    # Shows a specific mapping.
    def show
      @import = Import.find(params[:import_id])
    end

    # GET /mappings/new
    # Initializes a new mapping object.
    def new
      @mapping = Mapping.new
    end

    # GET /mappings/1/edit
    # Prepares a mapping for editing.
    def edit
    end

    # POST /mappings
    # POST /mappings.json
    # Creates a new mapping. If successful, redirects to the mapping's show page.
    # Otherwise, re-renders the new form.
    def create
      @mapping = Mapping.new(mapping_params)

      respond_to do |format|
        if @mapping.save
          format.html do
            redirect_to admin_import_mapping_path(@import, @mapping), notice: "Mapping was successfully created."
          end
          format.json { render :show, status: :created, location: @mapping }
        else
          format.html { render :new }
          format.json { render json: @mapping.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /mappings/1
    # PATCH/PUT /mappings/1.json
    # Updates an existing mapping. If successful, redirects to the mappings index.
    # Otherwise, re-renders the edit form.
    def update
      respond_to do |format|
        if @mapping.update(mapping_params)
          format.html { redirect_to admin_import_mappings_path(@mapping.import), notice: "Mapping was successfully updated." }
          format.json { render :show, status: :ok, location: @mapping }
        else
          format.html { render :edit }
          format.json { render json: @mapping.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /mappings/1
    # DELETE /mappings/1.json
    # Deletes a mapping and redirects to the mappings index.
    def destroy
      @mapping.destroy
      respond_to do |format|
        format.html { redirect_to admin_import_mappings_url(@import), notice: "Mapping was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.

    # Sets the import based on the import_id parameter.
    def set_import
      @import = Import.find(params[:import_id])
    end

    # Sets the mapping based on the id parameter.
    def set_mapping
      @mapping = Mapping.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # Permits the parameters required for creating or updating a mapping.
    def mapping_params
      params.require(:mapping).permit(
        :source_header,
        :destination_field,
        :delimited,
        :transformation_method,
        :import_id
      )
    end
  end
end
