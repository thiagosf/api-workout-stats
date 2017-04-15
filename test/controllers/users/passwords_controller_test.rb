require 'test_helper'

class Users::PasswordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    user = User.first
    @reset_password_token = user.send_reset_password_instructions
  end

  test "should not find account" do
    data = {
      email: 'emailinexistente@gmail.com'
    }
    post user_password_url(user: data)
    assert_response :unprocessable_entity
    assert_not json_response['success']
  end

  test "should send email" do
    data = {
      email: 'fulano@gmail.com'
    }
    post user_password_url(user: data)
    assert_response :success
    assert json_response['success']
  end

  test "deve informar que senhas não conferem" do
    data = {
      reset_password_token: @reset_password_token,
      password: '123456',
      password_confirmation: '1234567',
    }
    put user_password_url(user: data)
    assert_response :unprocessable_entity
    assert_not json_response['success']
  end

  test "should update password" do
    data = {
      reset_password_token: @reset_password_token,
      password: '123456',
      password_confirmation: '123456',
    }
    put user_password_url(user: data)
    assert_response :success
    assert json_response['success']
  end
end
