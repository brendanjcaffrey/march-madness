# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

conferences = {'Big 10' => ['Illinois', 'Indiana', 'Purdue', 'Ohio State', 'Michigan State', 'Iowa', 'Michigan',
                            'Penn State', 'Wisconsin', 'Minnesota', 'Nebraska', 'Northwestern'],
               'SEC' => ['Florida', 'Kentucky', 'Georgia', 'Missouri', 'LSU', 'Ole Miss', 'Tennessee', 'Arkansas',
                         'Vanderbilt', 'Texas A&M', 'Alabama', 'Auburn', 'Mississippi State', 'South Carolina']}

Conference.delete_all
Team.delete_all

conferences.each do |conf_name, teams|
  conf = Conference.new(name: conf_name)
  teams.each do |team_name|
    Team.create(name: team_name, conference: conf)
  end
end
