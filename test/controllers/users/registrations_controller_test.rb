require 'test_helper'

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should not create account" do
    data = {
      email: 'a',
      password: 'a',
      gender: 'a',
    }
    post user_registration_url(user: data)
    assert_response :unprocessable_entity
    assert_not json_response['success']
  end

  test "should create account" do
    data = {
      email: 'judite@gmail.com',
      password: '123456',
      gender: 'male',
    }
    post user_registration_url(user: data)
    assert_response :success
    assert json_response['success']
    assert_includes json_response['data'], 'token'
  end

  test "should update account" do
    data = {
      name: 'Judite',
      password: '1234567',
      gender: 'female',
    }
    put user_registration_url(user: data, token: get_token)
    assert_response :success
    assert json_response['success']
    assert_includes json_response['data'], 'token'
  end
end
