class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def log_in(user)
    session[:session_token] = user.reset_session_token!
  end

  def log_out
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  def redirect_if_logged_in
    render json: {}, status: 404 if current_user
  end

  def redirect_unless_logged_in
    render json: {}, status: 401 unless current_user
  end
end
