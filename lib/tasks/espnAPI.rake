require 'espn'

namespace :espnAPI do
  desc 'Flush conference and team data from the database and pull in new teams'
  task :scrape => :environment do
    Conference.delete_all
    Team.delete_all

    client = ESPN::Client.new(api_key: '8eg4bt5zm92mvwjvne5agngr')
    leagues = client.sports('basketball', 'mens-college-basketball')
    confs = leagues[0].leagues[0][:groups][0][:groups]

    confs.each { |c|
      sleep 1.0
      conf = Conference.create(name: c.shortName)

      teams = client.teams('basketball', 'mens-college-basketball', group: c.groupId)	
      teams.each { |t|
        Team.create(name: t.nickname, conference: conf)
      }
    }
  end
end
