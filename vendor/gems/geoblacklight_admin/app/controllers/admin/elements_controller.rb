# frozen_string_literal: true

# Admin::ElementsController
# This controller manages the CRUD operations for elements within the admin namespace.
# It includes actions for listing, showing, creating, updating, and deleting elements.
# Additionally, it provides a custom action for sorting elements.
module Admin
  class ElementsController < Admin::AdminController
    before_action :set_element, only: %i[show edit update destroy]

    # GET /elements or /elements.json
    # Lists all elements, ordered by position in ascending order.
    # Uses pagination to limit the number of elements displayed per page.
    def index
      @elements = Element.all.order(position: :asc)
    end

    # GET /elements/1 or /elements/1.json
    # Displays a specific element.
    def show
    end

    # GET /elements/new
    # Initializes a new element object.
    def new
      @element = Element.new
    end

    # GET /elements/1/edit
    # Prepares an element for editing.
    def edit
    end

    # POST /elements or /elements.json
    # Creates a new element with the provided parameters.
    # If successful, redirects to the element's show page with a success notice.
    # If unsuccessful, re-renders the new element form with error messages.
    def create
      @element = Element.new(element_params)

      respond_to do |format|
        if @element.save
          format.html { redirect_to admin_element_url(@element), notice: "Element was successfully created." }
          format.json { render :show, status: :created, location: @element }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @element.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /elements/1 or /elements/1.json
    # Updates an existing element with the provided parameters.
    # If successful, redirects to the element's show page with a success notice.
    # If unsuccessful, re-renders the edit form with error messages.
    def update
      respond_to do |format|
        if @element.update(element_params)
          format.html { redirect_to admin_element_url(@element), notice: "Element was successfully updated." }
          format.json { render :show, status: :ok, location: @element }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @element.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /elements/1 or /elements/1.json
    # Deletes a specific element.
    # Redirects to the elements index page with a success notice.
    def destroy
      @element.destroy

      respond_to do |format|
        format.html { redirect_to admin_elements_url, notice: "Element was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # POST /elements/sort
    # Sorts elements based on the provided list of IDs.
    # Renders an empty response body.
    def sort
      Element.sort_elements(params[:id_list])
      render body: nil
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds an element by ID and sets it as an instance variable.
    # Redirects to the elements index page with an alert if the element is not found.
    def set_element
      @element = Element.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_elements_url, alert: "Element not found."
    end

    # Only allow a list of trusted parameters through.
    # Permits specific parameters for element creation and updates.
    def element_params
      params.require(:element).permit(:label, :solr_field, :field_definition, :field_type, :required, :repeatable,
        :formable, :placeholder_text, :data_entry_hint, :test_fixture_example, :controlled_vocabulary, :js_behaviors, :html_attributes, :display_only_on_persisted, :importable, :import_deliminated, :import_transformation_method, :exportable, :export_transformation_method, :indexable, :index_transformation_method, :validation_method, :position)
    end
  end
end
