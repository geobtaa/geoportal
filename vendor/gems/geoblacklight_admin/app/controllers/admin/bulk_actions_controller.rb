# frozen_string_literal: true

# Admin::BulkActionsController
#
# This controller manages bulk actions within the admin interface.
# It provides actions to list, show, create, update, destroy, run, and revert bulk actions.
module Admin
  class BulkActionsController < Admin::AdminController
    before_action :set_bulk_action, only: %i[show edit update destroy run revert]

    # GET /bulk_actions
    # GET /bulk_actions.json
    #
    # Lists all bulk actions, paginated.
    # @return [Array<BulkAction>] List of bulk actions
    def index
      @pagy, @bulk_actions = pagy(BulkAction.all.order(created_at: :desc), items: 20)
    end

    # GET /bulk_actions/1
    # GET /bulk_actions/1.json
    #
    # Shows a specific bulk action and its associated documents.
    # @return [BulkAction] The requested bulk action
    def show
      @pagy, @documents = pagy(@bulk_action.documents, items: 30)
      @bulk_action.check_run_state
    end

    # GET /bulk_actions/new
    #
    # Initializes a new bulk action with a given scope.
    # @return [BulkAction] A new bulk action instance
    def new
      @bulk_action = BulkAction.new(scope: params[:scope])
    end

    # GET /bulk_actions/1/edit
    #
    # Prepares a bulk action for editing.
    # @return [BulkAction] The bulk action to be edited
    def edit
    end

    # POST /bulk_actions
    # POST /bulk_actions.json
    #
    # Creates a new bulk action.
    # @return [BulkAction] The created bulk action
    def create
      @bulk_action = BulkAction.new(bulk_action_params)

      respond_to do |format|
        if @bulk_action.save
          format.html do
            redirect_to admin_bulk_action_path(@bulk_action), notice: "Bulk action was successfully created."
          end
          format.json { render :show, status: :created, location: @bulk_action }
        else
          format.html { render :new }
          format.json { render json: @bulk_action.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /bulk_actions/1
    # PATCH/PUT /bulk_actions/1.json
    #
    # Updates an existing bulk action.
    # @return [BulkAction] The updated bulk action
    def update
      respond_to do |format|
        if @bulk_action.update(bulk_action_params)
          format.html do
            redirect_to admin_bulk_action_path(@bulk_action), notice: "Bulk action was successfully updated."
          end
          format.json { render :show, status: :ok, location: @bulk_action }
        else
          format.html { render :edit }
          format.json { render json: @bulk_action.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /bulk_actions/1
    # DELETE /bulk_actions/1.json
    #
    # Deletes a bulk action.
    # @return [void]
    def destroy
      @bulk_action.destroy
      respond_to do |format|
        format.html { redirect_to admin_bulk_actions_url, notice: "Bulk action was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # Runs a bulk action.
    # @return [void]
    def run
      @bulk_action.run!
      # @bulk_action.state_machine.transition_to!(:queued)
      redirect_to admin_bulk_action_url(@bulk_action), notice: "Bulk action is running. Check back soon for results."
    end

    # Reverts a bulk action.
    # @return [void]
    def revert
      @bulk_action.revert!
      @bulk_action.state_machine.transition_to!(:queued)
      redirect_to admin_bulk_action_url(@bulk_action),
        notice: "Revert bulk action is running. Check back soon for results."
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    # Finds and sets the bulk action based on the provided ID.
    # @return [BulkAction] The found bulk action
    def set_bulk_action
      @bulk_action = BulkAction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # @return [ActionController::Parameters] The permitted parameters
    def bulk_action_params
      params.require(:bulk_action).permit(:name, :scope, :request, :field_name, :field_value)
    end
  end
end
