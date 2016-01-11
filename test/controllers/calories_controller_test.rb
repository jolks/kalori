require 'test_helper'

class CaloriesControllerTest < ActionController::TestCase
  test "should show today's list (per day basis) of calories" do
    # Set sessions to log in
    get :index, nil, {
      :user_id => 1,
      :api_key => "abcdefg"
    }

    # In case of the need of checking fixtures data
    #puts calories(:c1).as_json
    #puts users(:u1).as_json

    assert_not_nil assigns(:calories)
    assert_equal 1, assigns(:calories_count)
  end

  test "check calories filter" do
    get :filter_calories, {
      :user_id => 1,
      :api_key => "abcdefg",
      :date_from => "2016-01-01",
      :time_from => 12,
      :date_to => "2016-01-01",
      :time_to => 18
    }
    resp = JSON.parse(@response.body)
    assert_equal 2, resp.count
  end

  test "get c1 calorie" do
    get :get_calorie, {
      :user_id => 1,
      :api_key => "abcdefg",
      :id => 1
    }
    resp = JSON.parse(@response.body)
    assert_equal "coffee", resp["description"]
    assert_equal 100, resp["value"]
  end

  test "check unauthorized get c1 calorie" do
    get :get_calorie, {
      :user_id => 2,
      :api_key => "abcdefgh",
      :id => 1
    }
    assert_response 401
  end

  test "get u1 user's expected calories per day" do
    get :get_expected_calories, {
      :user_id => 1,
      :api_key => "abcdefg"
    }
    resp = JSON.parse(@response.body)
    assert_equal 2000, resp["expected_calories"]
  end

  test "c1 calorie should be updated correctly" do
    post :update_calorie, {
      :user_id => 1,
      :api_key => "abcdefg",
      :id => 1,
      :value => 3000,
      :description => "megabar"
    }
    assert_equal 3000, assigns(:calorie)[:value]
    assert_equal "megabar", assigns(:calorie)[:description]
    resp = JSON.parse(@response.body)
    assert_equal 3000, resp["value"]
    assert_equal "megabar", resp["description"]
  end

  test "u1 user's expected calories per day should be updated correctly" do
    post :update_expected_calories, {
      :user_id => 1,
      :api_key => "abcdefg",
      :total_expected_calories => 3000
    }
    assert_equal 3000, assigns(:user)[:total_expected_calories]
    resp = JSON.parse(@response.body)
    assert_equal 3000, resp["total_expected_calories"]
  end

  test "create new calorie" do
    post :create_calorie, {
      :user_id => 1,
      :api_key => "abcdefg",
      :value => 1000,
      :description => "ramen"
    }
    assert_equal 1, assigns(:calorie)[:user_id]
    assert_equal 1000, assigns(:calorie)[:value]
    assert_equal "ramen", assigns(:calorie)[:description]
  end

  test "delete a calorie" do
    get :delete_calorie, {
      :user_id => 1,
      :api_key => "abcdefg",
      :id => 1
    }
    assert_nil Calory.where(:id => 1).first
  end

  test "check exceed expected calories per day" do
    get :exceed_expected_calories, {
      :user_id => 1,
      :api_key => "abcdefg"
    }
    resp = JSON.parse(@response.body)
    assert_not resp["exceed"]

    # Create new calorie to exceed the threshold of default 2000
    post :create_calorie, {
      :user_id => 1,
      :api_key => "abcdefg",
      :value => 5000,
      :description => "super ramen"
    }
    get :exceed_expected_calories, {
      :user_id => 1,
      :api_key => "abcdefg"
    }
    resp = JSON.parse(@response.body)
    assert resp["exceed"]
  end
end
