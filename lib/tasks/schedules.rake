require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

#TODO: include dependiencies, add tests, make into database, then make get team its own rake

namespace :schedules do
  desc 'Create files for each teams most up to date schedules'
  task :scrape => :environment do
    #EspnScraperHelper.get_teams()
    EspnScraperHelper.get_teams_and_confs()
    #EspnScraperHelper.get_all_schedules()
    EspnScraperHelper.get_all_games()
  end
end

