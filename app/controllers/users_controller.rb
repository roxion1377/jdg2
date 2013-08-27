class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  layout 'top_page'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => t("user.create.succeed")
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to root_url, :notice => t("user.edit.succeed")
    else
      render :action => 'edit'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:username,:password,:password_confirmation)
  end
end
