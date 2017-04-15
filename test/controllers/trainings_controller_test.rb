require 'test_helper'

class TrainingsControllerTest < ActionDispatch::IntegrationTest
  test "should create bulk training" do
    data = {
      token: '123',
      trainings: [
        { category: 'Tríceps', name: 'Supino reto' },
        { category: 'Tríceps', name: 'Supino 45' },
        { category: 'Tríceps', name: 'Francesa' },
        { category: 'Bíceps', name: 'Rosca direta' },
        { category: 'Bíceps', name: 'Rosca scott' },
        { category: 'Bíceps', name: 'Barra fixa' },
        { category: 'Pernas', name: 'Agachamento' },
        { category: 'Ombros', name: 'Elevação lateral' },
        { category: 'Ombros', name: 'Elevação frontal' },
      ]
    }
    post trainings_bulk_create_url, as: :json, params: data
    assert_response :success
    assert json_response['success']
    assert_includes json_response, 'data'
  end
end
