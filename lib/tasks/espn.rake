require "#{Rails.root}/app/helpers/espn_scraper_helper"
include EspnScraperHelper

# Rake Task that scrapes ESPN
# First gets all conferences, the all teams (and team stats) from known conferences, then all game statistics
# Fuctionalilty in EspnScraperHelper
# Run by 'rake espn:scrape' after database is migrated
namespace :espn do
  desc 'Create files for each teams most up to date statistics and games played'
  task :scrape => :environment do
    EspnScraperHelper.scrapeESPN()
  end
end

