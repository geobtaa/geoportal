# frozen_string_literal: true

# Admin::BookmarksController
# This controller handles the management of bookmarks for the admin interface.
# It allows for listing, creating, and destroying bookmarks associated with the current user.
module Admin
  class BookmarksController < Admin::AdminController
    before_action :set_document, only: %i[create destroy]

    # GET /bookmarks
    # GET /bookmarks.json
    # Lists all bookmarks for the current user, filtered by document type "Kithe::Model".
    # Responds with HTML or CSV format.
    def index
      @pagy, @bookmarks = pagy(current_user.bookmarks.where(document_type: "Kithe::Model"))

      respond_to do |format|
        format.html { render :index }
        # B1G CSV
        format.csv { send_data collect_csv(current_user.bookmarks), filename: "documents-#{Time.zone.today}.csv" }
      end
    end

    # POST /bookmarks
    # POST /bookmarks.json
    # Creates a new bookmark for the current user and the specified document.
    # If successful, redirects to the bookmarks index with a success notice.
    # Otherwise, renders the index with an error status.
    def create
      @bookmark = Admin::Bookmark.find_or_create_by(user: current_user, document: @document)

      respond_to do |format|
        if @bookmark.save
          format.html { redirect_to admin_bookmarks_url, notice: "Bookmark was successfully created." }
          format.js
        else
          format.html { render :index, status: :unprocessable_entity }
          format.json { render json: @bookmark.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /bookmarks/1
    # DELETE /bookmarks/1.json
    # Destroys the bookmark for the current user and the specified document.
    # Redirects to the bookmarks index with a success notice.
    def destroy
      Admin::Bookmark.destroy_by(user: current_user, document: @document)

      respond_to do |format|
        format.html { redirect_to admin_bookmarks_url, notice: "Bookmark was successfully destroyed." }
        format.js
      end
    end

    private

    # Sets the document based on the friendlier_id parameter.
    def set_document
      @document = Document.find_by(friendlier_id: params["document"])
    end

    # Only allow a list of trusted parameters through.
    def bookmark_params
      params.fetch(:bookmark, {})
    end

    # Collects bookmarks into a CSV format.
    # @param bookmarks [Array<Bookmark>] the bookmarks to be converted to CSV
    # @return [String] the generated CSV data
    def collect_csv(bookmarks)
      CSV.generate(headers: true) do |csv|
        csv << GeoblacklightAdmin::Schema.instance.importable_fields.map { |k, _v| k.to_s }
        bookmarks.map do |bookmark|
          csv << bookmark.document.to_csv
        end
      end
    end
  end
end
