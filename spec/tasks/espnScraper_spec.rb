require 'spec_helper'
require 'rake'
require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

describe EspnScraperHelper do

  # Before initializer for all the tests
  # Clears the database and gets all conferences
  before(:all) do
    Conference.delete_all
    Team.delete_all
    Game.delete_all
    get_confs()
  end

  # Tests to make sure get_confs() is working correctly
  # get_confs() should return conferences with names, webExt and logos
  describe '.get_confs()' do
    describe 'scrape ESPN and populate Conferences' do

      bigTen = nil
      acc = nil    

      # Initialization
      before(:all) do
        bigTen = Conference.find_by! name: 'Big Ten'
        acc = Conference.find_by! name: 'ACC'
      end

      # Tests
      it 'Conference should contain 33 entries' do
        assert(Conference.all.count  == 33)
      end    
      it 'all conferences should have a name' do
        assert(Conference.where(name: nil).count == 0)
      end
      it 'all conferences should have a webExt' do
        assert(Conference.where(webExt: nil).count == 0)
      end
      it 'all conferences should have a logo' do
        assert(Conference.where(logo: nil).count == 0)
      end
      it 'conference should contain "Big Ten"' do
        assert(bigTen != nil)
      end 
      it '"Big Ten" should have the correct web extension' do
        assert(bigTen.webExt = 'http://espn.go.com/ncb/conference?confId=7')
      end 
      it '"Big Ten" should have the correct logo' do
        assert(bigTen.logo = 'http://a.espncdn.com/i/teamlogos/ncaa_conf/sml/trans/big_ten.gif')
      end 
      it 'conference should contain "ACC"' do
        assert(acc != nil)
      end 
      it '"ACC" should have the correct web extension' do
        assert(acc.webExt = '/ncb/conference?confId=2')
      end 
      it '"ACC" should have the correct logo' do
        assert(acc.logo = 'http://a.espncdn.com/i/teamlogos/ncaa_conf/sml/trans/acc.gif')
      end 
    end
  end

  # Tests to make sure get_teams_from_conf(conf) is working correctly
  # get_teams_from_conf(conf) should return teams with names, webExt, etc
  describe '.get_teams_from_conf(conf)' do
    describe 'scrape ESPN and populate Teams from the given conference' do

      bigTen = nil
      acc = nil     
      illinois = nil
      duke = nil

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        acc = Conference.find_by! name: 'ACC'
        get_teams_from_conf(bigTen)
        get_teams_from_conf(acc)
        illinois = Team.find_by! name: 'Illinois'
        duke = Team.find_by! name: 'Duke'
      end
  
      # Tests
      it 'all teams should have a name' do
        assert(Team.where(name: nil).count == 0)
      end
      it 'all teams should have a rank' do
        assert(Team.where(rank: nil).count == 0)
      end
      it 'all teams should have a webExt' do
        assert(Team.where(webExt: nil).count == 0)
      end
      it 'all teams should have wins' do
        assert(Team.where(wins: nil).count == 0)
      end
      it 'all teams should have losses' do
        assert(Team.where(losses: nil).count == 0)
      end
      it 'Big 10 should contain 12 entries and ACC should contain 15 entries' do
        assert(Team.all.count == 27)
      end  
      it 'Teams should contain "Illinois"' do
        assert(illinois != nil)
      end 
      it '"Illinois" should have the correct web extension' do
        assert(illinois.webExt = '356/illinois-fighting-illini')
      end 
      it 'temp_teams should contain "Duke"' do
        assert(duke != nil)
      end 
      it '"Duke" should have the correct web extension' do
        assert(duke.webExt = '150/duke-blue-devils')
      end
    end
  end

  # Tests to make sure get_team_scoring_stats(conf) is working correctly
  # get_team_scoring_stats(confs) should return teams with points, shooting averages
  describe '.get_team_scoring_stats(conf)' do
    describe 'scrape ESPN and update Teams with scoring stats' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_scoring_stats(bigTen)
      end

      # Tests
      it 'all teams should have points' do
        assert(Team.where(points: nil).count == 0)
      end
      it 'all teams points is above 0' do
        assert(Team.where('points < 0').count == 0)
      end
      it 'all teams should have a field goal percentage' do
        assert(Team.where(fgPer: nil).count == 0)
      end
      it 'all teams field goal percentage is between 0 and 1' do
        assert(Team.where('fgPer < 0').count == 0 && Team.where('fgPer > 1').count == 0)
      end
      it 'all teams should have a three point percentage' do
        assert(Team.where(threePer: nil).count == 0)
      end
      it 'all teams three point percentage is between 0 and 1' do
        assert(Team.where('threePer < 0').count == 0 && Team.where('threePer > 1').count == 0)
      end
      it 'all teams should have free throw percentage' do
        assert(Team.where(ftPer: nil).count == 0)
      end
      it 'all teams free throw percentage is between 0 and 1' do
        assert(Team.where('ftPer < 0').count == 0 && Team.where('ftPer > 1').count == 0)
      end
    end
  end

  # Tests to make sure get_team_adv_scoring_stats(conf) is working correctly
  # get_team_adv_scoring_stats(conf) should return teams with twoPer, pps, adjFG
  describe 'get_team_adv_scoring_stats(conf)' do
    describe 'scrape ESPN and update Teams with advanced scoring stats' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_adv_scoring_stats(bigTen)
      end

      # Tests
      it 'all teams should have a two point percentage' do
        assert(Team.where(twoPer: nil).count == 0)
      end
      it 'all teams two point percentage is between 0 and 1' do
        assert(Team.where('twoPer < 0').count == 0 && Team.where('fgPer > 1').count == 0)
      end
      it 'all teams should have an adjusted field goal percentage' do
        assert(Team.where(adjFG: nil).count == 0)
      end
      it 'all teams adjusted field goal percentage is between 0 and 1' do
        assert(Team.where('adjFG < 0').count == 0 && Team.where('adjFG > 1').count == 0)
      end
      it 'all teams should have points per shot' do
        assert(Team.where(pps: nil).count == 0)
      end
      it 'all teams points per shot is greater than 0' do
        assert(Team.where('pps < 0').count)
      end
    end
  end

  # Tests to make sure get_team_assists_stats(conf) is working correctly
  # get_team_assists_stats(conf) should return teams with assists, turnovers, etc
  describe 'get_team_assists_stats(conf)' do
    describe 'scrape ESPN and update Teams with assist stats' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_assists_stats(bigTen)
      end

      # Tests
      it 'all teams should have a assists per game' do
        assert(Team.where(assist: nil).count == 0)
      end
      it 'all teams should have turnover per game' do
        assert(Team.where(to: nil).count == 0)
      end
      it 'all teams should have assists per turnover' do
        assert(Team.where(apto: nil).count == 0)
      end
    end
  end

  # Tests to make sure get_team_rebounds_stats(conf) is working correctly
  # get_team_rebounds_stats() should return teams with off/def/total rebounds
  describe 'get_team_rebounds_stats(conf)' do
    describe 'scrape ESPN and update Teams with rebounding stats' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_rebounds_stats(bigTen)
      end

      # Tests
      it 'all teams should have a offensive rebounds per game' do
         assert(Team.where(offReb: nil).count == 0)
      end
      it 'all teams should have defensive rebounds per game' do
        assert(Team.where(defReb: nil).count == 0)
      end
      it 'all teams should have rebounds per game' do
        assert(Team.where(totalReb: nil).count == 0)
      end
    end
  end

  # Tests to make sure get_team_steals_stats(conf) is working correctly
  # get_team_steals(conf) should return teams with steals, fouls, etc
  describe 'get_team_steals_stats(conf)' do
    describe 'scrape ESPN and update Teams with steal stats' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_steals_stats(bigTen)
      end

      # Tests
      it 'all teams should have a steals per game' do
        assert(Team.where(steals: nil).count == 0)
      end
      it 'all teams should have fouls per game' do
        assert(Team.where(fouls: nil).count == 0)
      end
      it 'all teams should have steals per turnover per game' do
        assert(Team.where(stealPerTO: nil).count == 0)
      end
      it 'all teams should have steals per foul per game' do
        assert(Team.where(stealPerFoul: nil).count == 0)
      end
    end
  end

  # Tests to make sure get_team_blocks_stats(conf) is working correctly
  # get_cteam_blocks_stats should return teams with blocks
  describe 'get_team_blocks_stats(conf)' do
    describe 'scrape ESPN and update Teams with block stats' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_blocks_stats(bigTen)
      end

      # Tests
      it 'all teams should have a blocks per game' do
        assert(Team.where(blocks: nil).count == 0)
      end
      it 'all teams should have block per foul per game' do
        assert(Team.where(blocksPerFoul: nil).count == 0)
      end
    end
  end

  # Tests to make sure get_team_logo(team) is working correctly
  # get_team_logo(team) should return the team's logo JPEG
  describe 'get_team_logo(team)' do
    describe 'scrape ESPN and update Teams with logo' do

      illinois = nil

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        Team.find_each do |team|
          get_team_logo(team)
        end
        illinois = Team.find_by! name: 'Illinois'
      end

      # Tests
      it 'all teams should have a logo' do
        assert(Team.where(logo: nil).count == 0)
      end
      it 'illinois has the correct logo' do
        assert(illinois.logo == "http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/356.png&w=110&h=110&transparent=true")
      end
    end
  end

  # Tests to make sure get_conference_standings(conf) is working correctly
  # get_conference_standings() should return teams with wins, points allowed, etc
  describe 'get_conference_standings(conf)' do
    describe 'scrape ESPN and update Teams with conference standings' do

      # Initialization
      before(:all) do
        Team.delete_all
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_conference_standings(bigTen)
      end

      # Tests
      it 'all teams should have home wins' do
        assert(Team.where(homeWins: nil).count == 0)
      end
      it 'all teams should have home losses' do
        assert(Team.where(homeLosses: nil).count == 0)
      end
      it 'all teams should have away wins' do
        assert(Team.where(awayWins: nil).count == 0)
      end
      it 'all teams should have away losses' do
        assert(Team.where(awayLosses: nil).count == 0)
      end
      it 'all teams should have points allowed' do
        assert(Team.where(defPoints: nil).count == 0)
      end
    end
  end

  # Tests to make sure get_game_stats(game) is working correctly
  # get_game_stats(game) should return game with valid game data
  describe 'get_game_stats(game)' do
    describe 'scrape ESPN and update a game with given stats for that game' do

      game = nil
   
      # Initialization
      before(:all) do
        game = Game.create(gameID: 400510014)
        get_game_stats(game)
      end

      # Tests
      it 'games should contain home team points' do
        assert(Game.where(homePoints: nil).count == 0)
      end
      it 'games should contain home team field goal percentage' do
        assert(Game.where(homefgPer: nil).count == 0)
      end
      it 'home team field goal percentage is between 0 and 1' do
        assert(Game.where('homefgPer < 0').count == 0 && Game.where('homefgPer > 1').count == 0)
      end
      it 'games should contain home team three point percentage' do
        assert(Game.where(homethreePer: nil).count == 0)
      end
      it 'home team three point percentage is between 0 and 1' do
        assert(Game.where('homethreePer < 0').count == 0 && Game.where('homethreePer > 1').count == 0)
      end
      it 'games should contain home team free throw percentage' do
        assert(Game.where(homeftPer: nil).count == 0)
      end
      it 'home team free throw percentage is between 0 and 1' do
        assert(Game.where('homeftPer < 0').count == 0 && Game.where('homeftPer > 1').count == 0)
      end
      it 'games should contain home team rebounds' do
        assert(Game.where(hometotalReb: nil).count == 0)
      end
      it 'games should contain home team assists' do
        assert(Game.where(homeassist: nil).count == 0)
      end
      it 'games should contain home team turnovers' do
        assert(Game.where(hometo: nil).count == 0)
      end
      it 'games should contain home team steals' do
        assert(Game.where(homesteals: nil).count == 0)
      end
      it 'games should contain home team blocks' do
        assert(Game.where(homeblocks: nil).count == 0)
      end
      it 'games should contain home team fouls' do
        assert(Game.where(homefouls: nil).count == 0)
      end

      it 'games should contain away team points' do
        assert(Game.where(awaypoints: nil).count == 0)
      end
      it 'games should contain away team field goal percentage' do
        assert(Game.where(awayfgPer: nil).count == 0)
      end
      it 'away team field goal percentage is between 0 and 1' do
        assert(Game.where('awayfgPer < 0').count == 0 && Game.where('awayfgPer > 1').count == 0)
      end
      it 'games should contain away team three point percentage' do
        assert(Game.where(awaythreePer: nil).count == 0)
      end
      it 'away team three point percentage is between 0 and 1' do
        assert(Game.where('awaythreePer < 0').count == 0 && Game.where('awaythreePer > 1').count == 0)
      end
      it 'games should contain away team free throw percentage' do
        assert(Game.where(awayftPer: nil).count == 0)
      end
      it 'away team free throw percentage is between 0 and 1' do
        assert(Game.where('awayftPer < 0').count == 0 && Game.where('awayftPer > 1').count == 0)
      end
      it 'games should contain away team rebounds' do
        assert(Game.where(awaytotalReb: nil).count == 0)
      end
      it 'games should contain away team assists' do
        assert(Game.where(awayassist: nil).count == 0)
      end
      it 'games should contain away team turnovers' do
        assert(Game.where(awayto: nil).count == 0)
      end
      it 'games should contain away team steals' do
        assert(Game.where(awaysteals: nil).count == 0)
      end
      it 'games should contain away team blocks' do
        assert(Game.where(awayblocks: nil).count == 0)
      end
      it 'games should contain away team fouls' do
        assert(Game.where(awayfouls: nil).count == 0)
      end
    end
  end
end
