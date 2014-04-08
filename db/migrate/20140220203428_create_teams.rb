class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :rank
      t.string :webExt
      t.string :logo
      t.integer :conferenceWins
      t.integer :conferenceLosses
      t.integer :wins
      t.integer :losses
      t.integer :homeWins
      t.integer :homeLosses
      t.integer :awayWins
      t.integer :awayLosses
      t.float :points
      t.float :defPoints
      t.float :fgm
      t.float :fga
      t.float :fgPer
      t.float :twoMade
      t.float :twoAtt
      t.float :twoPer
      t.float :threeMade
      t.float :threeAtt
      t.float :threePer
      t.float :ftm
      t.float :fta
      t.float :ftPer
      t.float :offReb
      t.float :defReb
      t.float :totalReb
      t.float :pps
      t.float :adjFG
      t.float :assist
      t.float :to
      t.float :apto
      t.float :steals
      t.float :fouls
      t.float :stealPerTO
      t.float :stealPerFoul
      t.float :blocks
      t.float :blocksPerFoul
      t.belongs_to :conference, index: true

      t.timestamps
    end
  end
end

