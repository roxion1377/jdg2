class ContestsController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_action :set_contest, :only => [:show,:edit,:update,:destroy,:ranking]
  before_action :admin_required, only:[:edit,:update,:destrpy,:create,:new]
  before_action(only: [:ranking]) {|c|contest_begin params[:id]}
  layout 'top_page', :only=>[:index,:new,:create]

  def index
    @contests = Contest.all
  end

  def ranking
    task_data = Struct.new("TaskData",:score,:state,:wa_num)
    data_s = Struct.new("Data",:user,:total_score,:task,:total_wa_num,:last_ac)
    @data = []
    users = @contest.users.where(:role=>"user")
    @tasks = @contest.tasks
    users.each do |user|
      default_scores = {}
      @tasks.each{|task| default_scores[task.serial] = task_data.new(0,0,0)}
      @data << data_s.new(user,0,default_scores,0,Time.utc(1999,12,31, 23,59,59))
    end
    @data.each do |d|
      user = d.user
      @tasks.each do |task|
        tresults = user.results.date_range(@contest.begin,@contest.end).where(:task => task)
        if tresults.exists?(:state_id=>8)
          mini = tresults.where(:state_id=>8).minimum(:created_at)
          id = tresults.where(:created_at=>mini).first.id
          results = tresults.where(["id<=?",id])
          wa_num = results.where("state_id>=4 and state_id<=7").size
          d.total_wa_num += wa_num
          d.last_ac = [d.last_ac,mini].max
          score = task.inputs.sum(:score)
          d.total_score += score
          d.task[task.serial].score = score
          d.task[task.serial].state = 8
          d.task[task.serial].wa_num = wa_num
        elsif tresults.exists?(["score>?",0])
          max = tresults.maximum(:score)
          mini = tresults.where(:score=>max).maximum(:created_at)

          id = tresults.where(:score=>max,:created_at=>mini).first.id
          results = tresults.where(["id<=?",id])
          wa_num = results.where(["state_id>=4 and state_id<=7 and id<>?",id]).size
          d.total_wa_num += wa_num
          d.total_score += max
          d.task[task.serial].score = max
          d.task[task.serial].state = 7
          d.task[task.serial].wa_num = wa_num
          d.last_ac = [d.last_ac,mini].max
        end
      end
    end
    @data.sort!{|a,b|
      (b.total_score <=> a.total_score).nonzero? ||
      (a.total_wa_num <=> b.total_wa_num).nonzero? ||
      (a.last_ac <=> b.last_ac)
    }
  end

  def show
  end

  def new
    @contest = Contest.new
  end

  def create
    @contest = Contest.new(contest_params)
    if @contest.save
      redirect_to @contest, :notice => "Successfully created contest."
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @contest.update_attributes(contest_params)
      redirect_to @contest, :notice  => "Successfully updated contest."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @contest.destroy
    redirect_to contests_url, :notice => "Successfully destroyed contest."
  end

  private
  def set_contest
    @contest = Contest.find(params[:id])
  end
  def contest_params
    params.require(:contest).permit(:name,:begin,:end)
  end
end
