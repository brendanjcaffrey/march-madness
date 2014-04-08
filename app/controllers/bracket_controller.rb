class BracketController < ApplicationController
  def root
    south = to_models([nil, 'Florida', 'Kansas', 'Syracuse', 'UCLA', 'Virginia Commonwealth', 'Ohio State',
                       'New Mexico', 'Colorado', 'Pittsburgh', 'Stanford', 'Dayton', 'Stephen F. Austin', 'Tulsa',
                       'Western Michigan', 'Eastern Kentucky', 'Albany'])
    east = to_models([nil, 'Virginia', 'Villanova', 'Iowa State', 'Michigan State', 'Cincinnati', 'North Carolina',
                      'Connecticut', 'Memphis', 'George Washington', 'Saint Joseph\'s', 'Providence', 'Harvard',
                      'Delaware', 'North Carolina Central', 'Milwaukee', 'Coastal Carolina'])
    west = to_models([nil, 'Arizona', 'Wisconsin', 'Creighton', 'San Diego State', 'Oklahoma', 'Baylor', 'Oregon',
                      'Gonzaga', 'Oklahoma State', 'Brigham Young', 'Nebraska', 'North Dakota State',
                      'New Mexico State', 'Louisiana-Lafayette', 'American University', 'Weber State'])
    midwest = to_models([nil, 'Wichita State', 'Michigan', 'Duke', 'Louisville', 'Saint Louis', 'Massachusetts',
                         'Texas', 'Kentucky', 'Kansas State', 'Arizona State', 'Tennessee', 'North Carolina State',
                         'Manhattan', 'Mercer', 'Wofford', 'Cal Poly'])

    @groups = {'South' => south, 'East' => east, 'West' => west, 'Midwest' => midwest}
  end

  private

  def to_models(teams)
    teams.map do |team_name|
      next if team_name == nil
      team = Team.where(name: team_name).first
      raise Exception.new(team) if team == nil
      team
    end
  end
end
