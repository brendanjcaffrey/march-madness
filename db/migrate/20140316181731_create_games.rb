class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :gameID
      t.string :date
      t.string :homeTeam
      t.string :awayTeam
      t.float :homeOvrWL
      t.float :homeHomeWL
      t.float :awayOvrWL
      t.float :awayAwayWL
      t.float :homePoints
      t.float :homefgm
      t.float :homefga
      t.float :homefgPer
      t.float :hometwoMade
      t.float :hometwoAtt
      t.float :hometwoPer
      t.float :homethreeMade
      t.float :homethreeAtt
      t.float :homethreePer
      t.float :homeftm
      t.float :homefta
      t.float :homeftPer
      t.float :homeoffReb
      t.float :homedefReb
      t.float :hometotalReb
      t.float :homepps
      t.float :homeadjFG
      t.float :homeassist
      t.float :hometo
      t.float :homeapto
      t.float :homesteals
      t.float :homefouls
      t.float :homestealPerTO
      t.float :homestealPerFoul
      t.float :homeblocks
      t.float :homeblocksPerFoul  
      t.float :awaypoints
      t.float :awayfgm
      t.float :awayfga
      t.float :awayfgPer
      t.float :awaytwoMade
      t.float :awaytwoAtt
      t.float :awaytwoPer
      t.float :awaythreeMade
      t.float :awaythreeAtt
      t.float :awaythreePer
      t.float :awayftm
      t.float :awayfta
      t.float :awayftPer
      t.float :awayoffReb
      t.float :awaydefReb
      t.float :awaytotalReb
      t.float :awaypps
      t.float :awayadjFG
      t.float :awayassist
      t.float :awayto
      t.float :awayapto
      t.float :awaysteals
      t.float :awayfouls
      t.float :awaystealPerTO
      t.float :awaystealPerFoul
      t.float :awayblocks
      t.float :awayblocksPerFoul

      t.timestamps
    end
  end
end
