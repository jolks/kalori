require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get login page if not logged in" do
    get :new
    assert_response :success
  end

  test "should get index page after logged in" do
    post :create, {
      :session => {
        :username => "u1",
        :password => "123456789"
      }
    }
    assert_equal session[:user_id], 1
    assert_equal session[:api_key], "abcdefg"
    assert_redirected_to index_path
  end

  test "should get login page if wrong password" do
    post :create, {
      :session => {
        :username => "u1",
        :password => "wrongpassword"
      }
    }
    assert_template :new
  end

  test "check user logout and redirect to root after login in" do
    post :create, {
      :session => {
        :username => "u1",
        :password => "123456789"
      }
    }
    delete :destroy
    assert_nil session[:user_id]
    assert_nil session[:api_key]
    assert_redirected_to root_url
  end

  test "check successful login/logout via API" do
    post :login_api, {
      :user_id => 1,
      :password => "123456789"
    }
    assert_response 200
    get :logout_api, {
      :user_id => 1,
      :api_key => "abcdefg"
    }
    assert_response 200
  end

  # Use u2 user since is_login is FALSE
  test "check unsuccessful login/logout via API" do
    post :login_api, {
      :user_id => 2,
      :password => "wrongpassword"
    }
    assert_response 401
    get :logout_api, {
      :user_id => 2,
      :api_key => "abcdefg"
    }
    assert_response 401
  end
end
