require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

#TODO: include dependiencies, add tests, make into database, then make get team its own rake

namespace :espn do
  desc 'Create files for each teams most up to date statistics and games played'
  task :scrape => :environment do
    EspnScraperHelper.get_teams()
    EspnScraperHelper.get_games()
  end
end

