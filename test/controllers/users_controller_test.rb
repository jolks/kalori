require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get signup page" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "should create new user then login/redirect to index page" do
    assert_difference('User.count') do
      post :create, user: {
        username: 'newuser',
        email: 'newuser@test.com',
        password: '123456789'
      }
    end
    assert_equal session[:user_id], assigns(:user)[:id]
    assert_equal session[:api_key], assigns(:user)[:api_key]
    assert assigns(:user)[:is_login]
    assert_equal assigns(:user)[:total_expected_calories], 2000
    assert_redirected_to index_path
  end
end
