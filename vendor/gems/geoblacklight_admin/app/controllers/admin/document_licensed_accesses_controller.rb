# frozen_string_literal: true

# Admin::DocumentLicensedAccessesController
#
# This controller manages the CRUD operations for DocumentAccess objects
# within the admin namespace. It provides actions to list, show, create,
# update, and destroy document access records. It also includes custom
# actions for importing and destroying all document access links.
#
# Actions:
# - index: Lists all document accesses, optionally filtered by document_id.
# - show: Displays a specific document access.
# - new: Renders a form for creating a new document access.
# - edit: Renders a form for editing an existing document access.
# - create: Creates a new document access.
# - update: Updates an existing document access.
# - destroy: Deletes a specific document access.
# - destroy_all: Deletes all document access links provided in the params.
# - import: Imports document licensed access links from a file provided in the params.
#
# Before Actions:
# - set_document: Sets the @document instance variable if document_id is present.
# - set_document_licensed_access: Sets the @document_licensed_access instance variable for specific actions.
#
# Private Methods:
# - set_document: Finds and sets the document based on the document_id parameter.
# - set_document_licensed_access: Finds and sets the document licensed access based on the id parameter.
# - document_licensed_access_params: Permits only trusted parameters for document licensed access.
module Admin
  class DocumentLicensedAccessesController < Admin::AdminController
    before_action :set_document
    before_action :set_document_licensed_access, only: %i[show edit update destroy]

    # GET /documents/#id/licensed_access
    # GET /documents/#id/licensed_access.json
    # Lists all document licensed accesses, optionally filtered by document_id.
    def index
      if params[:document_id]
        @document_licensed_accesses = DocumentLicensedAccess.where(friendlier_id: @document.friendlier_id).order(institution_code: :asc)
      else
        @pagy, @document_licensed_accesses = pagy(DocumentLicensedAccess.all.order(friendlier_id: :asc, updated_at: :desc), items: 20)
      end
    end

    # GET /document_licensed_accesses/1
    # GET /document_licensed_accesses/1.json
    # Displays a specific document licensed access.
    def show
    end

    # GET /document_licensed_accesses/new
    # Renders a form for creating a new document licensed access.
    def new
      @document_licensed_access = DocumentLicensedAccess.new
    end

    # GET /document_licensed_accesses/1/edit
    # Renders a form for editing an existing document licensed access.
    def edit
    end

    # POST /document_licensed_accesses
    # POST /document_licensed_accesses.json
    # Creates a new document licensed access.
    def create
      @document_licensed_access = DocumentLicensedAccess.new(document_licensed_access_params)
      logger.debug("DA Params: #{DocumentLicensedAccess.new(document_licensed_access_params).inspect}")
      logger.debug("Document LICENSED ACCESS: #{@document_licensed_access.inspect}")

      respond_to do |format|
        if @document_licensed_access.save
          format.html do
            redirect_to admin_document_document_licensed_accesses_path(@document), notice: "Document licensed access was successfully created."
          end
          format.json { render :show, status: :created, location: @document_licensed_access }
        else
          format.html { render :new }
          format.json { render json: @document_licensed_access.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /document_licensed_accesses/1
    # PATCH/PUT /document_licensed_accesses/1.json
    # Updates an existing document licensed access.
    def update
      respond_to do |format|
        if @document_licensed_access.update(document_licensed_access_params)
          format.html do
            redirect_to admin_document_document_licensed_accesses_path(@document), notice: "Document licensed access was successfully updated."
          end
          format.json { render :show, status: :ok, location: @document_licensed_access }
        else
          format.html { render :edit }
          format.json { render json: @document_licensed_access.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /document_licensed_accesses/1
    # DELETE /document_licensed_accesses/1.json
    # Deletes a specific document licensed access.
    def destroy
      @document_licensed_access.destroy
      respond_to do |format|
        format.html do
          redirect_to admin_document_document_licensed_accesses_path(@document), notice: "Document licensed access was successfully destroyed."
        end
        format.json { head :no_content }
      end
    end

    # DELETE /document_licensed_accesses/destroy_all
    # Deletes all document licensed access links provided in the params.
    def destroy_all
      logger.debug("Destroy Access Links")
      return unless params.dig(:document_licensed_access, :assets, :file)

      respond_to do |format|
        if DocumentLicensedAccess.destroy_all(params.dig(:document_licensed_access, :assets, :file))
          format.html { redirect_to admin_document_licensed_accesses_path, notice: "Document Licensed Access Links were created destroyed." }
        else
          format.html { redirect_to admin_document_licensed_accesses_path, notice: "Document Licensed Access Links could not be destroyed." }
        end
      rescue => e
        format.html { redirect_to admin_document_licensed_accesses_path, notice: "Document Licensed Access Links could not be destroyed. #{e}" }
      end
    end

    # GET   /documents/#id/licensed_access/import
    # POST  /documents/#id/licensed_access/import
    # Imports document licensed access links from a file provided in the params.
    def import
      logger.debug("Import Action")
      return unless params.dig(:document_licensed_access, :assets, :file)

      respond_to do |format|
        if DocumentLicensedAccess.import(params.dig(:document_licensed_access, :assets, :file))
          format.html { redirect_to admin_document_licensed_accesses_path, notice: "Document licensed access links were created successfully." }
        else
          format.html { redirect_to admin_document_licensed_accesses_path, notice: "Document licensed access links could not be created." }
        end
      rescue => e
        format.html { redirect_to admin_document_licensed_accesses_path, notice: "Document licensed access links could not be created. #{e}" }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets the document based on the document_id parameter.
    def set_document
      return unless params[:document_id] # If not nested

      @document = Document.includes(:leaf_representative).find_by!(friendlier_id: params[:document_id])
    end

    # Finds and sets the document licensed access based on the id parameter.
    def set_document_licensed_access
      @document_licensed_access = DocumentLicensedAccess.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # Permits only trusted parameters for document licensed access.
    def document_licensed_access_params
      params.require(:document_licensed_access).permit(:friendlier_id, :institution_code, :access_url)
    end
  end
end
