class ResultsController < ApplicationController
  before_action :login_required, only: [:new,:create]
  before_action :set_result_contest, only: [:index, :new, :create, :user_index, :my_results, :user_results]
  before_action :set_result, only: [:show]
  before_action(:only=>[:show],:if=>:other_submittion?) {|c| contest_end(@contest.id)}

  # GET /results
  # GET /results.json
  def index
    #@results = @contest.tasks.map{|f|f.results}.flatten.sort{|a,b|b.created_at<=>a.created_at}
    user_index params[:user] and return if params[:user]
    @results = Result.select("*,results.id as id,users.id as user_id").joins(:user).page(params[:page]).per(15).where(:task_id => @contest.tasks,'users.role'=>"user")
  end

  def user_index(id)
    #@results = @contest.tasks.map{|f|f.results.where(:user_id=>id)}.flatten.sort{|a,b|b.created_at<=>a.created_at}
    @results = Result.select("*,results.id as id,users.id as user_id").joins(:user).page(params[:page]).per(15).where(:task_id => @contest.tasks,:user_id=>id,'users.role'=>"user")
    render 'index'
  end

  def my_results
    current_user ? user_index(current_user.id) : index
  end

  def user_results
    user_index params[:user_id]
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @details = @result.details
  end

  # GET /results/new
  def new
    @result = Result.new
  end

  # GET /results/1/edit
  def edit
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.create(result_params)
    @result.user = current_user
    #cookies[:lang_id] = @result.lang_id
    cookies[:lang_id] = @result.lang_id||1
    respond_to do |format|
      if @result.judge
        cookies[:lang_id] = @result.lang_id
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render action: 'show', status: :created, location: @result }
      else
        format.html { render action: 'new' }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result.destroy
    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Result.find(params[:id])
      @contest = @result.task.contest
    end
    def set_result_contest
      @contest = Contest.find(params[:contest_id])
      @tasks = @contest.tasks
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:lang_id,:code,:task_id)
      #params.require(:result).permit(:lang_id,:code)
    end
    def other_submittion?
      @result && (@result.user != current_user || @result.user.admin?)
    end
end
