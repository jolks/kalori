require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest

  test "new user signup, login, logout" do
    get "/users/new"
    assert_response :success
    post_via_redirect "/users/new", user: {
      username: 'newuser',
      email: 'newuser@test.com',
      password: '123456789'
    }
    assert_equal "/index", path
    delete_via_redirect "/logout"
    assert_equal "/", path
  end

  test "login, high-level user related actions, logout" do
    # Login
    get "/login"
    assert_response :success
    post_via_redirect "/login", {
      :session => {
        :username => "u1",
        :password => "123456789"
      }
    }
    assert_equal "/index", path
    
    # Should see 1 calorie i.e. c2 posted today
    assert_equal 1, assigns(:calories_count)

    # Should not exceed expected calories per day
    get "/api/calories/exceed/1", {
      :api_key => "abcdefg"
    }
    resp = JSON.parse(@response.body)
    assert_not resp["exceed"]

    # Create new calorie
    post "/api/calories/1", {
      :api_key => "abcdefg",
      :value => 3000,
      :description => "super ramen"
    }
    new_cal = JSON.parse(@response.body)

    # Should exceed expected calories per day
    get "/api/calories/exceed/1", {
      :api_key => "abcdefg"
    }
    resp = JSON.parse(@response.body)
    assert resp["exceed"]

    # Filter to get past calories
    get "/api/calories/filter/1", {
      :api_key => "abcdefg",
      :date_from => "2016-01-01",
      :time_from => 12,
      :date_to => "2016-01-01",
      :time_to => 18
    }
    resp = JSON.parse(@response.body)
    assert_equal 2, resp.count

    # Update the super ramen calorie
    post "/api/calories/#{new_cal['id']}/user/1", {
      :api_key => "abcdefg",
      :value => 400,
    }

    # Should not exceed expected calories per day
    get "/api/calories/exceed/1", {
      :api_key => "abcdefg"
    }
    resp = JSON.parse(@response.body)
    assert_not resp["exceed"]

    # Delete super ramen calorie
    get "/api/calories/delete/#{new_cal['id']}/user/1", {
      :api_key => "abcdefg"
    }
    assert_nil Calory.where(:id => new_cal['id']).first

    # Logout
    delete_via_redirect "/logout"
    assert_equal "/", path
  end
end
