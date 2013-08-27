class SessionsController < ApplicationController
  layout 'top_page'

  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to_target_or_default root_url, :notice => t("login.succeed")
    else
      flash.now[:alert] = t("login.fail")
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => t("logout.succeed")
  end
end
