# frozen_string_literal: true

# Admin::DocumentDistributionsController
#
# This controller manages the CRUD operations for Document Distributions within the Admin namespace.
# It includes actions for listing, showing, creating, updating, and deleting document distributions.
# Additionally, it provides functionality for importing and destroying all distributions.
module Admin
  class DocumentDistributionsController < Admin::AdminController
    before_action :set_document
    before_action :set_document_distribution, only: %i[show edit update destroy]

    # GET /admin/document_distributions or /admin/document_distributions.json
    #
    # Lists all document distributions. If a document_id is provided, it lists distributions
    # associated with that document, ordered by position. Otherwise, it paginates all
    # document distributions.
    def index
      @document_distributions = DocumentDistribution.all
      if params[:document_id]
        @document_distributions = DocumentDistribution.where(friendlier_id: @document.friendlier_id).order(position: :asc)
      else
        @pagy, @document_distributions = pagy(DocumentDistribution.all.order(friendlier_id: :asc, updated_at: :desc), items: 20)
      end
    end

    # GET /admin/document_distributions/1 or /admin/document_distributions/1.json
    #
    # Shows a specific document distribution.
    def show
    end

    # GET /admin/document_references/new
    #
    # Initializes a new document distribution.
    def new
      @document_distribution = DocumentDistribution.new
    end

    # GET /admin/document_distributions/1/edit
    #
    # Edits an existing document distribution.
    def edit
    end

    # POST /admin/document_distributions or /admin/document_distributions.json
    #
    # Creates a new document distribution. If successful, redirects to the document distributions
    # list with a success notice. Otherwise, renders the new form with errors.
    def create
      @document_distribution = DocumentDistribution.new(document_distribution_params)

      respond_to do |format|
        if @document_distribution.save
          format.html { redirect_to admin_document_document_distributions_path(@document), notice: "Document distribution was successfully created." }
          format.json { render :show, status: :created, location: @document_distribution }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @document_distribution.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /admin/document_distributions/1 or /admin/document_distributions/1.json
    #
    # Updates an existing document distribution. If successful, redirects to the document distribution
    # with a success notice. Otherwise, renders the edit form with errors.
    def update
      respond_to do |format|
        if @document_distribution.update(document_distribution_params)
          format.html { redirect_to admin_document_document_distributions_path(@document), notice: "Document distribution was successfully updated." }
          format.json { render :show, status: :ok, location: @document_distribution }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @document_distribution.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/document_distributions/1 or /admin/document_distributions/1.json
    #
    # Deletes a document distribution. Redirects to the document distributions list with a success notice.
    def destroy
      @document_distribution.destroy!

      respond_to do |format|
        format.html { redirect_to admin_document_document_distributions_path(@document), status: :see_other, notice: "Document distribution was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # DELETE /admin/document_distributions/destroy_all
    #
    # Queues a background job to destroy all document distributions provided in the file parameter.
    # The job will process the CSV file and send a notification when complete.
    def destroy_all
      return if request.get?

      logger.debug("Queue Destroy Distributions Job")
      unless params.dig(:document_distribution, :distributions, :file)
        raise ArgumentError, "File does not exist or is invalid."
      end

      # Save the uploaded file to a temporary location
      uploaded_file = params.dig(:document_distribution, :distributions, :file)
      temp_file_path = Rails.root.join("tmp", "destroy_distributions_#{Time.current.to_i}_#{SecureRandom.hex(8)}.csv")

      File.binwrite(temp_file_path, uploaded_file.read)

      # Queue the background job
      DestroyDocumentDistributionsJob.perform_later(temp_file_path.to_s, current_user)

      respond_to do |format|
        format.html {
          redirect_to admin_document_distributions_path,
            notice: "Distribution destruction job has been queued. You will receive a notification when it completes."
        }
      end
    rescue => e
      respond_to do |format|
        format.html {
          redirect_to admin_document_distributions_path,
            notice: "Failed to queue distribution destruction job: #{e.message}"
        }
      end
    end

    private

    # Sets the document based on the document_id parameter.
    # If not nested, it does nothing.
    def set_document
      return unless params[:document_id] # If not nested

      @document = Document.includes(:leaf_representative).find_by!(friendlier_id: params[:document_id])
    end

    # Sets the document distribution based on the id parameter.
    def set_document_distribution
      @document_distribution = DocumentDistribution.find(params[:id])
    end

    # Permits only the trusted parameters for document distributions.
    def document_distribution_params
      params.require(:document_distribution).permit(:friendlier_id, :reference_type_id, :url, :label, :position)
    end
  end
end
