class CreateEvolutions < ActiveRecord::Migration[5.0]
  def change
    create_table :evolutions do |t|
      t.references :training, foreign_key: true
      t.integer :weight
      t.integer :series
      t.date :date

      t.timestamps
    end
  end
end
