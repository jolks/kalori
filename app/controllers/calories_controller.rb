class CaloriesController < ApplicationController
  # Since most calories actions are via API,
  # Cross-Site Request Forgery (CSRF) token check is skipped.
  skip_before_action :verify_authenticity_token

  # Web page verified through session. Required to protect the whole page.
  before_action :logged_in_user, only: [:index]
  # API verified through API key.
  before_action :logged_in_api, only: [
    :get_all_calories,
    :get_expected_calories,
    :update_expected_calories
  ]

  def index
    @calories = @current_user.calories
  end

  # verify with API key
  def get_all_calories
    @user = User.where(:id => params[:user_id]).first
    render json: @user.present? ? @user.calories : {:message => 'user not found'}
  end

  def get_expected_calories
    resp = {:expected_calories => 0}
    @user = User.where(:id => params[:user_id]).first
    if @user.present?
      resp[:expected_calories] = @user.total_expected_calories
    end
    render json: resp
  end

  def update_expected_calories
    @user = User.where(:id => params[:user_id]).first
    @user.update_attribute(:total_expected_calories, params[:total_expected_calories])
    render json: @user.present? ? @user.as_json.except('password_digest') : {:message => 'user not found'}
  end

  def create_calorie
    resp = {}
    status_code = 500
    @user = User.where(:id => params[:user_id]).first
    @calorie = Calory.new
    @calorie.description = params['description']
    @calorie.value = params['value']
    @calorie.user_id = @user.id
    if @calorie.valid?
      @calorie.save
      resp = @calorie
      status_code = 200
    end
    render json: resp, status: status_code
  end

  def exceed_expected_calories
    resp = {:exceed => false}
    @user = User.where(:id => params[:user_id]).first
    if @user.calories.sum('value') > @user.total_expected_calories
      resp[:exceed] = true
    end
    render json: resp
  end
end
