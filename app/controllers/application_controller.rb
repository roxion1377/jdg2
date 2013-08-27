class ApplicationController < ActionController::Base
  include ControllerAuthentication
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def admin_required
    unless current_user && current_user.admin?
      redirect_to root_path
    end
  end
  def contest_begin(contest_id)
    return if current_user.admin?
    contest = Contest.find(contest_id)
    if contest && Time.now < contest.begin
      render "contests/not_begin"
    end
  end
  def contest_end(contest_id)
    return if current_user.admin?
    contest = Contest.find(contest_id)
    if contest && Time.now < contest.end
      render "contests/not_end"
    end
  end
end
