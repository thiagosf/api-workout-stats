class CreateTrainings < ActiveRecord::Migration[5.0]
  def change
    create_table :trainings do |t|
      t.references :user, foreign_key: true
      t.string :category
      t.string :name
      t.integer :sort, default: 0

      t.timestamps
    end
  end
end
