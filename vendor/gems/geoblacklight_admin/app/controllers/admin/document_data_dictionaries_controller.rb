# frozen_string_literal: true

# Admin::DocumentDataDictionariesController
#
# This controller manages the document data dictionaries within the admin namespace.
# It provides actions to list, show, edit, update, and destroy data dictionaries.
module Admin
  class DocumentDataDictionariesController < Admin::AdminController
    before_action :set_document
    before_action :set_document_data_dictionary, only: %i[show edit update destroy]

    # GET /document_data_dictionaries or /document_data_dictionaries.json
    def index
      @document_data_dictionaries = DocumentDataDictionary.all
      if params[:document_id]
        @document_data_dictionaries = DocumentDataDictionary.where(friendlier_id: @document.friendlier_id).order(position: :asc)
      else
        @pagy, @document_data_dictionaries = pagy(DocumentDataDictionary.all.order(friendlier_id: :asc, updated_at: :desc), items: 20)
      end
    end

    # GET /document_data_dictionaries/1 or /document_data_dictionaries/1.json
    def show
      @pagy, @document_data_dictionary_entries = pagy(@document_data_dictionary.document_data_dictionary_entries.order(position: :asc), items: 100)

      respond_to do |format|
        format.html
        format.csv { render plain: @document_data_dictionary.to_csv }
      end
    end

    # GET /document_data_dictionaries/new
    def new
      @document_data_dictionary = DocumentDataDictionary.new
    end

    # GET /document_data_dictionaries/1/edit
    def edit
    end

    # POST /document_data_dictionaries or /document_data_dictionaries.json
    def create
      @document_data_dictionary = DocumentDataDictionary.new(document_data_dictionary_params)

      respond_to do |format|
        if @document_data_dictionary.save
          format.html { redirect_to admin_document_document_data_dictionaries_path(@document), notice: "Document data dictionary was successfully created." }
          format.json { render :show, status: :created, location: @document_data_dictionary }
        else
          logger.debug("Document data dictionary could not be created. #{@document_data_dictionary.errors.full_messages}")
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @document_data_dictionary.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /document_data_dictionaries/1 or /document_data_dictionaries/1.json
    def update
      respond_to do |format|
        if @document_data_dictionary.update(document_data_dictionary_params)
          format.html { redirect_to admin_document_document_data_dictionaries_path(@document), notice: "Document data dictionary was successfully updated." }
          format.json { render :show, status: :ok, location: @document_data_dictionary }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @document_data_dictionary.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /document_data_dictionaries/1 or /document_data_dictionaries/1.json
    def destroy
      @document_data_dictionary.destroy!

      respond_to do |format|
        format.html { redirect_to admin_document_document_data_dictionaries_path(@document), status: :see_other, notice: "Document data dictionary was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # DELETE /admin/document_data_dictionaries/destroy_all
    #
    # Destroys all document data dictionaries provided in the file parameter. If successful, redirects
    # with a success notice. Otherwise, redirects with an error notice.
    def destroy_all
      return if request.get?

      logger.debug("Destroy Data Dictionaries")
      unless params.dig(:document_data_dictionary, :data_dictionaries, :file)
        raise ArgumentError, "File does not exist or is invalid."
      end

      respond_to do |format|
        if DocumentDataDictionary.destroy_all(params.dig(:document_data_dictionary, :data_dictionaries, :file))
          format.html { redirect_to admin_document_document_data_dictionaries_path, notice: "Data dictionaries were destroyed." }
        else
          format.html { redirect_to admin_document_document_data_dictionaries_path, notice: "Data dictionaries could not be destroyed." }
        end
      rescue => e
        format.html { redirect_to admin_document_document_data_dictionaries_path, notice: "Data dictionaries could not be destroyed. #{e}" }
      end
    end

    private

    # Sets the document based on the document_id parameter.
    # If not nested, it does nothing.
    def set_document
      return unless params[:document_id] # If not nested

      @document = Document.includes(:leaf_representative).find_by!(friendlier_id: params[:document_id])
    end

    # Sets the document data dictionary based on the id parameter.
    def set_document_data_dictionary
      @document_data_dictionary = DocumentDataDictionary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_data_dictionary_params
      params.require(:document_data_dictionary).permit(
        :friendlier_id,
        :name,
        :description,
        :staff_notes,
        :tags,
        :csv_file,
        :position
      )
    end
  end
end
