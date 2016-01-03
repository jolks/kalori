class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.username = user_params['username']
    @user.email = user_params['email']
    @user.password = user_params['password']
    @user.api_key = SecureRandom.hex
    if @user.valid?
      @user.save
      redirect_to login_path
    else
      render 'new'
    end
  end

  private
    # For mass assignment security vulnerability
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
