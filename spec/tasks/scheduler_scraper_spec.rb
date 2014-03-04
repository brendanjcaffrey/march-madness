require 'spec_helper'
require 'rake'
require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

describe EspnScraperHelper do
  describe '.get_teams' do
    describe 'scrape ESPN and populate temp_teams with all teams and web extensions' do
      EspnScraperHelper.get_teams

      illinois = TempTeam.find_by! name: 'Illinois'
      it 'temp_teams should contain "Illinois"' do
        assert(illinois != nil)
      end 
      it '"Illinois" should have the correct web extension' do
        assert(illinois.webExt = '356/illinois-fighting-illini')
      end 

      duke = TempTeam.find_by! name: 'Duke'
      it 'temp_teams should contain "Duke"' do
        assert(duke != nil)
      end 
      it '"Duke" should have the correct web extension' do
        assert(duke.webExt = '150/duke-blue-devils')
      end

      it 'temp_teams should contain 351 teams' do
        assert(TempTeam.all.count == 351)
      end

      it 'all teams should have a webExt' do
        assert(TempTeam.where(webExt: nil).count == 0)
      end   
    end
  end
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
end
