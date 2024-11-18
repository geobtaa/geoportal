class GeonamesController < ApplicationController
  before_action :set_geoname, only: %i[ show edit update destroy ]

  # GET /geonames or /geonames.json
  def index
    @geonames = Geoname.all
  end

  # GET /geonames/1 or /geonames/1.json
  def show
  end

  # GET /geonames/new
  def new
    @geoname = Geoname.new
  end

  # GET /geonames/1/edit
  def edit
  end

  # POST /geonames or /geonames.json
  def create
    @geoname = Geoname.new(geoname_params)

    respond_to do |format|
      if @geoname.save
        format.html { redirect_to @geoname, notice: "Geoname was successfully created." }
        format.json { render :show, status: :created, location: @geoname }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @geoname.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /geonames/1 or /geonames/1.json
  def update
    respond_to do |format|
      if @geoname.update(geoname_params)
        format.html { redirect_to @geoname, notice: "Geoname was successfully updated." }
        format.json { render :show, status: :ok, location: @geoname }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @geoname.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geonames/1 or /geonames/1.json
  def destroy
    @geoname.destroy

    respond_to do |format|
      format.html { redirect_to geonames_path, status: :see_other, notice: "Geoname was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geoname
      @geoname = Geoname.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def geoname_params
      params.require(:geoname).permit(:geonameid, :name, :asciiname, :alternatenames, :latitude, :longitude, :feature_class, :feature_code, :country_code, :cc2, :admin1_code, :admin2_code, :admin3_code, :admin4_code, :population, :elevation, :dem, :timezone, :modification_date)
    end
end
