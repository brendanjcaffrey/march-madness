class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :rank
      t.string :webExt
      t.integer :conferenceWins
      t.integer :conferenceLosses
      t.integer :wins
      t.integer :losses
      t.belongs_to :conference, index: true

      t.timestamps
    end
  end
end

