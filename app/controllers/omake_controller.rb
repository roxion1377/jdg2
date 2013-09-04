class OmakeController < ApplicationController
  before_action :set_omake_contest, only:[:index]
  before_action :set_omake, only: [:show, :edit, :update, :destroy]

  # GET /omakes
  # GET /omakes.json
  def index
    @omakes = Omake.all
  end

  # GET /omakes/1
  # GET /omakes/1.json
  def show
  end

  # GET /omakes/new
  def new
    @omake = Omake.new
  end

  # GET /omakes/1/edit
  def edit
  end

  # POST /omakes
  # POST /omakes.json
  def create
    @omake = Omake.new(omake_params)

    respond_to do |format|
      if @omake.save
        format.html { redirect_to @omake, notice: 'Omake was successfully created.' }
        format.json { render action: 'show', status: :created, location: @omake }
      else
        format.html { render action: 'new' }
        format.json { render json: @omake.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /omakes/1
  # PATCH/PUT /omakes/1.json
  def update
    respond_to do |format|
      if @omake.update(omake_params)
        format.html { redirect_to @omake, notice: 'Omake was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @omake.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /omakes/1
  # DELETE /omakes/1.json
  def destroy
    @omake.destroy
    respond_to do |format|
      format.html { redirect_to omakes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_omake
      @omake = Omake.find(params[:id])
    end
    
    def set_omake_contest
      @contest = Contest.find(params[:contest_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def omake_params
      params[:omake]
    end
end
