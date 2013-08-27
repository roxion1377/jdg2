class InputsController < ApplicationController
  before_filter :login_required, only: [:new,:create,:edit,:update,:destroy,:show]
  before_filter :admin_required
  before_action :set_input_task, only: [:index,:new,:create]
  before_action :set_input, only: [:show, :edit, :update, :destroy]

  # GET /inputs
  # GET /inputs.json
  def index
    @inputs = @task.inputs.all
  end

  # GET /inputs/1
  # GET /inputs/1.json
  def show
  end

  # GET /inputs/new
  def new
    @input = Input.new
  end

  # GET /inputs/1/edit
  def edit
  end

  # POST /inputs
  # POST /inputs.json
  def create
    @task = Task.find(params[:task_id])
    @input = @task.inputs.new(input_params)

    respond_to do |format|
      if @input.save && @input.save_file(data_params)
        format.html { redirect_to @input, notice: 'Input was successfully created.' }
        format.json { render action: 'show', status: :created, location: @input }
      else
        format.html { render action: 'new' }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /inputs/1
  # PATCH/PUT /inputs/1.json
  def update
    respond_to do |format|
      if @input.update(input_params) && @input.save_file(data_params)
        format.html { redirect_to @input, notice: 'Input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @input.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inputs/1
  # DELETE /inputs/1.json
  def destroy
    @input.destroy
    respond_to do |format|
      format.html { redirect_to task_inputs_url(@input.task) }
      format.json { head :no_content }
    end
  end

  private
    def set_input_task
      @task = Task.find(params[:task_id])
      @contest = @task.contest
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_input
      @input = Input.find(params[:id])
      @task = @input.task
      @contest = @task.contest
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def input_params
      params.require(:input).permit(:task_id, :dir_name, :score)
    end
    def data_params
      params.require(:data).permit(:input => [], :output => [])
    end
end
