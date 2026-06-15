# frozen_string_literal: true

# Admin::ImportDistributionsController
#
# This controller handles the CRUD operations for ImportDistribution objects within the admin namespace.
# It provides actions to list, show, create, update, and delete import distributions, as well as run an import distribution.
#
# Before Actions:
# - set_import_distribution: Sets the @import_distribution instance variable for actions that require an import distribution ID.
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
  class ImportDistributionsController < Admin::AdminController
    before_action :set_import_distribution, only: %i[show edit update destroy run]

    # GET /import_distributions
    # GET /import_distributions.json
    # Lists all import distributions with pagination.
    def index
      @pagy, @import_distributions = pagy(ImportDistribution.all.order("created_at DESC"), items: 20)
    end

    # GET /import_distributions/1
    # GET /import_distributions/1.json
    # Displays a specific import distribution and its associated documents, with pagination for success and failed states.
    def show
      @pagy_success, @import_success_distributions = pagy(@import_distribution.import_document_distributions.in_state(:success), items: 50, page_param: :success_page)
      @pagy_queued, @import_queued_distributions = pagy(@import_distribution.import_document_distributions.in_state(:queued), items: 50, page_param: :queued_page)
      @pagy_failed, @import_failed_distributions = pagy(@import_distribution.import_document_distributions.in_state(:failed), items: 50, page_param: :failed_page)
    end

    # GET /import_distributions/new
    # Initializes a new ImportDistribution object.
    def new
      @import_distribution = ImportDistribution.new
    end

    # GET /import_distributions/1/edit
    # Prepares an existing ImportDistribution object for editing.
    def edit
    end

    # POST /import_distributions
    # POST /import_distributions.json
    # Creates a new ImportDistribution object
    def create
      @import_distribution = ImportDistribution.new(import_distribution_params)

      respond_to do |format|
        if @import_distribution.save
          format.html do
            redirect_to admin_import_distribution_path(@import_distribution),
              notice: "Import distribution was successful."
          end
          format.json { render :show, status: :created, location: @import_distribution }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @import_distribution.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /import_distributions/1
    # PATCH/PUT /import_distributions/1.json
    # Updates an existing ImportDistribution object and redirects to the import distribution if successful.
    def update
      respond_to do |format|
        if @import_distribution.update(import_distribution_params)
          format.html { redirect_to admin_import_distribution_path(@import_distribution), notice: "Import distribution was successfully updated." }
          format.json { render :show, status: :ok, location: @import_distribution }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @import_distribution.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /import_distributions/1
    # DELETE /import_distributions/1.json
    # Deletes an ImportDistribution object and redirects to the import distributions list.
    def destroy
      @import_distribution.destroy
      respond_to do |format|
        format.html { redirect_to admin_import_distributions_url, notice: "Import distribution was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # Runs the import process and redirects to the import show page.
    def run
      @import_distribution.run!
      redirect_to admin_import_distribution_url(@import_distribution), notice: "Import distribution is running. Check back soon for results."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets the import distribution based on the provided ID.
    def set_import_distribution
      @import_distribution = ImportDistribution.find(params[:id])
    end

    # Returns an array of permitted parameters for import distribution.
    def permittable_params
      %i[name filename source description row_count encoding content_type extension validity validation_result
        csv_file run]
    end

    # Permits parameters for creating or updating an import distribution, including nested attributes.
    def import_distribution_params
      params.require(:import_distribution).permit(permittable_params)
    end
  end
end
