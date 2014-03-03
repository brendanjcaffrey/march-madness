class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :date
      t.string :location
      t.string :opponent
      t.boolean :isWinner
      t.integer :teamScore
      t.integer :oppScore
      t.belongs_to :temp_team, index: true

      t.timestamps
    end
  end
end
