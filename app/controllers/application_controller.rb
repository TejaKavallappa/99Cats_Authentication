class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :valid_owner?, :has_valid_owner?

  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def logout!
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
  end

  def logged_in?
    redirect_to cats_url if current_user && current_user.session_token
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def valid_owner?
    @cat = Cat.find(params[:id])
    unless (current_user && (@cat.user_id == current_user.id))
      redirect_to cat_url(@cat)
      flash.now[:errors] = @cat.errors.full_messages
    end
  end

  def has_valid_owner?
    @cat = Cat.find(params[:id])
    return (current_user && (@cat.user_id == current_user.id))
  end
end
