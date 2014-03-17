require 'spec_helper'
require 'rake'

describe 'espnAPI:scrape' do
  it 'should create the conferences and teams' do
    rake = Rake::Application.new
    Rake.application = rake
    Rake.application.rake_require('lib/tasks/espnAPI', [Rails.root.to_s])

    Rake::Task.define_task(:environment)
    task = rake['espnAPI:scrape']

    leagues = [double(:leagues => [{:groups => [{:groups => [double(:shortName => 'a', :groupId => 3)]}]}])]
    client = double(:sports => leagues)
    expect(client).to receive(:teams).with('basketball', 'mens-college-basketball', group: 3).and_return([double(:nickname => 'team1'), double(:nickname => 'team2')])
    expect(ESPN::Client).to receive(:new).and_return(client)

    task.invoke

    conf = Conference.first
    expect(conf.name).to eq('a')
    teams = conf.teams
    expect(teams[0].name).to eq('team1')
    expect(teams[1].name).to eq('team2')
  end
end

