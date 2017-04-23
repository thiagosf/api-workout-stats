class Training < ApplicationRecord
  belongs_to :user
  has_many :evolutions, dependent: :destroy

  scope :by_user, -> (user) {
    where(user: user)
  }

  def self.get_trainings_by_user(user)
    output = []
    data = self.where(user: user).order(sort: :asc, category: :asc, name: :asc)
    data.each do |item|
      stats = []
      weight = 0
      lastWeight = 0
      evolutions = Evolution.where(training_id: item.id)
        .order(id: :desc)
        .limit(3)
      unless evolutions.blank?
        evolutions.each do |evolution|
          weight = evolution.weight if weight == 0
          lastWeight = evolution.weight if lastWeight == 0
          stats << {
            weight: evolution.weight,
            date: evolution.date
          }
        end
      end
      output << {
        id: item.id,
        category: item.category,
        name: item.name,
        weight: weight,
        lastWeight: lastWeight,
        stats: stats.reverse
      }
    end
    output
  end

  def limited_evolutions
    Evolution.where(training_id: self.id)
      .select(:id, :weight, :date, :series)
      .order(date: :desc)
      .limit(10)
      .all
      .reverse
  end
end
