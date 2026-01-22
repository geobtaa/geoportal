# frozen_string_literal: true

# Admin::ReferenceTypesController
#
# This controller manages the CRUD operations for ReferenceType objects
# within the admin namespace. It includes actions to list, show, create,
# update, and destroy reference types, as well as a custom sort action.
class Admin::ReferenceTypesController < Admin::AdminController
  before_action :set_reference_type, only: %i[show edit update destroy]

  # GET /admin/reference_types or /admin/reference_types.json
  #
  # Lists all reference types.
  def index
    @reference_types = ReferenceType.all
  end

  # GET /admin/reference_types/1 or /admin/reference_types/1.json
  #
  # Shows a specific reference type.
  def show
  end

  # GET /admin/reference_types/new
  #
  # Initializes a new reference type.
  def new
    @reference_type = ReferenceType.new
  end

  # GET /admin/reference_types/1/edit
  #
  # Edits an existing reference type.
  def edit
  end

  # POST /admin/reference_types or /admin/reference_types.json
  #
  # Creates a new reference type. If successful, redirects to the show page
  # of the newly created reference type. Otherwise, re-renders the new form.
  def create
    @reference_type = ReferenceType.new(reference_type_params)

    respond_to do |format|
      if @reference_type.save
        format.html { redirect_to admin_reference_type_path(@reference_type), notice: "Reference type was successfully created." }
        format.json { render :show, status: :created, location: @reference_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reference_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/reference_types/1 or /admin/reference_types/1.json
  #
  # Updates an existing reference type. If successful, redirects to the show
  # page of the updated reference type. Otherwise, re-renders the edit form.
  def update
    respond_to do |format|
      if @reference_type.update(reference_type_params)
        format.html { redirect_to admin_reference_type_path(@reference_type), notice: "Reference type was successfully updated." }
        format.json { render :show, status: :ok, location: @reference_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reference_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/reference_types/1 or /admin/reference_types/1.json
  #
  # Destroys a reference type. Redirects to the index page with a notice.
  def destroy
    @reference_type.destroy!

    respond_to do |format|
      format.html { redirect_to admin_reference_types_path, status: :see_other, notice: "Reference type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /admin/reference_types/sort
  #
  # Sorts reference types based on the provided list of IDs.
  def sort
    ReferenceType.sort_elements(params[:id_list])
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  #
  # Sets the @reference_type instance variable for actions that require it.
  def set_reference_type
    @reference_type = ReferenceType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  #
  # Permits the parameters required for creating or updating a reference type.
  def reference_type_params
    params.require(:reference_type).permit(:name, :reference_type, :reference_uri, :label, :note, :position)
  end
end
