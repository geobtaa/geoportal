# frozen_string_literal: true

# Admin::ImportDocumentsController
#
# This controller handles the import documents within the admin namespace.
# It inherits from Admin::AdminController and provides actions related to
# import documents.
module Admin
  class ImportDocumentsController < Admin::AdminController
    # Before action callback to set the import document for the show action.
    before_action :set_import_document, only: %i[show]

    # GET /admin/import_documents/:id
    #
    # Displays a specific import document.
    def show
    end

    private

    # Sets the import document based on the ID provided in the parameters.
    #
    # @return [ImportDocument] the import document found by ID
    def set_import_document
      @import_document = ImportDocument.find(params[:id])
    end
  end
end
