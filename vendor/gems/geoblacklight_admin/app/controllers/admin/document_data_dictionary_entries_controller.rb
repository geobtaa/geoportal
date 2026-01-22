# frozen_string_literal: true

# Admin::DocumentDataDictionaryEntriesController
#
# This controller manages the document data dictionary entries within the admin namespace.
# It provides actions to list, show, edit, update, destroy, and import data dictionaries.
module Admin
  class DocumentDataDictionaryEntriesController < Admin::AdminController
    before_action :set_document
    before_action :set_document_data_dictionary
    before_action :set_document_data_dictionary_entry, only: %i[edit update destroy]

    # GET /document_data_dictionaries/1/entries/new
    def new
      @document_data_dictionary_entry = DocumentDataDictionaryEntry.new
    end

    # GET /document_data_dictionaries/1/entries/1/edit
    def edit
    end

    # POST /document_data_dictionaries/1/entries or /document_data_dictionaries/1/entries.json
    def create
      @document_data_dictionary_entry = DocumentDataDictionaryEntry.new(document_data_dictionary_entry_params)

      respond_to do |format|
        if @document_data_dictionary_entry.save
          format.html { redirect_to admin_document_document_data_dictionary_path(@document, @document_data_dictionary), notice: "Document data dictionary entry was successfully created." }
          format.json { render :show, status: :created, location: @document_data_dictionary_entry }
        else
          logger.debug("Document data dictionary entry could not be created. #{@document_data_dictionary_entry.errors.full_messages}")
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @document_data_dictionary_entry.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /document_data_dictionaries/1/entries/1 or /document_data_dictionaries/1/entries/1.json
    def update
      respond_to do |format|
        if @document_data_dictionary_entry.update(document_data_dictionary_entry_params)
          format.html { redirect_to admin_document_document_data_dictionary_path(@document, @document_data_dictionary), notice: "Document data dictionary entry was successfully updated." }
          format.json { render :show, status: :ok, location: @document_data_dictionary_entry }
        else
          logger.debug("Document data dictionary entry could not be updated. #{@document_data_dictionary_entry.errors.full_messages}")
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @document_data_dictionary_entry.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /document_data_dictionaries/1/entries/1 or /document_data_dictionaries/1/entries/1.json
    def destroy
      @document_data_dictionary_entry.destroy!

      respond_to do |format|
        format.html { redirect_to admin_document_document_data_dictionary_path(@document, @document_data_dictionary), status: :see_other, notice: "Document data dictionary entry was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # DELETE /admin/document_data_dictionaries/1/entries/destroy_all
    #
    # Destroys all document data dictionaries provided in the file parameter. If successful, redirects
    # with a success notice. Otherwise, redirects with an error notice.
    def destroy_all
      return if request.get?

      logger.debug("Destroy Data Dictionary Entries")

      respond_to do |format|
        if @document_data_dictionary.document_data_dictionary_entries.destroy_all
          format.html { redirect_to admin_document_document_data_dictionary_document_data_dictionary_entries_path(@document_data_dictionary.friendlier_id, @document_data_dictionary), notice: "Data dictionary entries were destroyed." }
        else
          format.html { redirect_to admin_document_document_data_dictionary_document_data_dictionary_entries_path(@document_data_dictionary.friendlier_id, @document_data_dictionary), notice: "Data dictionary entries could not be destroyed." }
        end
      rescue => e
        format.html { redirect_to admin_document_document_data_dictionary_document_data_dictionary_entries_path(@document_data_dictionary.friendlier_id, @document_data_dictionary), notice: "Data dictionary entries could not be destroyed. #{e}" }
      end
    end

    # POST /document_data_dictionaries/1/entries/sort
    # Sorts document data dictionary entries based on the provided list of IDs.
    # Renders an empty response body.
    def sort
      DocumentDataDictionary.sort_entries(params[:id_list])
      render body: nil
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
      @document_data_dictionary = DocumentDataDictionary.find(params[:document_data_dictionary_id])
    end

    # Sets the document data dictionary entry based on the id parameter.
    def set_document_data_dictionary_entry
      @document_data_dictionary_entry = DocumentDataDictionaryEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_data_dictionary_entry_params
      params.require(:document_data_dictionary_entry).permit(
        :friendlier_id,
        :document_data_dictionary_id,
        :field_name,
        :field_type,
        :values,
        :definition,
        :definition_source,
        :parent_field_name,
        :position
      )
    end
  end
end
