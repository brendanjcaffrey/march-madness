require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

#TODO: include dependiencies, add tests, make into database, then make get team its own rake

namespace :schedules do
  desc 'Create files for each teams most up to date schedules'
  task :scrape => :environment do
    Schedule.delete_all
    TempTeam.delete_all

    EspnScraperHelper.get_teams()

    Temp_team.find_each do |team|
      EspnScraperHelper.get_team_schedule(team)
    end
  end
end

