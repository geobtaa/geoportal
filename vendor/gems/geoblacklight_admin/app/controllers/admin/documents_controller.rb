# frozen_string_literal: true

# Admin::DocumentsController
# This controller handles the management of documents within the admin interface.
# It provides actions to list, create, update, and delete documents, as well as
# export them in various formats.
module Admin
  class DocumentsController < Admin::AdminController
    # Allow all parameters (not recommended for production use)
    ActionController::Parameters.permit_all_parameters = true

    # Set the document before certain actions
    before_action :set_document, only: %i[show edit update destroy admin versions]

    # GET /documents
    # GET /documents.json
    # Lists all documents with support for various export formats.
    def index
      # Construct the request URL
      @request = "#{request.protocol}#{request.host}:#{request.port}"

      # Define query parameters for the document search
      query_params = {
        q: params["q"],
        f: params["f"],
        page: params["page"],
        rows: params["rows"] || 20,
        sort: params["sort"] || "score desc",
        daterange: params["daterange"] || nil
      }
      @documents = BlacklightApi.new(@request, **query_params)

      # Respond to different formats
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @documents.results.to_json }
        format.json_btaa_aardvark do
          ExportJsonJob.perform_later(@request, current_user, query_params.merge!({format: "json_btaa_aardvark"}), ExportJsonService)
          head :no_content
        end
        format.json_aardvark do
          ExportJsonJob.perform_later(@request, current_user, query_params.merge!({format: "json_aardvark"}), ExportJsonService)
          head :no_content
        end
        format.json_gbl_v1 do
          ExportJsonJob.perform_later(@request, current_user, query_params.merge!({format: "json_gbl_v1"}), ExportJsonService)
          head :no_content
        end
        format.json_file do
          ExportJsonBulkJob.perform_later(@request, current_user, query_params.merge!({format: "json_file"}), ExportJsonService)
          head :no_content
        end
        format.csv do
          ExportJob.perform_later(@request, current_user, query_params, ExportCsvService)
          head :no_content
        end
        format.csv_document_licensed_access_links do
          ExportJob.perform_later(@request, current_user, query_params, ExportCsvDocumentLicensedAccessLinksService)
          head :no_content
        end
        format.csv_document_distributions do
          ExportJob.perform_later(@request, current_user, query_params, ExportCsvDocumentDistributionsService)
          head :no_content
        end
      end
    end

    # Fetch documents from an array of friendlier_ids
    # This action retrieves documents based on their friendlier IDs.
    def fetch
      @request = "#{request.protocol}#{request.host}:#{request.port}"
      @documents = Document.where(friendlier_id: params["ids"])

      respond_to do |format|
        format.html { render :index }
        format.json { render json: @documents.to_json }
        format.json_btaa_aardvark do
          ExportJsonJob.perform_later(@request, current_user, {ids: @documents.pluck(:friendlier_id), format: "json_btaa_aardvark"}, ExportJsonService)
          head :no_content
        end
        format.json_aardvark do
          ExportJsonJob.perform_later(@request, current_user, {ids: @documents.pluck(:friendlier_id), format: "json_aardvark"}, ExportJsonService)
          head :no_content
        end
        format.json_gbl_v1 do
          ExportJsonJob.perform_later(@request, current_user, {ids: @documents.pluck(:friendlier_id), format: "json_gbl_v1"}, ExportJsonService)
          head :no_content
        end
        format.csv do
          ExportJob.perform_later(@request, current_user, {ids: @documents.pluck(:friendlier_id), format: "csv"}, ExportCsvService)
          head :no_content
        end
        format.csv_document_licensed_access_links do
          ExportJob.perform_later(@request, current_user, {ids: @documents.pluck(:friendlier_id), format: "csv_document_licensed_access_links"}, ExportCsvDocumentLicensedAccessLinksService)
          head :no_content
        end
        format.csv_document_distributions do
          ExportJob.perform_later(@request, current_user, {ids: @documents.pluck(:friendlier_id), format: "csv_document_distributions"}, ExportCsvDocumentDistributionsService)
          head :no_content
        end
      end
    end

    # GET /documents/new
    # Renders a form for creating a new document.
    def new
      @document = Document.new
      render :edit
    end

    # GET /documents/1/edit
    # Renders a form for editing an existing document.
    def edit
    end

    # GET /documents/1/admin
    # Admin view for a specific document.
    def admin
    end

    # GET /documents/1/versions
    # Displays the version history of a document.
    def versions
    end

    # POST /documents
    # POST /documents.json
    # Creates a new document with the provided parameters.
    def create
      @document = Document.new(document_params)
      @document.friendlier_id = @document.send(GeoblacklightAdmin::Schema.instance.solr_fields[:id])
      respond_to do |format|
        if @document.save
          format.html { redirect_to edit_admin_document_path(@document), notice: "Document was successfully created." }
          format.json { render :show, status: :created, location: @document }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /documents/1
    # PATCH/PUT /documents/1.json
    # Updates an existing document with the provided parameters.
    def update
      respond_to do |format|
        if @document.update(document_params)
          format.html { redirect_to edit_admin_document_path(@document), notice: "Document was successfully updated." }
          format.json { render :show, status: :ok, location: @document }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /documents/1
    # DELETE /documents/1.json
    # Deletes a document.
    def destroy
      @document.destroy
      respond_to do |format|
        format.html do
          redirect_to admin_documents_url, notice: "Document '#{@document.title}' was successfully destroyed."
        end
        format.json { head :no_content }
      end
    end

    # GET /documents/1
    # Shows a document in various formats.
    def show
      respond_to do |format|
        format.html { redirect_to edit_admin_document_url(@document) }
        format.json { render json: @document.to_json } # App-style JSON
        format.json_aardvark
        format.json_btaa_aardvark
        format.json_gbl_v1
        format.csv { send_data collect_csv([@document]), filename: "documents-#{Time.zone.today}.csv" }
      end
    end

    def export
      case params[:format]
      when "csv_document_licensed_access_links"
        ExportJob.perform_later(@request, current_user, query_params, ExportCsvDocumentLicensedAccessLinksService)
        redirect_to admin_documents_path, notice: "Export job started. You will receive a notification when it is complete."
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets the document based on the friendlier_id.
    def set_document
      @document = Document.includes(:leaf_representative).find_by!(friendlier_id: params[:id] || params[:document_id])
    end

    # Defines the list of permitted parameters for document creation and updates.
    def permittable_params
      %i[title publication_state layer_geom_type_s dct_references_s q f page sort rows daterange]
    end

    # Get all date/datetime fields that need special parameter handling
    # Rails date_select/datetime_select generates parameters like field_name(1i), field_name(2i), etc.
    def date_time_fields
      return [] unless ActiveRecord::Base.connection.table_exists?("elements")

      Element.where("field_type IN (?) OR solr_field LIKE ?", ["date", "datetime"], "%_dt")
        .pluck(:solr_field)
    end

    # Build date field parameter keys for date_select format
    # Rails date_select generates: field_name(1i)=year, (2i)=month, (3i)=day, (4i)=hour, (5i)=minute
    def date_field_param_keys
      keys = []
      date_time_fields.each do |field|
        # Permit date_select parameters: field_name(1i), field_name(2i), etc.
        # Using strings since that's how they come from the form
        (1..5).each do |i|
          keys << "#{field}(#{i}i)"
        end
      end
      keys
    end

    # Strong parameters for document creation and updates.
    def document_params
      base_params = Kithe::Parameters.new(params).require(:document).permit_attr_json(Document)

      # Permit standard params and date field params together
      all_permitted = permittable_params + date_field_param_keys
      base_params.permit(*all_permitted)
    end

    # Collects documents into a CSV format.
    def collect_csv(documents)
      CSV.generate(headers: true) do |csv|
        csv << GeoblacklightAdmin::Schema.instance.exportable_fields.map { |k, _v| k.to_s }
        if documents.instance_of?(BlacklightApi)
          documents.load_all.map do |doc|
            csv << doc.to_csv if doc.present?
          end
        else
          documents.each do |doc|
            csv << doc.to_csv
          end
        end
      end
    end
  end
end
