class CreateTempTeams < ActiveRecord::Migration
  def change
    create_table :temp_teams do |t|
      t.string :name
      t.string :webExt

      t.timestamps
    end
  end
end
