class EvolutionsController < ApplicationController
  def save_or_update
    data = evolution_params
    if valid_training_id?(data[:training_id])
      date = Time.parse(data[:date]).strftime('%Y-%m-%d')
      evolution = Evolution.find_or_create_by(
        training_id: data[:training_id].to_i,
        date: date
      )
      if evolution.persisted?
        evolution.update_attributes!(
          weight: data[:weight].to_i,
          series: data[:series].to_i
        )
        render json: { success: true, data: evolution }
      else
        render json: { success: false }
      end
    else
      render json: { success: false, message: 'invalid training' }
    end
  end

  private

  def evolution_params
    params.require(:evolution).permit(
      :training_id,
      :weight,
      :series,
      :date
    )
  end

  def valid_training_id?(training_id)
    Training.where(
      id: training_id,
      user: current_user
      ).count > 0
  end
end
