require 'test_helper'

class EvolutionsControllerTest < ActionDispatch::IntegrationTest
  test "should save or update evolution data" do
    training = trainings(:one)
    data = {
      token: '123',
      evolution: {
        training_id: training.id,
        date: '2017-05-02',
        weight: 46,
        series: 3
      }
    }
    post evolutions_save_or_update_url, as: :json, params: data
    assert_response :success
    assert json_response['success']
  end

  test "should not save training_id of other user" do
    training = trainings(:one)
    data = {
      token: '456',
      evolution: {
        training_id: training.id,
        date: '2017-05-02',
        weight: 46,
        series: 3
      }
    }
    post evolutions_save_or_update_url, as: :json, params: data
    assert_response :success
    assert_not json_response['success']
    assert_includes json_response, 'message'
  end
end
