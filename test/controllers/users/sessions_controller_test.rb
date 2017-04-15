require 'test_helper'

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should login" do
    data = {
      email: 'fulano@gmail.com',
      password: '123456'
    }
    post user_session_url(user: data)
    assert_response :success
    assert json_response['success']
    assert_includes json_response['data'], 'token'
  end

  test "should not login" do
    data = {
      email: 'fulano@gmail.com',
      password: '1234567'
    }
    post user_session_url(user: data)
    assert_response :unauthorized
    assert_not json_response['success']
  end

  test "should logout" do
    delete destroy_user_session_url(token: get_token)
    assert_response :success
    assert json_response['success']
  end
end
