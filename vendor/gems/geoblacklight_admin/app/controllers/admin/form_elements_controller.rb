# frozen_string_literal: true

# Admin::FormElementsController
#
# This controller manages the CRUD operations for form elements within the admin namespace.
# It provides actions to list, show, create, update, and delete form elements.
#
# Actions:
# - index: Lists all form elements.
# - show: Displays a specific form element.
# - new: Renders a form for creating a new form element.
# - edit: Renders a form for editing an existing form element.
# - create: Creates a new form element.
# - update: Updates an existing form element.
# - destroy: Deletes a form element.
# - sort: Sorts form elements based on a provided list of IDs.
#
# Before Actions:
# - set_form_element: Sets the form element for show, edit, update, and destroy actions.
#
# Private Methods:
# - set_form_element: Finds and sets the form element by ID, redirects if not found.
# - form_element_params: Permits only trusted parameters for form elements.
module Admin
  class FormElementsController < Admin::AdminController
    before_action :set_form_element, only: %i[show edit update destroy]

    # GET /form_elements or /form_elements.json
    # Lists all form elements.
    def index
      @form_elements = FormElement.all
    end

    # GET /form_elements/1 or /form_elements/1.json
    # Displays a specific form element.
    def show
    end

    # GET /form_elements/new
    # Renders a form for creating a new form element.
    def new
      @form_element = FormElement.new
    end

    # GET /form_elements/1/edit
    # Renders a form for editing an existing form element.
    def edit
    end

    # POST /form_elements or /form_elements.json
    # Creates a new form element.
    def create
      @form_element = FormElement.new(form_element_params)

      respond_to do |format|
        if @form_element.save
          format.html { redirect_to admin_form_elements_path, notice: "Form element was successfully created." }
          format.json { render :show, status: :created, location: @form_element }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @form_element.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /form_elements/1 or /form_elements/1.json
    # Updates an existing form element.
    def update
      respond_to do |format|
        if @form_element.update(form_element_params)
          format.html { redirect_to admin_form_element_url(@form_element), notice: "Form element was successfully updated." }
          format.json { render :show, status: :ok, location: @form_element }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @form_element.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /form_elements/1 or /form_elements/1.json
    # Deletes a form element.
    def destroy
      @form_element.destroy

      respond_to do |format|
        format.html { redirect_to admin_form_elements_url, notice: "Form element was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # POST /form_elements/sort
    # Sorts form elements based on a provided list of IDs.
    def sort
      FormElement.sort_elements(params[:id_list])
      render body: nil
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets the form element by ID, redirects if not found.
    def set_form_element
      @form_element = FormElement.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_form_elements_url, alert: "Form element not found."
    end

    # Only allow a list of trusted parameters through.
    # Permits only trusted parameters for form elements.
    def form_element_params
      params.require(:form_element).permit(:type, :label, :element_solr_field)
    end
  end
end
