class TasksController < ApplicationController
  before_action :login_required, only: [:new,:create,:edit,:update,:destroy]
  before_action :admin_required, only: [:new,:create,:edit,:update,:destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_tasks, only: [:index]
  before_action(:only=>[:index]) {|c|contest_begin params[:contest_id]}
  #before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @contest = Contest.find(params[:contest_id])
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @contest = Contest.find(params[:contest_id])
    @task = @contest.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        Dir::mkdir("task_data/#{@task.id}")
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to contest_tasks_url(@task.contest) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
      @contest = @task.contest
    end

    def set_tasks
      @contest = Contest.find(params[:contest_id])
      @tasks = @contest.tasks.order(:serial)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:serial, :name, :tl, :ml, :body, :judge_type, :contest_id)
    end
end
