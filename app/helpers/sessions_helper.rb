module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    session[:api_key] = user.api_key
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.where(:id => session[:user_id], :api_key => session[:api_key], :is_login => true).first
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    if current_user.present?
      current_user.update_attribute(:is_login, false)
      session.delete(:user_id)
      session.delete(:api_key)
    end
  end

  def logged_in_user
    #puts session.to_json
    unless logged_in?
      redirect_to login_url
    end
  end

  def logged_in_api
    @current_user ||= User.where(:api_key => params[:api_key], :is_login => true).first
    unless @current_user.present?
      render nothing: true, status: :unauthorized
    end
  end
end
