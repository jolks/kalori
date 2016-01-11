class SessionsController < ApplicationController
  # Since user's authentication is an API,
  # Cross-Site Request Forgery (CSRF) token check is skipped.
  # Login limit implementation is skipped.
  skip_before_action :verify_authenticity_token

  # Unique API key and User ID (users table id column) are used to login.
  # Only set is_login when User is authenticated with password.

  # Login page
  def new
    if logged_in?
      redirect_to index_path
    end
  end

  # Authenticate with username and password.
  # Set is_login if successful.
  def create
    user = User.find_by(username: params[:session][:username])

    if user && user.authenticate(params[:session][:password])
      # Log the user in
      log_in user
      user.update_attribute(:is_login, true)
      redirect_to index_path
    else
      # Using render in case any error flash message is to shown in future. 
      render 'new'
    end # END IF-ELSE login
  end

  def login_api
    user = User.find_by(id: params[:user_id])
    resp = {}
    status_code = 401

    if user && user.authenticate(params[:password])
      user.update_attribute(:is_login, true)
      status_code = 200
      resp = user.as_json.except('password_digest')
    end

    render json: resp, status: status_code
  end

  def logout_api
    user = User.where(:id => params[:user_id], :api_key => params[:api_key], :is_login => true).first
    resp = {}
    status_code = 401

    if user.present?
      user.update_attribute(:is_login, false)
      status_code = 200
      resp = user.as_json.except('password_digest')
    end

    render json: resp, status: status_code
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
