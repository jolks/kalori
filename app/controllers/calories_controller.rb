class CaloriesController < ApplicationController
  # Since most calories actions are via API,
  # Cross-Site Request Forgery (CSRF) token check is skipped.
  skip_before_action :verify_authenticity_token

  # Web page verified through session. Required to protect the whole page.
  before_action :logged_in_user, only: [:index]
  # API verified through API key.
  before_action :logged_in_api, only: [
    :get_all_calories,
    :filter_calories,
    :get_calorie,
    :get_expected_calories,
    :update_calorie,
    :update_expected_calories,
    :create_calorie,
    :delete_calorie,
    :exceed_expected_calories
  ]

  def index
    # Per day basis!
    @calories = @current_user.calories.where('created_at BETWEEN ? AND ?', Date.today.to_time, Date.tomorrow.to_time)
    @calories_count = @calories.count
  end

  # verify with API key
  def get_all_calories
    @user = User.where(:id => params[:user_id]).first
    render json: @user.present? ? @user.calories : {:message => 'user not found'}
  end

  def filter_calories
    @calories = Calory.where(:user_id => params[:user_id]).filter_by_date_hour(
      params[:date_from],
      params[:time_from],
      params[:date_to],
      params[:time_to]
    )
    render json: @calories.present? ? @calories : []
  end

  def get_calorie
    @calorie = Calory.where(:id => params[:id], :user_id => params[:user_id]).first
    render json: @calorie.present? ? @calorie.as_json.except('user_id') : {:message => 'calorie not found'}
  end

  def get_expected_calories
    resp = {:expected_calories => 0}
    @user = User.where(:id => params[:user_id]).first
    if @user.present?
      resp[:expected_calories] = @user.total_expected_calories
    end
    render json: resp
  end

  def update_calorie
    @calorie = Calory.where(:id => params[:id], :user_id => params[:user_id]).first
    @calorie.update_attribute(:value, params['value'])
    @calorie.update_attribute(:description, params['description'])
    render json: @calorie.present? ? @calorie.as_json.except('user_id') : {:message => 'calorie not found'}
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

  def delete_calorie
    @calorie = Calory.where(:id => params[:id], :user_id => params[:user_id]).first
    @calorie.destroy
    render nothing: true
  end

  def exceed_expected_calories
    resp = {:exceed => false}
    @user = User.where(:id => params[:user_id]).first
    # Per day basis!
    if @user.calories.where('created_at BETWEEN ? AND ?', Date.today.to_time, Date.tomorrow.to_time).sum('value') > @user.total_expected_calories
      resp[:exceed] = true
    end
    render json: resp
  end
end
