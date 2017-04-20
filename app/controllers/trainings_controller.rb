class TrainingsController < ApplicationController
  def index
    data = Training.get_trainings_by_user current_user
    render json: { success: true, data: data }
  end

  def show
    data = Training.by_user(current_user)
      .where(id: params[:id])
      .includes(:evolutions)
      .first
    unless data.nil?
      render json: { success: true, data: data.as_json(methods: :limited_evolutions) }
    else
      render json: { success: false, data: nil }
    end
  end

  def bulk_create
    ids = []
    data = training_bulk_params
    unless data[:trainings].blank?
      data[:trainings].each do |item|
        training = Training.find_or_create_by(
          user: current_user,
          name: item[:name],
          category: item[:category]
        )
        ids << training.id
      end
      Training.where(user_id: current_user.id)
        .where.not(id: ids)
        .destroy_all
    end
    data = Training.get_trainings_by_user current_user
    render json: { success: ids.any?, data: data }
  end

  private

  def training_bulk_params
    params.permit(trainings: [:category, :name])
  end
end
