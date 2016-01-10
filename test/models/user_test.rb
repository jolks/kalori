require 'test_helper'

class UserTest < ActiveSupport::TestCase  
  test "count user created from fixtures" do
    assert_equal 2, User.count
  end

  test "new user email is not unique" do
    user = User.new
    # email address used by another user in fixtures
    user.email = 'u1@test.com'
    user.username = 'u3'
    user.api_key = 'abcdefg'
    user.password = '123456789'
    assert_not user.save
  end

  test "new user username is not unique" do
    user = User.new
    user.email = 'u3@test.com'
    # username used by another user in fixtures
    user.username = 'u1'
    user.api_key = 'abcdefg'
    user.password = '123456789'
    assert_not user.save
  end
end
