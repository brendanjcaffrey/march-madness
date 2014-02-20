require 'espn'

class Parser
	def parse
		client = ESPN::Client.new(api_key: '8eg4bt5zm92mvwjvne5agngr')
		teams = client.teams('basketball', 'mens-college-basketball')

		$i = 0
		$num_teams = teams.length
		teams_json = '[ '

		while $i < $num_teams do
        		teams_json += '{ "id": ' + $i.to_s + ', "location": "' + teams[$i].location + '", "name": "' + teams[$i].name + '" },'
        		$i += 1
                end

		teams_json = teams_json[0...-1]
		teams_json += ' ]'

		teams_parsed = JSON.parse(teams_json)
		teams_parsed
	end
end
