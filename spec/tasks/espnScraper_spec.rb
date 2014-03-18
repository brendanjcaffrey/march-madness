require 'spec_helper'
require 'rake'
require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

describe EspnScraperHelper do
=begin
  describe '.get_confs()' do
    describe 'scrape ESPN and populate Conferences' do

      bigTen = nil
      acc = nil     

      before(:all) do
        Conference.delete_all
        Team.delete_all
        Game.delete_all

        EspnScraperHelper.get_confs()
        bigTen = Conference.find_by! name: 'Big Ten'
        acc = Conference.find_by! name: 'ACC'
      end

      it 'Conference should contain 33 entries' do
        assert(Conference.all.count == 33)
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

  describe '.get_teams_from_conf(conf)' do
    describe 'scrape ESPN and populate Teams from the given conference' do

      bigTen = nil
      acc = nil     
      illinois = nil
      duke = nil

      before(:all) do
        Conference.delete_all
        Team.delete_all
        Game.delete_all

        EspnScraperHelper.get_confs()
        bigTen = Conference.find_by! name: 'Big Ten'
        acc = Conference.find_by! name: 'ACC'
        get_teams_from_conf(bigTen)
        get_teams_from_conf(acc)
        illinois = Team.find_by! name: 'Illinois'
        duke = Team.find_by! name: 'Duke'
      end
  
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
=end
  describe '.get_team_scoring_stats(conf)' do
    describe 'scrape ESPN and populate Teams from the given conference' do

      before(:all) do
        Conference.delete_all
        Team.delete_all
        Game.delete_all

        EspnScraperHelper.get_confs()
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_scoring_stats(bigTen)
      end

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

  describe 'get_team_adv_scoring_stats(conf)' do
    describe 'scrape ESPN and populate Teams from the given conference' do

      before(:all) do
        Conference.delete_all
        Team.delete_all
        Game.delete_all

        EspnScraperHelper.get_confs()
        bigTen = Conference.find_by! name: 'Big Ten'
        get_teams_from_conf(bigTen)
        get_team_adv_scoring_stats(bigTen)
      end

    end
  end
=begin
 
#number of games for illinois 29
#one game for illinois (all stats)
  describe '.get_teams' do
    describe 'scrape ESPN and populate temp_teams with all teams and web extensions' do
  
  EspnScraperHelper.get_team_schedule(TempTeam.find_by! name: 'Illinois')
      it 'schedules is not empty' do
        assert(Schedule.all != nil)
      end

      it 'testing Illinois played the correct number of games (less than 35 due to games being played)' do
        assert(Schedule.all.count > 35)
      end

      it 'ensure that games contain correct details' do
        assert(Schedule.where(date: nil).count == 0)
        assert(Schedule.where(location: nil).count == 0)
        assert(Schedule.where(opponent: nil).count == 0)
        assert(Schedule.where(isWinner: nil).count == 0)
        assert(Schedule.where(teamScore: nil).count == 0)
        assert(Schedule.where(oppScore: nil).count == 0)
        assert(Schedule.where(temp_team_id: nil).count == 0)
      end

      it 'stats are correct for Illinois first game' do
        game = Schedule.first
        assert(game.date = "Fri, Nov 8")
        assert(game.location == "vs")
        assert(game.opponent == "Alabama State")
        assert(game.isWinner)
        assert(game.teamScore == 80)
        assert(game.oppScore == 63)
      end

    end
  end
=end
end
