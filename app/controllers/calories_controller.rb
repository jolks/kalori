class CaloriesController < ApplicationController
  # Web page verified through session. Required to protect the whole page.
  before_action :logged_in_user, only: [:index]
  # API verified through API key.
  before_action :logged_in_api, only: [:get_all_calories]

  def index
  end

  # verify with API key
  def get_all_calories
    @user = User.where(:id => params[:user_id]).first
    render json: @user.present? ? @user.calories : {:message => 'user not found'}
  end
end
