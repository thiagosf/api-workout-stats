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
      data[:trainings].each_with_index do |item, index|
        unless item[:current_name].blank?
          Training.where(
            user_id: current_user.id,
            name: item[:current_name]
          ).update_all(name: item[:name])
        end
        unless item[:current_category].blank?
          Training.where(
            user_id: current_user.id,
            category: item[:current_category]
          ).update_all(category: item[:category])
        end
        training = Training.find_or_create_by(
          user: current_user,
          name: item[:name],
          category: item[:category]
        )
        training.update_column :sort, index + 1
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
    params.permit(trainings: [
      :current_category,
      :category,
      :current_name,
      :name
    ])
  end
end
