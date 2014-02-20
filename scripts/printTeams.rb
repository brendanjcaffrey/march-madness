require 'espn'

client = ESPN::Client.new(api_key: '8eg4bt5zm92mvwjvne5agngr')

leagues = client.sports('basketball', 'mens-college-basketball',)
confs = leagues[0].leagues[0][:groups][0][:groups]

confs.each { |c|
	teams = client.teams('basketball', 'mens-college-basketball', group: c.groupId)	

	puts c.shortName
	puts "----------------"
	teams.each { |t|
		puts t.nickname
	}
	puts ""

	sleep(1)
}

