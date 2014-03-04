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

  describe '.get_teams' do
    describe 'scrape ESPN and populate temp_teams with all teams and web extensions' do
      EspnScraperHelper.get_team_schedule(TempTeam.find_by! name: 'Illinois')
      it 'schedules is not empty' do
        assert(true)
#number of games for illinois
#one game for illinois (all stats)
      end
    end
  end
end
