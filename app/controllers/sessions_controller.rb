class SessionsController < ApplicationController

  before_action :logged_in?, only: [:new, :create]

  def new
    if current_user && current_user.session_token
      redirect_to cats_url
    else
      @user = User.new
      render :new
    end
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if @user.nil?
      redirect_to cats_url
      #flash.now[:errors] = @user.errors.full_messages
    else
      @user.reset_session_token!
      self.login!(@user)
      redirect_to user_url(@user)
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end


end
